#!/usr/bin/env python3
"""
Read the current XKB keyboard state, unlock *all* locked modifiers,
and print the state again.

Requires:
    * Linux with X11
    * libX11.so
    * XKB extension
"""

import ctypes
from ctypes import POINTER, Structure, c_uint, c_ushort, c_ubyte, c_int


# ----------------------------------------------------------------------
# Load libX11 and constants
# ----------------------------------------------------------------------
libX11 = ctypes.CDLL("libX11.so.6")

XkbUseCoreKbd = 0x0100

# Modifier masks (standard X11 masks)
ShiftMask   = 1 << 0
LockMask    = 1 << 1
ControlMask = 1 << 2
Mod1Mask    = 1 << 3
Mod2Mask    = 1 << 4
Mod3Mask    = 1 << 5
Mod4Mask    = 1 << 6
Mod5Mask    = 1 << 7

mod_name = {
    ShiftMask:   "Shift",
    LockMask:    "Lock",
    ControlMask: "Control",
    Mod1Mask:    "Mod1",
    Mod2Mask:    "Mod2",
    Mod3Mask:    "Mod3",
    Mod4Mask:    "Mod4",
    Mod5Mask:    "Mod5",
}

# ----------------------------------------------------------------------
# XKB structures
# ----------------------------------------------------------------------
class XkbStateRec(Structure):
    _fields_ = [
        ("group",           c_ubyte),
        ("locked_group",    c_ubyte),
        ("base_group",      c_ushort),
        ("latched_group",   c_ushort),
        ("mods",            c_ubyte),
        ("base_mods",       c_ubyte),
        ("latched_mods",    c_ubyte),
        ("locked_mods",     c_ubyte),
        ("compat_state",    c_ubyte),
        ("grab_mods",       c_ubyte),
        ("compat_grab_mods",c_ubyte),
        ("lookup_mods",     c_ubyte),
        ("compat_lookup_mods", c_ubyte),
        ("ptr_buttons",     c_ushort),
    ]

# ----------------------------------------------------------------------
# Function prototypes
# ----------------------------------------------------------------------
XkbGetState = libX11.XkbGetState
XkbGetState.argtypes = [c_uint, c_ushort, POINTER(XkbStateRec)]
XkbGetState.restype = c_int

XkbLockModifiers = libX11.XkbLockModifiers
XkbLockModifiers.argtypes = [c_uint, c_uint, c_uint, c_uint]
XkbLockModifiers.restype = c_int

# ----------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------
def open_display():
    dpy = libX11.XOpenDisplay(None)
    if not dpy:
        raise RuntimeError("Cannot open X display")
    return dpy

def mask_to_names(mask):
    return " ".join(name for bit, name in mod_name.items() if mask & bit) or "(none)"

def print_state(label, state):
    print(f"\n=== {label} ===")
    print(f"Group (effective) : {state.group}")
    print(f"  locked group    : {state.locked_group}")
    print(f"  base group      : {state.base_group}")
    print(f"  latched group   : {state.latched_group}")

    locked = state.locked_mods
    effective = state.mods

    print("Locked modifiers   :", mask_to_names(locked))
    print("Effective modifiers:", mask_to_names(effective))
    print("  (base   :", mask_to_names(state.base_mods), ")")
    print("  (latched:", mask_to_names(state.latched_mods), ")")


# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------
def main():
    dpy = open_display()
    try:
        # ----- 1. Initial state -----
        state = XkbStateRec()
        rc = XkbGetState(dpy, XkbUseCoreKbd, ctypes.byref(state))
        if rc != 0:
            raise RuntimeError(f"XkbGetState failed (rc={rc})")
        print_state("INITIAL STATE", state)

        # ----- 2. Unlock *all* modifiers -----
        # mask = bits we *affect* (all 8 standard modifiers)
        # values = bits we want to *set* (0 = unlock)
        affect_mask = (ShiftMask | LockMask | ControlMask |
                       Mod1Mask | Mod2Mask | Mod3Mask |
                       Mod4Mask | Mod5Mask)
        values = 0                     # unlock everything

        rc = XkbLockModifiers(dpy, XkbUseCoreKbd, affect_mask, values)
        if rc != 1:                    # Success returns True (1)
            raise RuntimeError(f"XkbLockModifiers failed (rc={rc})")

        # ----- 3. State after unlocking -----
        rc = XkbGetState(dpy, XkbUseCoreKbd, ctypes.byref(state))
        if rc != 0:
            raise RuntimeError(f"XkbGetState failed after unlock (rc={rc})")
        print_state("STATE AFTER UNLOCKING ALL MODIFIERS", state)

    finally:
        libX11.XCloseDisplay(dpy)


if __name__ == "__main__":
    main()
