# Windows Subsystem for Linux 
Windows Subsystem for Linux is a compatibility layer for running Linux binary executables natively on Windows 10 and Windows Server 2019.

## WSL Setup 
- Go to Setting -> select Update & Security -> click For Developers -> change to Developer mode.
- Open Control Panel -> select programs -> windows features turn on or off -> enable Windows Subsystem for Linux.
- Open microsoft store -> search for Ubuntu -> download that, need to sign in with microsoft acc for downloading.
- Search Bash for on the search menu -> open Bash.
- Required to give new bash username & password.
- Select a path where you going to work with projects.
- To update packages -> **sudo apt update** .
- Need to provide the password.
- To upgrade everything -> **sudo apt upgrade** .

## Linux TaskManager
- To install linux taskmanager (**htop**) .
- Command -> **sudo apt install htop** .
- Command -> **htop** to launch the Task Manager.
- We can check all the process on system with htop in Linux UI.
- Can enter into ubuntu CommandLine by entering **Bash** in windows command prompt.

## Ubuntu Connection
- Command -> **lsb_release -a** to check bash & ubuntu version.
- we can intergrate bash with hyper for great UI.
- we can use bash with visual studio as well.
- Linus Subsystem will share files with Window Subsystem.

## Warning
- Never create or modify Linux files from windows apps , tools, scrips & consoles.
- It may lead to Data Corruption.
