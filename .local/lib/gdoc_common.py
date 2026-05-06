"""Shared helpers for gdoc-ro / gdoc-rw."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import urllib.request
from typing import Any

DRIVE_SCOPE = "https://www.googleapis.com/auth/drive"
DOCS_API = "https://docs.googleapis.com/v1/documents"
DRIVE_API = "https://www.googleapis.com/drive/v3/files"

HTTP_TIMEOUT = 30


def get_token() -> str:
    token = os.environ.get("GDOC_TOKEN")
    if token:
        return token
    return subprocess.check_output(
        ["gcloud", "auth", "print-access-token", f"--scopes={DRIVE_SCOPE}"],
        text=True,
    ).strip()


def extract_id(arg: str) -> str:
    """Accept full URL or bare document id."""
    m = re.search(r"/document/d/([a-zA-Z0-9_-]+)", arg)
    return m.group(1) if m else arg


def http(method: str, url: str, *, token: str, body: Any = None, raw: bool = False) -> Any:
    data = None
    headers = {"Authorization": f"Bearer {token}"}
    if body is not None:
        data = json.dumps(body).encode("utf-8")
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(url, data=data, method=method, headers=headers)
    with urllib.request.urlopen(req, timeout=HTTP_TIMEOUT) as r:
        resp = r.read()
    if raw:
        return resp
    return json.loads(resp) if resp else {}


def run_cli(parser: argparse.ArgumentParser, help_text: str, argv: list[str]) -> None:
    args = parser.parse_args(argv)
    if args.help or not args.cmd or args.cmd == "help":
        print(help_text.strip())
        return
    args.func(args)
