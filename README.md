# ComfyTools
Tools to get information on Comfy Installs and compare it to other installs

**1st Batch script tool gets the below info from a Comfy install (Portable, Desktop or Cloned) and exports it to a timed and dated Output file**

Directory name the script was run from - to ensure clarity of where it came from
GPU and Vram

CPU

RAM

OS Info

Pip Cache Size

System Cuda Version

Cuda Variables set to Variable Names

Cuda Path Variables

MSVC Env Variables incl cl.exe

System Python Version

Python Install Paths

Installed Nodes

Venv or Embeded Python Version

Venv or Embeded Pytorch and Cuda Version

Venv dependencies with Version numbers installed


2nd tool in Python will take two Output files from the above and compare them to show differences in their two dependencies (requires tkinter to be pip installed for a file requestor)
Usages:
Taking a snapshot before and after an update
Fault finding
Comparing two installs

Usage:
Start it and select two output files in the format of output_log_2025-03_12-007.txt (the outputs from the 

Output:
It will output a comparison table (see pic below), showing how the version numbers are diffent . It outputs is in this naming system: Comparison_Between_Output_Logs_Dependencies_results_2025-03-30_10-40-20.txt

![image](https://github.com/user-attachments/assets/9a46fa26-3ed8-4133-a352-6c6893279702)


3rd tool in Python will open an Output file and turn the dependencies within into a Requirements.txt file

4th tool in Python will scan all the installed nodes and produce a list of their Requirements that have required versions (ie discard those that have no version requirement). This requires tkinter to be pip installed for a file requestor
Usage case:
Taking a snapshot before and after an update
Fault finding 

Usage:
Start it and it will open a file requestor - select the Custom_Nodes folder of the install you wish to process

Output:
It will output a text file with this timed and dated naming system "Details_of_Node_Requirement_Versions_2025-03-30_10-21-14.txt"

![image](https://github.com/user-attachments/assets/3d2bc3de-babe-4e09-aa24-a9481c5e41e0)

