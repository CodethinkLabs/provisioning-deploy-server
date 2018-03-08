Documentation
=============
This repository provides a bash script (provision-VM.sh) which calls two
playbooks to configure an Ubuntu 16.04 Server VM with
[lighttpd webserver](https://www.lighttpd.net/).
The configured VM is meant to be used as a deployment server for
[Codethink's GCC](https://github.com/CodethinkLabs/gcc).

The script will create a 'deployment' user with '$HOME/server' directory
which contents will be displayed by the webserver.

You could find Ubuntu 16.04 ISO images in:
  - https://www.ubuntu.com/download/server

provision-VM.sh
===================
For more information about this script run it with -h argument,
e.g. `./provision-VM.sh -h`
