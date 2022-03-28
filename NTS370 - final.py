#!/usr/bin/env python

import nmap
import socket
import sys
from os import system, name

# Function to check acccounts in the passwd file.
def check_passwd():
    # Open passwd file to parsing
    with open('/etc/passwd', 'r') as passwd_file:
        data = passwd_file.readlines()

        passwd_file.close()

    # Break up the lines to make it easier to parse and print.
    parse_data = []
    for line in data:
        parse_data.append(line.split(':'))


    # print(f"User Account: {account[0]}", f"User Information: {account[4].strip(',,,')}",
    # "Home Location:", colored(f"{account[5]}"), f"Shell Location: {account[6]}")
    """Loop through each line in passwd and print using the following list indexes
    to pull from passwd file 0, 4, 5, 6
    """
    for account in parse_data:
        print(f"""User Account: \033[0;31m{account[0]}\033[0;0m,\
     User Information: \033[1;31m{account[4].strip(',,,')}\033[0;0m,\
     Home Location: \033[0;32m{account[5]}\033[0;0m, Shell Location: \033[0;31m{account[6]}\033[0;0m""")

    back_to_menu()

def check_log():
    with open('Linux_2k.log', 'r') as log:
        log_data = log.readlines()

    log.close()

    for line in log_data:
        if "authentication failure" in line:
            print(line)
    back_to_menu()


# Runs an nmap scan on scanme.nmap.org port 80 by default, but any address and port can be provided
def check_web_version(host='scanme.nmap.org', port = 80):
    nm = nmap.PortScanner()
    ip_address = socket.gethostbyname(host)
    result = nm.scan(host, str(port))
    print(f"This web server is running \033[0;31m{result['scan'][ip_address]['tcp'][port]['product']}\033[0m\
 as a web server with a version of \033[0;31m{result['scan'][ip_address]['tcp'][port]['version']}\033[0m")

    back_to_menu()

def clear():
    if name == 'nt':
        _ = system('cls')
    else:
        _ = system('clear')

def back_to_menu():
    while True:
        if input("Do you want to return to the main menu? y/n: ") == 'y':
            clear()
            break
        else:
            clear()
            sys.exit(0)

def main():
    print("""
        Welcome to the System Check script. Here you will be able to check the passwd file for accounts, and their home location and what shell they are using. 
            You can also check a log file for failed logins; lastly it will check for the version number on a webserver.
*****************************************************************************************************************************************************************
""")
# Main menu loop
    while True:
        print("""
        1) Check the passwd file for accounts on the system.
        2) Examin the log file for failed logins.
        3) Check for a web server version number.
        0) Exit
        """ + '\n')
        
        # Gets user response for menu selection
        response = int(input('Option: '))
        
        # If else statements for menu selection
        if response == 0:
            print("The script will now exit.")
            clear()
            break
        elif response == 1:
            clear()
            check_passwd()
        elif response == 2:
            clear()
            check_log()
        elif response == 3:
            clear()
            if input("Would you like to provide a site to check the web server version (Default is scanme.nmap.org) y/n: ") == 'y':
                url = input("What site would you like to check: ")
                print(f"Now checking {url} on port 80")
                check_web_version(url)
            else:
                print("Now checking scanme.nmap.org on port 80")
                check_web_version()


if __name__ == "__main__":
    main()
