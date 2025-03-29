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


2nd tool in Python will take two Output files and compare them to show differences in the dependencies (requires tkinter to be pip installed for a file requestor)



3rd tool in Python will open an Output file and turn the dependencies within into a Requirements.txt file

4th tool in Python will scan all the installed nodes and produce a list of their Requirements that have required versions and note conflicts - WIP 


