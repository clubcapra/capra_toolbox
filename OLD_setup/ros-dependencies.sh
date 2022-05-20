#!/bin/bash
if [[ ! -f "/etc/ros/rosdep/sources.list.d/20-default.list" ]]
then
    sudo rosdep init
fi

rosdep update

read -p "What is the full path to your catkin workspace (where the src is)" path_catkin
rosdep install --from-paths $path_catkin --ignore-src --rosdistro kinetic -y

wstool update -t src