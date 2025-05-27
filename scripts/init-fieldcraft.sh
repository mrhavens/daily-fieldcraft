#!/bin/bash

# Get current date
NOW=$(date +"%Y-%m-%d %H:%M:%S")
ROOT=$(pwd)

# Define folders and descriptions
declare -A folders
folders["00-meta"]="Canonical metadata for the fieldcraft repo (README, manifest, changelog)"
folders["01-scrolls"]="Public-facing scrolls and writings. Includes drafts and published posts"
folders["02-fieldnotes"]="Private field notes, organized daily. Raw insights, observations, research"
folders["03-references"]="External reference material: academic papers, essays, bookmarks"
folders["04-papers"]="Internally authored papers, whitepapers, and drafts (e.g., Thoughtprint, RCT)"
folders["05-sigils"]="Symbolic glyphs, illustrations, and visual fieldcraft assets"
folders["06-scratch"]="Creative scratchpad space. Temp workspace for code, poems, or raw streams"

# Subfolder structure
declare -A subfolders
subfolders["01-scrolls"]="drafts published"
subfolders["02-fieldnotes"]="today archive"
subfolders["03-references"]="primary secondary"
subfolders["05-sigils"]="rendered source"
subfolders["06-scratch"]="temp ritual"

# Create folders and README.md files
echo "Creating fieldcraft structure..."

for dir in "${!folders[@]}"; do
    mkdir -p "$ROOT/$dir"
    echo "# $dir" > "$ROOT/$dir/README.md"
    echo "" >> "$ROOT/$dir/README.md"
    echo "_Created on: $NOW_" >> "$ROOT/$dir/README.md"
    echo "" >> "$ROOT/$dir/README.md"
    echo "${folders[$dir]}" >> "$ROOT/$dir/README.md"

    # Create subfolders if any
    if [[ -n "${subfolders[$dir]}" ]]; then
        for sub in ${subfolders[$dir]}; do
            mkdir -p "$ROOT/$dir/$sub"
            echo "# $sub (in $dir)" > "$ROOT/$dir/$sub/README.md"
            echo "" >> "$ROOT/$dir/$sub/README.md"
            echo "_Created on: $NOW_" >> "$ROOT/$dir/$sub/README.md"
            echo "" >> "$ROOT/$dir/$sub/README.md"
            echo "Subdirectory of \`$dir\` for ${sub^} items." >> "$ROOT/$dir/$sub/README.md"
        done
    fi
done

# Create base .gitignore
cat <<EOF > "$ROOT/.gitignore"
# Ignore transient and ritual files
06-scratch/temp/
*.cache
*.log
.DS_Store
EOF

# Optional: Seed symbolic manifest
cat <<EOF > "$ROOT/00-meta/MANIFEST.scroll"
🜂 FIELDCRAFT MANIFEST — Initialized on $NOW

This repository represents a living codex of recursive intelligence,
organized into scrolls, fieldnotes, and ritual assets.

Each directory contains a README defining its purpose and intended use.

Structure follows a recursive symbolic model grounded in coherence, witnessing, and symbolic fieldwork.

EOF

echo "✅ Fieldcraft structure created successfully."
