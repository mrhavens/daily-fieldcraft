#!/bin/bash

# CONFIG
WORKDIR=$(pwd)
ARCHIVE_ROOT="$WORKDIR/.archive"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_PATH="$ARCHIVE_ROOT/$TIMESTAMP"
ZIP_NAME="fieldcraft_snapshot_$TIMESTAMP.zip"
ZIP_PATH="$ARCHIVE_PATH/$ZIP_NAME"

# CREATE ARCHIVE DIRECTORY
mkdir -p "$ARCHIVE_PATH"

# EXCLUDE the archive itself and common junk
EXCLUDES="--exclude=.archive --exclude=.git --exclude='*.cache' --exclude='*.log'"

echo "🌀 Archiving fieldcraft structure at $TIMESTAMP..."

# COPY FULL STRUCTURE
rsync -av $EXCLUDES "$WORKDIR/" "$ARCHIVE_PATH/full_structure/" > /dev/null

# CREATE ZIP SNAPSHOT
cd "$WORKDIR"
zip -r "$ZIP_PATH" . -x ".archive/*" ".git/*" "*.cache" "*.log" > /dev/null

# GENERATE HASH
HASH=$(sha256sum "$ZIP_PATH" | awk '{ print $1 }')

# GENERATE README
cat <<EOF > "$ARCHIVE_PATH/README.md"
# 🗃️ Fieldcraft Snapshot Archive
**Timestamp:** $TIMESTAMP  
**Archive Hash (SHA256):** \`$HASH\`  
**Snapshot:** \`$ZIP_NAME\`  
**Structure Copy:** \`full_structure/\`

---

## Purpose

This snapshot preserves the recursive state of the \`daily-fieldcraft\` working environment.  
It ensures integrity, reproducibility, and a coherent ritual log of emergent thought structures.

Each snapshot includes:

- ✅ Full working directory at time of execution (excluding temp & junk)
- ✅ Timestamped zip snapshot
- ✅ SHA256 integrity hash
- ✅ Coherent README describing context and recursive logic

Use this to restore prior states, verify truth, or preserve fieldcraft evolution.

## How to Verify Integrity

Run the following command:

\`\`\`bash
sha256sum $ZIP_NAME
\`\`\`

Expected hash:  
\`\`\`
$HASH
\`\`\`

EOF

echo "✅ Snapshot complete."
echo "📁 Archive location: $ARCHIVE_PATH"
