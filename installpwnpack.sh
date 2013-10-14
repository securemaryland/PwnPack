#!/bin/bash
# Simple beginnings of an install script for the tools w/in pwnpack - may not be the best way of doing things but better than what it was.
# www.securemaryland.org
# @securemaryland
#Tested on Pwnpad Community Edition
# 
VERSION="1.0"
###################################################################################################################
# Intro
#
f_intro(){
#Setting some variables used later
configdir=/opt/pwnpad/pwnpack
configfile=/opt/pwnpad/pwnpack/pwnpack.cfg
sddir=/sdcard/Download/pwnpack/
ppscriptsdir=/opt/pwnpad/scripts/
clear
echo ""
echo -e "\e[1;31m-------------------------------------------------------------------\e[00m"
echo "Welcome to Pwnpack $VERSION tools and scripts for Pwnpad Community edition."
echo ""
echo "This is the very beginnings of an install script so I am sorry to say you will have to do some by hand as well."
echo "Press Enter to continue:"
read ENTERKEY
echo -e "\e[1;31m-------------------------------------------------------------------\e[00m"
}
############
###################################################################################################################
# Unzip files and move them to the appropriate directories
#
f_main (){
# Building Directory Structure
unzip pwnpack.zip
mv pwnpack $configdir
cd $configdir
echo ""
echo -e "\e[1;31m-------------------------------------------------------------------\e[00m"
echo "The directory $configdir was created and all pwnpack information moved there."
echo ""
echo "Moving the APKs (android apps) to /sdcard/Download/pwnpack"
mkdir -p $sddir
cp `find . -name "*.apk"` $sddir
echo ""
echo "APKs moved. Please use Astro or your favorite file manager to install them on the Android side of the house."
echo "Press Enter to continue:"
read ENTERKEY

echo ""
echo "Moving the scripts to $ppscriptsdir - this is necessary for the APKs to work correctly. "
chmod +x `find . -name "*.sh"`
cp `find . -name "*.sh"` $ppscriptsdir
echo ""
echo "Shell scripts moved."
echo "Press Enter to continue:"
read ENTERKEY
}
############
####################################################################################################################
# Tool Configuration and Installation
#
f_config (){
echo -e "\e[1;31m-------------------------------------------------------------------\e[00m"
echo ""
echo "Running initial configuration - this may take some time as I have to search for tools"
echo "Note the configuration script $configdir/pwnpackcfg.sh can be run at any time. We recommend you re-run it once you install new tools."
if [ ! -f "$configfile" ]; then
  # Control will enter here and create $configdir if it doesn't exist.
  echo "Didn't see the configuration file $configfile so I created it"
  mkdir -p "$configdir"
  echo "appname:/path/to/app">> $configfile
fi
cd $configdir
echo -e "\e[1;31m-------------------------------------------------------------------\e[00m"
echo "Looking for the files and installing them if not found. This will take sometime as I have to search for them and get them if not here."
echo ""
echo "Please be patient..."
echo -e "\e[1;31m-------------------------------------------------------------------\e[00m"
#There has to be a better way to do this but this was easy for me so it will do for now.
pwnpackscripts=("findmyhash.py" "cewl.rb" "Wsorrow.pl" "AP_fucker.py" "wpscan.rb" "theHarvester.py" "recon-ng.py")
for i in "${pwnpackscripts[@]}"
do
  cat $configfile | grep "$i" >/dev/null 2>&1
  if [ $? = 0 ]
	then
	echo "I see $i is already in the config file nothing more to do here"
else
echo "Can't find $i in the config file need ti search for it."
installdir=`find / -name $i -print |awk -F'/[^/]*$' '{print $1}'`
if [ -n "$installdir" ]
	then
		echo "Had to search but found it here: $installdir"
		echo "Adding it to the configuration file to speed up next run."
		echo "$i:$installdir">>$configfile
	else
	echo "Please be sure to install $i"
fi
fi
done
echo -e "\e[1;33m-----------------------------------------------------------------------\e[00m"
echo ""
echo "The install script is still a work in progress and as such many of the tools must still be installed by you."
echo "To make it as easy as possible, I included the files to install and/or directions on how to install in the $configdir/InstallFiles directory."
echo "The following files can be found in the install directory:"
lsFiles=$(ls "$configdir/installfiles")
echo -e "\e[00;32m$lsFiles\e[00m"
echo -e "\e[1;33m-----------------------------------------------------------------------\e[00m"
echo ""
}
#################
f_intro
f_main
f_config
echo "Please leave comments on my webpage on what works/broken or what tools you would like to see included and I will do my best to get to it."
echo "Press enter to exit."
read ENTERKEY
exit 