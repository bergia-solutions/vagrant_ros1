# stop in case of error
set -o errexit



################################################################################
#                             C++ TOOLS                                        #
################################################################################

apt-get update && apt-get install -y --no-install-recommends \
			  build-essential \
			  cmake \
			  gcc

################################################################################
#                          ROS INSTALLATION                                    #
################################################################################

apt-get update && apt-get install -q -y --no-install-recommends \
			  dirmngr \
			  gnupg2


# install ROS repos key

echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

apt-get update && apt-get install -y --no-install-recommends \
			  ros-melodic-desktop-full \
			  ros-melodic-rosbash \
			  ros-melodic-roslaunch \
			  ros-melodic-rostopic

apt-get update && apt-get install -y --no-install-recommends \
			  python-rosdep \
			  python-rosinstall \
			  python-rosinstall-generator \
			  python-wstool

# post-install steps :
if [ ! -f "/etc/ros/rosdep/sources.list.d/20-default.list" ]
then
    rosdep init
fi
rosdep update

# catkin tools :
apt-get update && apt-get install -y --no-install-recommends \
			  python3-vcstool \
			  python3-catkin-tools




################################################################################
#                             FINAL STEPS                                      #
################################################################################

# prevent "These packages are no longer required ..." :
apt-mark showauto | xargs apt-get install -y


