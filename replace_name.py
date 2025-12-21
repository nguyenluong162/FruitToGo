import os
import re

# Set the directory containing your icons
icon_dir = "assets/icons"

# Regex pattern to match "icons8-<name>-32.png"
pattern = re.compile(r"icons8-(.+?)-32\.png")

# Loop through files in the directory
for filename in os.listdir(icon_dir):
    print(f"- {icon_dir}/{filename}")
