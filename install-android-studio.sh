cd
wget -q wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/4.1.3.0/android-studio-ide-201.7199119-linux.tar.gz
tar xf android-studio-ide-*-linux.tar.gz
rm android-studio-ide-*-linux.tar.gz
cat >> ~/.bashrc <<EOF
export ANDROID_HOME=\$HOME/Android/Sdk
export PATH=\$PATH:\$ANDROID_HOME/emulator
export PATH=\$PATH:\$ANDROID_HOME/tools
export PATH=\$PATH:\$ANDROID_HOME/tools/bin
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
EOF
# allow access to my Android Phone
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2a70", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android-usb.rules
echo "Set up Android Studio for React Native according to https://reactnative.dev/docs/environment-setup"
