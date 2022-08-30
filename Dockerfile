# syntax=docker/dockerfile:1
FROM ros:melodic-ros-base-bionic

ARG BUILD_DATE
ARG VERSION
ARG CAPRA_USER=capra
ARG CAPRA_UID=50000
ARG BASE_LIB_NAME=capra_common

LABEL maintainer="capra@clubcapra.com"
LABEL net.etsmtl.capra.base_lib.build-date=${BUILD_DATE}
LABEL net.etsmtl.capra.base_lib.version=${VERSION}
LABEL net.etsmtl.capra.base_lib.name=${BASE_LIB_NAME}

## Common environment variables
ENV ROS_LANG_DISABLE=genlisp:geneus
ENV CAPRA_USER=${CAPRA_USER}
ENV CAPRA_HOME=/home/${CAPRA_USER}
ENV CAPRA_UID=${CAPRA_UID}
ENV ROS_WS_SETUP=/opt/ros/${ROS_DISTRO}/setup.bash

## Environment variables for base library
ENV BASE_LIB_WS=${CAPRA_HOME}/base_lib_ws
ENV BASE_LIB_WS_SETUP=${BASE_LIB_WS}/devel/setup.bash
ENV BASE_LIB_NAME=${BASE_LIB_NAME}
ENV BASE_LIB_PATH=${BASE_LIB_WS}/src/${BASE_LIB_NAME}


## Extra dependencies (GIT and ROS Remote Debuging)
RUN apt-get update && apt-get install -y \
    libyaml-cpp-dev \
    openssh-client \
    gdb \
    ros-melodic-diagnostics \
    git \
    sudo \
    ninja-build
RUN apt upgrade -y
RUN rm -rf /var/lib/apt/lists/*

## Setup user
RUN useradd --uid ${CAPRA_UID} --create-home ${CAPRA_USER} -G sudo
RUN echo 'capra:test' | chpasswd

## Add support for vscode extension volume caching
RUN mkdir -p ${CAPRA_HOME}/.vscode-server/extensions && chown -R ${CAPRA_USER}: ${CAPRA_HOME}/.vscode-server

WORKDIR ${BASE_LIB_WS}

COPY . ${BASE_LIB_PATH}
RUN bash -c "source ${ROS_WS_SETUP} && catkin_make --use-ninja"

RUN chown -R ${CAPRA_USER}: ${BASE_LIB_WS}