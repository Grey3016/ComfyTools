import re
import tkinter as tk
from tkinter import filedialog
import os
from datetime import datetime

def select_file(title):
    """Opens a file dialog to select a file and returns the file path."""
    root = tk.Tk()
    root.withdraw()  # Hide the main window
    file_path = filedialog.askopenfilename(title=title, filetypes=[("Text Files", "*.txt"), ("All Files", "*.*")])
    return file_path

def extract_requirements(file_path):
    """Extracts package names and versions from a pip list output inside a file."""
    if not file_path:
        return {}, ""

    with open(file_path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    # Get the second line for additional context
    second_line = lines[1].strip() if len(lines) > 1 else "N/A"

    # Find where the package list starts
    start_index = None
    for i, line in enumerate(lines):
        if re.match(r"^-+\s+-+", line):  # Match the line with dashes
            start_index = i + 1
            break

    if start_index is None:
        print(f"Error: Could not find package list in {file_path}")
        return {}, second_line

    # Extract packages and versions
    packages = {}
    for line in lines[start_index:]:
        parts = line.split()
        if len(parts) >= 2:
            package_name = parts[0]
            version = parts[-1]  # Assume last item is the version
            packages[package_name] = version

    return packages, second_line

def compare_requirements(file1, file2):
    """Compares package versions from two extracted requirement lists and saves to a timestamped file."""
    reqs1, meta1 = extract_requirements(file1)
    reqs2, meta2 = extract_requirements(file2)

    # Extract filenames (without full path) for reference
    file1_name = os.path.basename(file1)
    file2_name = os.path.basename(file2)

    # Get the current timestamp for the filename
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    output_file = f"Comparison_Between_Output_Logs_Dependencies_results_{timestamp}.txt"

    all_packages = sorted(set(reqs1.keys()).union(set(reqs2.keys())))  # Sort alphabetically

    # Define column widths
    col_widths = {"package": 30, "file1": 18, "file2": 18, "status": 20}
    divider = "-" * (sum(col_widths.values()) + 9)  # Adjust divider length

    result_lines = []
    result_lines.append("Python Package Comparison Report\n")
    result_lines.append("=" * len(divider) + "\n")
    result_lines.append(f"File 1: {file1_name}\n")
    result_lines.append(f"  ➝ {meta1}\n")  # Second line from File 1
    result_lines.append(f"File 2: {file2_name}\n")
    result_lines.append(f"  ➝ {meta2}\n")  # Second line from File 2
    result_lines.append(f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    result_lines.append(divider + "\n")

    # Table Headers
    result_lines.append(
        f"{'Package':<{col_widths['package']}} | {'File1 Version':<{col_widths['file1']}} | {'File2 Version':<{col_widths['file2']}} | {'Status':<{col_widths['status']}}\n"
    )
    result_lines.append(divider + "\n")

    for package in all_packages:
        v1 = reqs1.get(package, "Not Installed")
        v2 = reqs2.get(package, "Not Installed")

        if v1 == v2:
            status = "✅ Same"
        elif v1 == "Not Installed":
            status = "⬆ Added in File2"
        elif v2 == "Not Installed":
            status = "⬆ Added in File1"
        else:
            status = "🔄 Version Mismatch"

        result_lines.append(
            f"{package:<{col_widths['package']}} | {v1:<{col_widths['file1']}} | {v2:<{col_widths['file2']}} | {status:<{col_widths['status']}}\n"
        )

    # Save results to a timestamped text file
    with open(output_file, "w", encoding="utf-8") as f:
        f.writelines(result_lines)

    print(f"Comparison saved to {output_file}")

# Open file dialogs to select the two files
file1 = select_file("Select First Requirements File")
file2 = select_file("Select Second Requirements File")

# Ensure both files are selected before proceeding
if file1 and file2:
    compare_requirements(file1, file2)
else:
    print("Error: Both files must be selected!")
