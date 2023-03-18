#!/usr/bin/env bash

# Constants
PROJECT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )
BACKUP_DIR=$(mktemp -d -t rnb_git_hooks)


# Environmental checks
if [ "$EUID" -eq 0 ]; then
  echo "Please do not run this script as root." >&2
  exit 1
fi

if ! [ -d "$PROJECT_DIR/.git/hooks" ]; then
  echo "Unable to locate '.git/hooks' directory; is git initialized? Exiting." >&2
  exit 2
fi


# Create a backup of the existing hooks folder, in case of error
echo "Backing up existing hooks..."
cp -r "$PROJECT_DIR/.git/hooks/" "$BACKUP_DIR/"


# Trap any errors and run our on_error function to revert changes
#
on_error() {
  echo >&2
  echo "### Error encountered (line $(caller))" >&2
  echo >&2
  echo "Restoring hooks from backup..." >&2

  rm -rf "$PROJECT_DIR/.git/hooks"
  mkdir -p "$PROJECT_DIR/.git/hooks"
  cp -r "$BACKUP_DIR/" "$PROJECT_DIR/.git/hooks"

  echo "Backup restored; aborting." >&2
  exit 3
}

trap 'on_error' ERR


# Configure everything in the .github/hooks directory
cd "$PROJECT_DIR/.github/hooks"

for dir in */; do
  hook=${dir//\/}

  echo "Configuring '$hook' hook(s)..."

  echo "  Creating '$hook.d' hook directory..."
  mkdir -p "$PROJECT_DIR/.git/hooks/$hook.d"

  # If a hook file already exists, check to see if we made it
  if [ -f "$PROJECT_DIR/.git/hooks/$hook" ]; then

    # If not, move it to be the first-run hook in our new folder
    case $(grep -Fx "# R&B HOOKS" "$PROJECT_DIR/.git/hooks/$hook" >/dev/null; echo $?) in

      # No marker existed, we need to move the file so that it is run first in our new folder
      1)
        echo "  Moving existing '$hook' file to run first in new set..."
        mv "$PROJECT_DIR/.git/hooks/$hook" "$PROJECT_DIR/.git/hooks/$hook.d/$hook.00-original"
        chmod +x "$PROJECT_DIR/.git/hooks/$hook.d/$hook.00-original"

        # Strip git lfs from the original, since we deal with it later
        grep -v "git lfs $hook \"\$@\"" "$PROJECT_DIR/.git/hooks/$hook.d/$hook.00-original" > temp; mv temp "$PROJECT_DIR/.git/hooks/$hook.d/$hook.00-original"
        ;;

      # Our marker existed, we can ignore this
      0) ;;

      # An unexpected error occurred
      *)
        echo "Unexpected error parsing existing hook file: $PROJECT_DIR/.git/hooks/$hook"
        false
        ;;
    esac
  fi

  # Create the new hook file to load in from the new directory
  echo "  Creating new '$hook' hook file to support multiple hook scripts..."
  cat <<EOT >> "$PROJECT_DIR/.git/hooks/$hook"
#!/usr/bin/env bash

# R&B HOOKS
# DO NOT MODIFY THIS FILE; ADD ADDITIONAL HOOKS TO .git/hooks/$hook.d/

cd "\$(dirname "\$0")/$hook.d"

for hook in *; do
    bash \$hook
    RESULT=\$?
    if [ \$RESULT != 0 ]; then
        echo "$hook.d/\$hook returned non-zero exit code: \$RESULT; aborting."
        exit \$RESULT
    fi
done

# Run git lfs, since it does a check that it's run from this exact file (for some annoying reason)
git lfs pre-push "\$@"

exit 0
EOT

  chmod +x "$PROJECT_DIR/.git/hooks/pre-push"


  # Copy our hooks over
  echo "  Linking new project '$hook' hooks..."

  cd "$PROJECT_DIR/.github/hooks/$hook"

  for script in *; do
    echo "    Copying $script..."
    rm -rf "$PROJECT_DIR/.git/hooks/$hook.d/$script"
    ln -s "$PROJECT_DIR/.github/hooks/$hook/$script" "$PROJECT_DIR/.git/hooks/$hook.d/"
    chmod +x "$PROJECT_DIR/.git/hooks/$hook.d/$script"
  done
done
