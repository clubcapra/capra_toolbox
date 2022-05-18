#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    echo "Now that I have you attention, be sure to have downloaded ros-melodic-desktop-full before running this"
    echo "List of unincluded capra packages:"

    rejects=(
        "capra_vision_visp"
        "capra_co2_ros"
        "capra_headlight_ros"
        "capra_motion_detection"
        "yolo_hazmat"
        "TPV_controller"
    )

    exit 1
fi


# List of repos with their github repository names
echo "Listing packages to be installed"
capra_repo_list=(
    "capra_estop"
    "ovis"
    "ros_astra_camera"
    "ovis_robotiq_gripper"
    "capra_audio_common"
    "capra_launch_handler"
    "capra_thermal_cam"
)

for i in "${capra_repo_list[@]}"
do
	echo "$i"
done

# Download and install capra_web_ui latest release
echo "Downloading and installing the latest capra_web_ui"
cd ~/Downloads
curl -s https://api.github.com/repos/clubcapra/capra_web_ui/releases/latest \
| grep "capra_web_ui_setup.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
dpkg -i capra_web_ui_setup.deb

# Download all repos listed
echo "Creating Workspace"
cd ~/
mkdir capra_ws && cd capra_ws/
mkdir src && cd src/

for i in "${capra_repo_list[@]}"
do
	git clone https://github.com/clubcapra/$i
done

read -p "Which robot do you want to add?" robot
git clone https://github.com/clubcapra/$robot

# Give file ownership to user
current_user=$(logname)
chown -R $current_user ~/capra_ws/

# Rosdep 
echo "Installing and initiating rosdep"
read -p "Is rosdep already installed on this device? [y/n]" answer
if [[ "$answer" == "n" ]]; then
    sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
    sudo rosdep init
    sudo rosdep fix-permissions
    rosdep update
fi
cd ~/capra_ws/
rosdep install --rosdistro melodic --from-paths src --ignore-src -r -y

echo "Building workspace, be sure to verify if any error occurs"
cd ~/capra_ws
source /opt/ros/melodic/setup.bash
catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python2 -Wno-dev

echo "Initial capra setup complete"

# -- MISSING REPOS THEIR RESPECTIVE REASON --

# Removed from Robocup Rescue League
# capra_co2_ros 
# capra_motion_detection (requires OpenCV, instructions in its README)

# Name doesn't respect established norm
# TPV_Controller
# yolo_hazmat

# Unfinished
# yolo_hazmat
# capra_headlight_ros

# Doesn't compile
# capra_vision_visp