# ROS noetic Full Desktop on Ubuntu 20.04 Vagrant Base box

## Using the base box

Initialize a Vagrant environment using this base box :

```bash
vagrant box add bergiasolutions/ros-noetic-desktop-focal_x64
vagrant up
```
## Contributing

The base box may be imported and used directly in a Vagrantfile for any of your projects. But if you want to build your own base box starting from this one, here are some tips.

### Building the image

Use the ```build_box.sh``` script to build and package the image. 
This will invoke ```vagrant up``` using a fresh ```ubuntu/focal64``` base box, install ROS, performs some preparations steps, and finally package the resulting VirtualBox VM in the ```./build/YYYYMMDD.hh.mm/``` folder. It will also generate a description file.

### Publishing the image

Invoke ```publish.sh``` with the build folder as the first argument :

```bash
./publish ./build/YYYYMMDD.hh.mm/
```

This will publish the baseb box version to the cloud along with the description, version description, short description and the SHA256 checksum.

Once you published it, don't forget to commit and tag the current state for traceability. The tag should be YYYYMMDD.hh.mm (same as box version publish to vagrant cloud).

### Contact

Please report bugs, use cases, suggestions for improvements to Bertrand Caré <contact@bergia-solutions.com>

BERGIA Solutions <https://bergia-solutions.com> is a R&D Software engineering consutling company. Let us know how we might help you achieve your robotics projects !

