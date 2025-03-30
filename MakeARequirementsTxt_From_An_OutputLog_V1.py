import re
import tkinter as tk
from tkinter import filedialog
import os

def select_file():
    """Opens a file dialog to select a file and returns the file path."""
    root = tk.Tk()
    root.withdraw()  # Hide the main window
    file_path = filedialog.askopenfilename(title="Select Python Package List File", filetypes=[("Text Files", "*.txt"), ("All Files", "*.*")])
    return file_path

def extract_requirements(file_path):
    """Extracts package names and versions from the given file."""
    if not file_path:
        return []

    with open(file_path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    # Find where the package list starts
    start_index = None
    for i, line in enumerate(lines):
        if re.match(r"^-+\s+-+", line):  # Match the line with dashes
            start_index = i + 1
            break

    if start_index is None:
        print("Error: Could not find package list format in the file.")
        return []

    # Extract package names and versions
    packages = []
    for line in lines[start_index:]:
        parts = line.split()
        if len(parts) >= 2:
            package_name = parts[0]
            version = parts[-1]  # Assume the last part is the version
            packages.append(f"{package_name}=={version}")

    return packages

def save_requirements(packages, original_filename):
    """Saves the extracted packages as a requirements.txt file."""
    if not packages:
        print("No packages to save!")
        return

    # Generate output filename based on the original file
    base_name = os.path.splitext(os.path.basename(original_filename))[0]
    output_file = f"{base_name}_requirements.txt"

    with open(output_file, "w", encoding="utf-8") as f:
        f.write("\n".join(packages))

    print(f"Requirements file saved as: {output_file}")

# Select the file
file_path = select_file()

# Extract and save the requirements
if file_path:
    requirements = extract_requirements(file_path)
    save_requirements(requirements, file_path)
else:
    print("No file selected!")
