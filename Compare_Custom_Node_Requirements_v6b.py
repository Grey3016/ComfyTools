import os
import re
import sys
import tkinter as tk
from tkinter import filedialog
from datetime import datetime

def get_requirements(base_dir):
    """Extracts package versions from each node's requirements.txt."""
    version_pattern = re.compile(r"([a-zA-Z0-9_-]+)[=><!]+([\d.]+)")
    node_requirements = {}
    
    if os.path.exists(base_dir) and os.path.isdir(base_dir):
        for node_folder in os.listdir(base_dir):
            node_path = os.path.join(base_dir, node_folder)
            requirements_path = os.path.join(node_path, "requirements.txt")
            
            if os.path.isdir(node_path) and os.path.isfile(requirements_path):
                with open(requirements_path, "r", encoding="utf-8") as file:
                    lines = file.readlines()
                    packages = {}
                    for line in lines:
                        match = version_pattern.search(line)
                        if match:
                            packages[match.group(1)] = match.group(2)
                    if packages:
                        node_requirements[node_folder] = packages
    return node_requirements

def compare_node_requirements(requirements, installed_versions):
    """Compare Requirements across nodes and find inconsistencies."""
    package_versions = {}
    inconsistencies = []
    
    for node, packages in requirements.items():
        for package, version in packages.items():
            if package not in package_versions:
                package_versions[package] = {}
            package_versions[package][node] = version
    
    for package, versions in package_versions.items():
        if len(set(versions.values())) > 1:
            inconsistencies.append(f"{package} has version mismatches:")
            for node, version in versions.items():
                inconsistencies.append(f"  - {node}: {version}")
            installed_version = installed_versions.get(package, "Not Installed")
            inconsistencies.append(f"  - Installed Version: {installed_version}\n")
    
    return inconsistencies

def select_directory():
    """Opens a file dialog to select a directory."""
    root = tk.Tk()
    root.withdraw()
    directory = filedialog.askdirectory(title="Select ComfyUI custom_nodes Directory")
    return directory

def detect_installed_packages():
    """Detects installed packages based on the environment type."""
    possible_paths = [
        os.path.join(os.getcwd(), "ComfyUI", "venv", "Lib", "site-packages"),  # Cloned Comfy
        os.path.join(os.getcwd(), "Embeded_Python", "Lib", "site-packages"),    # Portable Comfy
        os.path.join(os.getcwd(), ".venv", "Lib", "site-packages")             # Desktop Comfy
    ]
    
    for path in possible_paths:
        if os.path.exists(path):
            installed_versions = {}
            for package in os.listdir(path):
                match = re.match(r"([a-zA-Z0-9_-]+)-(\d+\.\d+\.\d+).*", package)
                if match:
                    installed_versions[match.group(1)] = match.group(2)
            return installed_versions
    
    return {}

def main():
    base_dir = select_directory()
    if not base_dir:
        print("No directory selected. Exiting.")
        return
    
    installed_versions = detect_installed_packages()
    requirements = get_requirements(base_dir)
    inconsistencies = compare_node_requirements(requirements, installed_versions)
    
    date_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    output_file = f"Comparison_of_Custom_Node_Requirements_{date_time}.txt"
    
    with open(output_file, "w", encoding="utf-8") as out_file:
        out_file.write("Custom Node Requirements Versions Report\n")
        out_file.write("============================================================\n")
        out_file.write(f"Custom Nodes Directory: {base_dir}\n")
        out_file.write(f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        out_file.write("------------------------------------------------------------\n")
        if inconsistencies:
            out_file.write("\n".join(inconsistencies) + "\n")
        else:
            out_file.write("No version inconsistencies found.\n")
    
    print(f"Custom Node Requirement Versions report saved to {output_file}")

if __name__ == "__main__":
    main()