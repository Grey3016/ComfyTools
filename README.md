# ComfyTools
Tools to get information on Comfy Installs and compare it to other installs

**1st Batch script tool gets the below info from a Comfy install (Portable, Desktop or Cloned) and exports it to a timed and dated Output file**

Directory name the script was run from - to ensure clarity of where it came from
GPU and Vram

CPU, RAM, OS Info, Pip Cache Size, System Cuda Version, Cuda Variables set to Variable Names, Cuda Path Variables, MSVC Env Variables incl cl.exe, System Python Version, Python Paths check, Installed Nodes, Venv or Embeded Python Version, Venv or Embeded Pytorch and Cuda Version, Venv dependencies with Version numbers installed

![image](https://github.com/user-attachments/assets/1b685b09-0b69-4265-9e5d-3a3a73013bd7)

Above: Basic system information, along with name of folder the script was run in and type of Comfy install

![image](https://github.com/user-attachments/assets/1d397938-f4c9-4c31-8242-fdfefbdd0c47)

Above: Shows how big your pip cache is (26GB in my case) and Cuda info (Paths and Variable names) - I have three of them installed, I just change over the Path/Variable last number to the Cuda I want on each and it works and has always worked for me. 

![image](https://github.com/user-attachments/assets/2b5f8e7d-b6a8-4fab-85dc-127ea3a0e60d)
Above: Checks on MSVC and CL.exe installation and Paths, checks Python for version and Paths and details what nodes you have 

![image](https://github.com/user-attachments/assets/21990a2d-8155-4cc5-858a-a6c7cab06992)

Above: It then opens the venv in Desktop, Cloned or the Embeded folder in Portable and reports back on the installed Python/Pytorch/Cuda version and finally details all of the installed packages and their versions

Usage:

Desktop: place script inside the ComfyUI folder in the Documents folder with the system folders and the .venv folder

Portable and Desktop: place script outside the main ComfyUI folder ie along with the Embeded folder and startup scripts 


-------------------------------------------------

2nd tool in Python will take two Output files from the above, select their dependencies in their output files and compare them to show differences in their two dependencies (requires tkinter to be pip installed for a file requestor)
Usages:

Taking a snapshot before and after an update

Fault finding

Comparing two installs

Usage:
Start it and select two output files in the format of output_log_2025-03_12-007.txt (the outputs from the 

Output:
It will output a comparison table (see pic below), showing how the version numbers are diffent . It outputs is in this naming system: Comparison_Between_Output_Logs_Dependencies_results_2025-03-30_10-40-20.txt

![image](https://github.com/user-attachments/assets/9a46fa26-3ed8-4133-a352-6c6893279702)

-------------------------------------------------

3rd tool in Python will open an Output_log file and turn the dependencies noted in it into a requirements.txt file

Usage case:

Taking a snapshot output file and turning it into a requirements file to roll back dependencies - bear in mind this might not work / use in conjunction with the tool noting Nodes version requirements

Input:

It will open a file requestor to select an output_log file 

Output:

It will output a named (from the output_log file you used) requirements txt file. Naming system example output_log_2025-03_12-007_requirements.txt

![image](https://github.com/user-attachments/assets/983158fa-495e-459f-98b5-d18ef339e21a)

-------------------------------------------------

4th tool in Python will scan all the installed nodes and produce a list of their Requirements that have required versions (ie discard those that have no version requirement). This requires tkinter to be pip installed for a file requestor

Usage case:

Taking a snapshot before and after an update

Fault finding 

Usage:

Start it and it will open a file requestor - select the Custom_Nodes folder of the install you wish to process

Output:

It will output a text file with this timed and dated naming system "Details_of_Node_Requirement_Versions_2025-03-30_10-21-14.txt"

![image](https://github.com/user-attachments/assets/3d2bc3de-babe-4e09-aa24-a9481c5e41e0)




