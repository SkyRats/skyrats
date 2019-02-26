#!/bin/bash
############################################################
# Script para instalação dos frameworks de desenvolvimento #
# - ROS lunar (com gazebo7)				   #
# - MAVROS						   #
# - Firmware PX4					   #
# - Dependências (pip, git, pandas - do script common_deps)#
# - Tensorflow e Keras					   #
# 		     Equipe Skyrats 			   #
############################################################

if [[ $UID != 0 ]]; then
	echo "This script require root privileges!" 1>&2
	exit 1
fi

sudo apt-get update && sudo apt-get upgrade

# Removing modemmanager
echo "We must first remove modemmanager"
sudo apt-get remove modemmanager -y

# Dependencies
echo "Installing common dependencies"
sudo apt-get update -y
sudo apt-get install git zip qtcreator cmake build-essential genromfs ninja-build -y

## Gazebo simulator dependencies
sudo apt-get install protobuf-compiler libeigen3-dev libopencv-dev -y

# Required python packages
sudo apt-get install python-argparse python-empy python-toml python-numpy python-dev python-pip -y
sudo apt-get install python-wstool python-rosinstall-generator python-catkin-tools -y
sudo -H pip install --upgrade pip
sudo -H pip install pandas jinja2 pyserial pyulog

# Install FastRTPS 1.5.0 and FastCDR-1.0.7 (high performance publish subscribe framework to share data in distributed systems)

fastrtps_dir=$HOME/eProsima_FastRTPS-1.5.0-Linux
echo "Installing FastRTPS to: $fastrtps_dir"
if [ -d "$fastrtps_dir" ]
then
    echo " FastRTPS already installed."
else
    pushd .
    cd ~
    wget http://www.eprosima.com/index.php/component/ars/repository/eprosima-fast-rtps/eprosima-fast-rtps-1-5-0/eprosima_fastrtps-1-5-0-linux-tar-gz -O eprosima_fastrtps-1-5-0-linux.tar.gz
    tar -xzf eprosima_fastrtps-1-5-0-linux.tar.gz eProsima_FastRTPS-1.5.0-Linux/
    tar -xzf eprosima_fastrtps-1-5-0-linux.tar.gz requiredcomponents
    tar -xzf requiredcomponents/eProsima_FastCDR-1.0.7-Linux.tar.gz
    cpucores=$(( $(lscpu | grep Core.*per.*socket | awk -F: '{print $2}') * $(lscpu | grep Socket\(s\) | awk -F: '{print $2}') ))
    cd eProsima_FastCDR-1.0.7-Linux; ./configure --libdir=/usr/lib; make -j$cpucores; sudo make install
    cd ..
    cd eProsima_FastRTPS-1.5.0-Linux; ./configure --libdir=/usr/lib; make -j$cpucores; sudo make install
    cd ..
    rm -rf requiredcomponents eprosima_fastrtps-1-5-0-linux.tar.gz
    popd
fi

## jMAVSim simulator dependencies
echo "Installing jMAVSim simulator dependencies"
sudo apt-get install ant openjdk-8-jdk openjdk-8-jre -y

# Clone PX4/Firmware
clone_dir=~/src
echo "Cloning PX4 to: $clone_dir."
if [ -d "$clone_dir" ]
then
    echo " Firmware already cloned."
else
    mkdir -p $clone_dir
    cd $clone_dir
    git clone https://github.com/PX4/Firmware.git
fi


# Installing ROS Lunar
# Setup Keys
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update
# Get ROS + Gazebo
sudo apt-get install ros-lunar-desktop-full -y
# Initialize rosdep
sudo rosdep init
rosdep update
# Setup environment
## Setup environment variables
rossource="source /opt/ros/lunar/setup.bash"
if grep -Fxq "$rossource" ~/.bashrc; then echo ROS setup.bash already in .bashrc;
else echo "$rossource" >> ~/.bashrc; fi
eval $rossource

sudo apt-get install ros-lunar-catkin-pip

# Gets catkin_ws from github
cd ~/
git clone https://github.com/caio-freitas/catkin_ws

echo "HEEEEEEEEEEEEEEEEEEEEEEEY YOOU!!"
echo "Download a text editor (Atom is recommended)"
echo "Search in the directory catkin_ws for ALL occurences of the word 'caio'"
echo "Replace all of them by your computer's name"
echo "After this procedure, type [y + ENTER]"
read ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        echo "Good boy"
fi
echo "HEEEEEEEEEEEEEEEEEEEEEEEY YOOOOOU!!"
echo "Now use the same text editor to"
echo "search in the directory catkin_ws for ALL occurences of the word 'kinetic'"
echo "Replace all of them by 'lunar'"
echo "After this procedure, type [y + ENTER]"
read ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        echo "Gooooood boy"
fi

# Building catkin_ws
echo "Building catkin_ws"
cd ~/catkin_ws
catkin_make
source ~/catkin_ws/devel/setup.bash

sudo apt install python-wstool
sudo apt install python-rosinstall-generator


### MAVROS source installation
## Initialise wstool
wstool init ~/catkin_ws/src
## Installing MAVLink
rosinstall_generator --rosdistro lunar mavlink | tee /tmp/mavros.rosinstall
## Installing MAVROS
rosinstall_generator --upstream mavros | tee -a /tmp/mavros.rosinstall

wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src -j4
rosdep install --from-paths src --ignore-src -y

## Create workspace & deps
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src -j4
rosdep install --from-paths src --ignore-src -y

## MAVROS binary installation
sudo apt install ros-lunar-mavros ros-lunar-mavros-extras ros-lunar-mavros-msgs


## Installing Geographiclib datasets

run_get() {
	local dir="$1"
	local tool="$2"
	local model="$3"

	files=$(shopt -s nullglob dotglob; echo /usr/share/GeographicLib/$dir/$model* /usr/local/share/GeographicLib/$dir/$model*)
	if (( ${#files} )); then
		echo "GeographicLib $tool dataset $model already exists, skipping"
		return
	fi

	echo "Installing GeographicLib $tool $model"
	geographiclib-get-$tool $model >/dev/null 2>&1
}

# check which command script is available
if hash geographiclib-get-geoids; then
	run_get geoids geoids egm96-5
	run_get gravity gravity egm96
	run_get magnetic magnetic emm2015
elif hash geographiclib-datasets-download; then # only allows install the goid model dataset
	geographiclib-datasets-download egm96_5;
else
	echo "OS not supported! Check GeographicLib page for supported OS and lib versions." 1>&2
fi

echo "Installation completed!"
echo "Type [r + ENTER] to reboot"
read ans
if [ "$ans" = "r" ]; then
        echo "Good boy"
	reboot
fi
