#!/usr/bin/python

import os
import socket
import pwd
import shutil
import sys

def GenerateLandscapeString():

	# This function creates the string of arguments
	# wich we feed to the Landscape-client program
	# containing info such as landscape account, etc-
	# Landscape variables
	landscapename="aarhus-public-libraries"
	landscapetags="bibos-alfa"
	landscapepassword="Fleten2011"
	landscapetitle=(socket.gethostname())

	# Generated string, for landscape-config command.
	return("landscape-config -a "+landscapename+" --tag "+landscapetags+" -p "+landscapepassword+" -t "+landscapetitle)



def Launchers(landscapestring):
	#this function launches the programs we want the user
	#to interact with. This includes printer configuration, 
	# and the landscape setup
        scriptcmd="/usr/local/bin/doLandscape.pl " + "'" + landscapestring + "'"
	os.system("system-config-printer")
	os.system("xterm -fn 10x20 -e "+scriptcmd)


def Cleanup():
	# This is cleanup. It deletes the script and its autostart file
	# so it wont run again on the next startup
	os.system("rm /etc/xdg/autostart/bibos-postinstall.desktop")
	os.system("rm /usr/local/bin/bibos-postinstall.py")

def MakeAutoLogin(username):
	# This function inserts the username as the auto-login user. 
	# this means no more clicking and password typing.
	StringToAppend=("autologin-user="+username)
	os.system("sudo sed \"$ a "+StringToAppend+"\" /etc/lightdm/lightdm.conf > /tmp/lightdm.conf.new")
	shutil.move("/etc/lightdm/lightdm.conf", "/etc/lightdm/light.conf.backup")
	shutil.move("/tmp/lightdm.conf.new", "/etc/lightdm/lightdm.conf") 

	#os.system("echo \""+StringToAppend+" >> /etc/lightdm/lightdm.conf\"")


def NewAdminUser(username):
	os.system("sudo useradd -m -s /bin/bash -p '$1$aW5mLZtn$GoCjPYwTSp3PIEtdEdtD71' superuser")
	os.system("sudo adduser superuser sudo")
	os.system("sudo deluser user sudo")


def EnableUserhomeCleanup(username):
	# This here function readies the automatic cleanup script. 
	# wich makes sure nothing is left behind when the computer starts up
	# (see the script for more explanation)
	# Firstly we prepare the .skjult folder, wich will be backuped from
	PathToScript="/opt/bibos/bin/user-cleanup.bash"
	
	# Make a temporary copy, edit that, and move into place
	shutil.copyfile(PathToScript,"/tmp/user-cleanup.bash")
	os.system("sed -i \'s/EDITME/"+username+"/g\' /tmp/user-cleanup.bash")
	shutil.copyfile("/tmp/user-cleanup.bash",PathToScript)
	# make executable, just in case
	os.system("chmod +x "+PathToScript)
	
def PerformSetupDetails():
        # Setup startpage for mozilla firefox
	URL="http://www.aakb.dk/"
	os.system("sed -i 's#.*user_pref(\"browser.startup.homepage\",.*#user_pref(\"browser.startup.homepage\", \"" + URL + "\");#g' /home/.skjult/.mozilla/firefox/e1362422.default/prefs.js");

        # Create logout desktop shortcut
        ShortCut="/usr/local/bin/Logout.desktop"
        os.system("cp " + ShortCut +  " /home/.skjult/Desktop/");

def nodot(item): 
	# filter, til brugernavnsfinding. Sikrer at den skjulte mappe ikke 
	# bliver parset med
	return item[0] != '.'		

def CrashAndBurn():
	# This function cleans up if something goes wrong. 
	# To ensure that the system is still functional
	# WORK IN PROGRESS
	pass


###################################################
##   Program starting!y
###################################################
#username=sys.argv[1]

username=filter(nodot, os.listdir('/home'))[0]

PerformSetupDetails()

MakeAutoLogin(username)

EnableUserhomeCleanup(username)

NewAdminUser(username)

Launchers(GenerateLandscapeString())

Cleanup()













