# ComfyTools: 

Tool name: **System Desktop Venv Embeded Installs v4aw.bat**

Tools to get information on Comfy Installs and compare it to other installs. The first is a batch script, the others are Python made with ChatGPT - you can use the python files I made or make your own (the prompts I used for each are at the end of this ReadMe). To get the Python tools working, you will need to install tkinter into your system Python "pip instal tkinter" - this gives file requestors to Python. 

**1st Batch script tool gets the below info from a Comfy install (Portable, Desktop or Cloned) and exports it to a timed and dated Output file**

**Usage case:**

1. Keeps a system wide snapshot of a Comfy install and your system
2. Its output files can be compared before and after system or install changes to see what has changed or help with fault finding

**Usage:**
1. Desktop: place script inside the ComfyUI folder in the Documents folder with the system folders and the .venv folder
2. Portable and Cloned: place script outside the main ComfyUI folder ie along with the Embeded folder and startup scripts 


**Output: Details of Output_Log txt file:**

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




-------------------------------------------------

2nd tool in Python will take two Output files from the above, select their dependencies in their output files and compare them to show differences in their two dependencies (requires tkinter to be pip installed for a file requestor). To get the Python tools working, you will need to install tkinter into your system Python "pip instal tkinter" - this gives file requestors to Python.
**Usage case:**

Tool name: **Compare_OutputLogs_Dependencies_v2h.py**

1. Fault finding
2. Comparing two installs - any, compare Desktop to Portable or Clone
3. Taking a snapshot before and after an update

**Usage:**
Start it and select two output files in the format of output_log_2025-03_12-007.txt (the outputs from the 

**Output:**
It will output a comparison table (see pic below), showing how the version numbers are diffent . It outputs is in this naming system: Comparison_Between_Output_Logs_Dependencies_results_2025-03-30_10-40-20.txt

![image](https://github.com/user-attachments/assets/9a46fa26-3ed8-4133-a352-6c6893279702)

-------------------------------------------------

3rd tool in Python will open an Output_log file and turn the dependencies noted in it into a requirements.txt file. To get the Python tools working, you will need to install tkinter into your system Python "pip instal tkinter" - this gives file requestors to Python.

Tool name: **MakeARequirementsTxt_From_An_OutputLog_V1.py**

**Usage case:**

Taking a snapshot output file and turning it into a requirements file to roll back dependencies - bear in mind this might not work / use in conjunction with the tool noting Nodes version requirements

**Usage / Input:**

It will open a file requestor to select an output_log file 

**Output:**

It will output a named (from the output_log file you used) requirements txt file. Naming system example output_log_2025-03_12-007_requirements.txt

![image](https://github.com/user-attachments/assets/983158fa-495e-459f-98b5-d18ef339e21a)

-------------------------------------------------

4th tool in Python will scan all the installed nodes in a custom_nodes folder and produce a list of their Requirements that have required versions (ie discard those that have no version requirement) and also detail what the installed version is. This requires tkinter to be pip installed for a file requestor - "pip instal tkinter" - this gives file requestors to Python.

Tool name: **Compare_Custom_Node_Requirements_v6b.py**

**Usage case:**

1. Taking a snapshot before and after an update
2. Fault finding


**Usage / Input:**

Start it and it will open a file requestor - select the Custom_Nodes folder of the install you wish to process

**Output:**

It will output a text file with this timed and dated naming system "Details_of_Node_Requirement_Versions_2025-03-30_10-21-14.txt"

![image](https://github.com/user-attachments/assets/321cf312-79ab-45f8-be6c-3ef39d0e1796)


--------------------------------------------------

**Making the Python Tools in ChatGPT**

Just copy each prompt (without the number) and paste into ChatGPT one at a time. 

**To make "Compare_OutputLogs_Dependencies_v2h.py"**

1. I have two files and halfway through each there is a list of python requirements inside a venv , how can I compare (versions) these lists from each file. This is the format "Embedded Install Details 
Package                   Version
------------------------- ------------
absl-py                   2.1.0
aiofiles                  23.2.1
aiohappyeyeballs          2.4.4
aiohttp                   3.11.11
aiosignal                 1.3.2
annotated-types           0.7.0 " 


2.in the above script, use tkinter to select the files with a file requestor

3. make the list returned alphabetical and export it to a textfile

4. amend the code to include a key to file 1 and file 2 names by using a key at the top of their real filenames

5. add the date and time to the saved filename

6. amend the key at the top of the page to also include the second line from the top of each textfile in the key


----------------------------------

**To make "MakeARequirementsTxt_From_An_OutputLog_V1.py"**

This worked first time (ie why it's v1)

After I made the above code, I referred it to with the next request to make a requirements.txt from a output_log text file (ie from the above input text - a reference to the section of the table I pasted in with the first tool)

1. from the above input text with the install details, make a python script to load one of the files with tkinter and turn it into a requirements.txt file for ComfyUI 

---

To make Detail_of_Node_Requirement_Versions_v2c.py (checked)       

1.a python file to go into the ComfyUI\custom_nodes folder and then go into each nodes folder, then looks for a requirements.txt file and record the findings (but only if the file has a version number) and output that file to an output text file 

2. and record the filepath it was started in to the topline of the output.txt - change the filename to incorporate date and time


------------------------------------

**To make "Compare_Custom_Node_Requirements_v6b.py"**

Again - I'd just finished making the above python code for "Detail_of_Node_Requirement_Versions", so I could refer to it to make the next tool I wanted. I couldn't get the arrows to work despite a lot of requests to ChatGPT

1.python file to compare two of these outputted files from above and compare them. Load the files with a files requestor from tkinter

2.change of plan - get the python to compare requirements between each node and note version incompatibilities

3.change the code to use a file requestor to load the file

4.add a blank line between each file comparison , add the installed version to the bottom of each comparison - if the python script was started in a cloned comfy the files will be in ComfyUI\venv\Lib\site-packages, if the python script was started in a Portable Comfy then the files will be in Embeded_Python\Lib\site-packages and if started in Desktop Comfy the files will be in .venv\Lib\site-packages - make checks which version is being used and allow this check

5.Change the heading from Python Package to Custom Node Inconsistencies and add a top line to the output file that gives the filepath of the custom_nodes folder used. At the end of each node requirement with a version number put an arrow to indicate if it is higher, lower or equal to the installed version below






