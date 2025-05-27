#!/bin/bash

# --- CONFIG ---
WORKDIR=$(pwd)
ARCHIVE_DIR="$WORKDIR/.archive"
TODAY=$(date +"%Y-%m-%d")
ARCHIVE_SCRIPT="$WORKDIR/scripts/archive-fieldcraft.sh"
INIT_SCRIPT="$WORKDIR/scripts/init-fieldcraft.sh"

# --- FLAGS ---
FORCE=false
if [[ "$1" == "--force" ]]; then
  FORCE=true
  echo "🚨 Force mode activated: Skipping archive check."
fi

# --- STEP 1: Check or Force Archive ---
if $FORCE; then
  echo "🌀 Running archive-fieldcraft.sh..."
  bash "$ARCHIVE_SCRIPT"
else
  echo "🔍 Checking for existing archive for today ($TODAY)..."
  ARCHIVE_MATCH=$(find "$ARCHIVE_DIR" -maxdepth 1 -type d -name "$TODAY*" | head -n 1)

  if [[ -d "$ARCHIVE_MATCH" && -f "$ARCHIVE_MATCH"/*.zip ]]; then
    echo "✅ Archive already exists at: $ARCHIVE_MATCH"
  else
    echo "🌀 No archive found for today. Running archive-fieldcraft.sh..."
    bash "$ARCHIVE_SCRIPT"

    # Confirm again
    ARCHIVE_MATCH=$(find "$ARCHIVE_DIR" -maxdepth 1 -type d -name "$TODAY*" | head -n 1)
    if [[ -d "$ARCHIVE_MATCH" && -f "$ARCHIVE_MATCH"/*.zip ]]; then
      echo "✅ Archive confirmed at: $ARCHIVE_MATCH"
    else
      echo "❌ Archive failed. Aborting rotation."
      exit 1
    fi
  fi
fi

# --- STEP 2: Delete all except .git, .archive, and scripts ---
echo "⚠️ Deleting fieldcraft working structure (except archive/git/scripts)..."

for d in "$WORKDIR"/*; do
  base=$(basename "$d")
  if [[ "$base" =~ ^(scripts|.git|.archive)$ ]]; then
    continue
  fi
  echo "🧹 Removing $base..."
  rm -rf "$d"
done

# --- STEP 3: Re-initialize the structure ---
echo "🔁 Running init-fieldcraft.sh to reset working environment..."
bash "$INIT_SCRIPT"

echo "✅ Fieldcraft rotation complete."
