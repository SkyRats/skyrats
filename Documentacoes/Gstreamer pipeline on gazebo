# Video Streaming on Gazebo with Gstreamer pipeline

## 1. Install Gstreamer
~~~~
sudo apt-get install $(apt-cache --names-only search ^gstreamer1.0-* | awk '{ print $1 }' | grep -v gstreamer1.0-hybris) -y
~~~~

## 2. Edit Firmware
Now we need to edit the Firmware CMakeLists.txt to enable gstreamer plugin. We do that by editing the following line

~~~~
option(BUILD_GSTREAMER_PLUGIN "enable gstreamer plugin" "ON")
~~~~

After that, we need to recompile the firmware with

~~~~
make clean
make posix_sitl_default gazebo
~~~~

## 3. 




Reference: https://dev.px4.io/v1.8.0/en/simulation/gazebo.html
