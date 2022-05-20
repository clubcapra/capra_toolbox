#!/bin/bash

# Condition to check if the script is launch in the right directory.
if [[ $0 != "setup/install.bash"  && $0 != "./setup/install.bash" ]]
then 
    echo "You're in the wrong directory to launch the script."
    echo "Please set your directory to capra_toolbox and launch the script from setup/install.bash"
    echo "You're current directory : $0"
    exit
fi

source setup/env.sh

read -p "Do you want to install the full-desktop version ? [Y/n]" -n 1 -r
echo

fullVersion=false
if [[ $REPLY =~ ^[Yy]$ ]]
then
    fullVersion=true
fi

source setup/ros-setup.sh

echo "${step}Building workspace... This can take a while${reset}"
{
    source /opt/ros/kinetic/setup.bash

    catkin_make >> $logFile

    source devel/setup.bash
}

echo "
${green}===========================================================================================
Takin installation successful.
===========================================================================================${reset}
"

read -p "${warning}{Warning}${reset} To complete your installation, you need to reboot your computer. Do you want to reboot now ? [Y/n]" -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo reboot now
fi

exit