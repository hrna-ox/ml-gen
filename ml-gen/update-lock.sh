#!/usr/bin/env bash

set -e

# Ensure uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ uv is not installed. Please install uv to proceed."
    exit 1
fi

### HELPER FUNCTIONS
log() {
    echo -e "👉 $1"
}

generate_lockfile() {
    uv pip compile pyproject.toml --generate-hashes > "$1"
    log "🔒 Lockfile $1 generated successfully."
}

sync_environment() {
    uv pip sync "$1"
    log "✅ Environment synchronized with $1."
}

generate_requirements_txt() {
    grep -E '^[a-zA-Z0-9\-\_]+[=<>!]' "$1" | cut -d' ' -f1 > "$2"
    log "📄 $2 updated with minimal direct dependencies."
}

# Initialize lock files
LOCKFILE="uv.lock"
TMP_LOCK="uv.lock.tmp"
REQUIREMENTS_FILE="requirements.txt"

# Step 1: If no LOCKFILE exists, create one immediately
if [[ ! -f "$LOCKFILE" ]]; then
    log "📦 No lockfile found. Generating initial $LOCKFILE..."

    # Generate Lockfile
    generate_lockfile "$LOCKFILE"

    # Sync environment with the generated lockfile
    sync_environment "$LOCKFILE"

    # Create a minimal requirements file
    generate_requirements_txt "$LOCKFILE" "$REQUIREMENTS_FILE"
    exit 0
fi

# Check for Environment updates first
log  "Checking for environment updates..."

# 1. Generate a new lockfile in a temporary file
generate_lockfile "$TMP_LOCK"

# 2. Compare the new lockfile with the existing one
if cmp -s "TMP_LOCK" "$LOCKFILE"; then
    log "✅ No changes in dependencies. Environment is up-to-date."
    rm "$TMP_LOCK"
else
    echo "🔄 Changes detected in dependencies. Updating lockfile..."

    # 3. If there are changes, replace the old lockfile with the new one
    mv "$TMP_LOCK" "$LOCKFILE"
    sync_environment "$LOCKFILE"

    # 5. Generate a minimal requirements file
    generate_requirements_txt "$LOCKFILE" "$REQUIREMENTS_FILE"
fi