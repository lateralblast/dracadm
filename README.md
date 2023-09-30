![Dracula cat](https://raw.githubusercontent.com/lateralblast/dracadm/master/dracadm.png)

dracadm
======

A tool to run racadm on a Mac or non x86 based (e.g. ARM) Linux machine via docker

Version
-------

Current version: 0.0.6

Prerequisites
-------------

Required packages/applications:

- Docker

Introduction
------------

This script provides a way to run racadm from the command line on non x86 hardware and/or non Linux based OS
by using a docker container (e.g. MacOS on Apple Silicon)

Usage
-----

The script passes commandline argument to racadm in the docker container, therefore the same commandline
arguments that are used with racadm can be used with the script.

Exceptions to this are:

- The --version switch returns the version of the local script
- The --help swich is converted to nothing to return help as racadm does not have a help switch

To get help on how to use the racadm command use the --help switch:

```
> ./dracadm.sh --help

===============================================================================
RACADM version 11.0.0.0
Copyright (c) 2003-2022 Dell, Inc.
All Rights Reserved
===============================================================================

RACADM usage syntax:

 racadm <subcommand> <options>

Examples:

 racadm getsysinfo
 racadm getsysinfo -d
 racadm getniccfg
 racadm setniccfg -d
 racadm setniccfg -s 192.168.0.120 255.255.255.0 192.168.0.1
 racadm getconfig -g cfgLanNetworking

Display a list of available subcommands for the RAC:

 racadm help

Display more detailed help for a specific subcommand:

 racadm help <subcommand>

-------------------------------------------------------------------------------

Remote RACADM usage syntax:

 racadm -r <RAC IP address> -u <username> -p <password> <subcommand> <options>
 racadm -r <RAC IP address> -i <subcommand> <options>

 The "-i" option allows the username and password to be entered interactively.

Examples:

 racadm -r 192.168.0.120 -u racuser1 -p aygqt12a getsysinfo
 racadm -r 192.168.0.120 -u racuser2 -p gsdf12o1 getractime
 racadm -r 192.168.0.120 -u racuser5 -p dsajkhds help getsysinfo

Display a list of available subcommands for the remote RAC:

 racadm -r <RAC IP address> -u <username> -p <password> help

Display more detailed help for a specific subcommand:

 racadm -r <RAC IP address> -u <username> -p <password> help <subcommand>

-------------------------------------------------------------------------------
```
