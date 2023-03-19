#!/usr/bin/env python3

##
# Ensures that repository hooks are installed.
#
# Simply run this from the command line:
#
# ```
# .github/install-hooks.py
# ```
#

import os
import sys

if os.geteuid() == 0:
    print("Please do not run this script as root.")
    sys.exit(1)

if not os.path.isdir(".git"):
    print("Unable to locate .git directory; are you in the project root?")
    sys.exit(1)

print("\nInstalling hooks:\n")

hooks = os.listdir(".github/hooks")

for hook in hooks:
    src_file = f".github/hooks/{hook}"
    hook_file = f".git/hooks/{hook}"

    print(f"    {hook}", end="...")

    # The lines to build up
    lines = list()

    # If the file does not exist, we need to create it with a header
    if not os.path.isfile(hook_file):
        print("CREATED")

        lines.append("#!/usr/bin/env bash")

    # If the file exists, we need to replace (or add) the lines
    else:
        print("UPDATED")

        # Store any lines except between our flags
        skipping = False

        with open(hook_file, "r") as f:
            for line in f:
                if line.rstrip("\n") == "# <RAB HOOK START>":
                    skipping = True
                    continue

                if line.rstrip("\n") == "# <RAB HOOK END>":
                    skipping = False
                    continue

                if skipping:
                    continue

                lines.append(line.rstrip("\n"))

    # When done initial processing, write the final file
    with open(src_file, "r") as f:
        lines.append("")
        lines.append("# <RAB HOOK START>")

        for line in f:
            lines.append(line.rstrip("\n"))

        lines.append("# <RAB HOOK END>")

    # Strip any excess vertical spacing that came from formatting
    clean_lines = []
    was_space = False

    for line in lines:
        if line.strip("\n").strip(" ") == "":
            if was_space:
                continue

            was_space = True
            clean_lines.append("")

        else:
            was_space = False
            clean_lines.append(line)

    # Write the updated lines to the file
    with open(hook_file, "w") as f:
        for line in clean_lines:
            f.write(f"{line}\n")

# All done
print("\nDone!")
