import os
import re
from datetime import datetime

# Get the current working directory
start_directory = os.getcwd()

# Define paths
base_dir = os.path.join(start_directory, "ComfyUI", "custom_nodes")
date_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
output_file = f"Details_of_Node_Requirement_Versions_{date_time}.txt"

# Regular expression to match versioned dependencies
version_pattern = re.compile(r"[=><]+\s*\d")

# Storage for results
findings = [f"{start_directory}\n"]

# Check if the base directory exists
if os.path.exists(base_dir) and os.path.isdir(base_dir):
    for node_folder in os.listdir(base_dir):
        node_path = os.path.join(base_dir, node_folder)
        requirements_path = os.path.join(node_path, "requirements.txt")
        
        # Check if it's a directory and contains requirements.txt
        if os.path.isdir(node_path) and os.path.isfile(requirements_path):
            with open(requirements_path, "r", encoding="utf-8") as file:
                lines = file.readlines()
                versioned_lines = [line.strip() for line in lines if version_pattern.search(line)]
                
                if versioned_lines:
                    findings.append(f"{node_folder}:")
                    findings.extend(versioned_lines)
                    findings.append("\n")

# Write to output file
if findings:
    with open(output_file, "w", encoding="utf-8") as out_file:
        out_file.write("\n".join(findings))
    print(f"Results saved to {output_file}")
else:
    print("No versioned requirements found.")
