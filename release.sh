#!/bin/bash

# OmniFocus Plugin Release Script
# Bumps version, updates changelog, syncs to iCloud, and creates git tag

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Plugin files
PLUGINS=(
    "AI-Task-Clarifier.omnifocusjs"
    "AI-Task-Breakdown.omnifocusjs"
    "JIRA-Import.omnifocusjs"
)

CHANGELOG_FILE="$SCRIPT_DIR/CHANGELOG.md"

# Function to extract current version from plugin file
get_version() {
    local file=$1
    grep -o '"version": "[^"]*"' "$file" | cut -d'"' -f4
}

# Function to bump version
bump_version() {
    local version=$1
    local bump_type=$2
    
    IFS='.' read -ra PARTS <<< "$version"
    local major=${PARTS[0]}
    local minor=${PARTS[1]:-0}
    local patch=${PARTS[2]:-0}
    
    case $bump_type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo "Invalid bump type: $bump_type"
            exit 1
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# Function to update version in file
update_version() {
    local file=$1
    local new_version=$2
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/\"version\": \"[^\"]*\"/\"version\": \"$new_version\"/" "$file"
    else
        sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$new_version\"/" "$file"
    fi
}

# Function to create/update changelog
update_changelog() {
    local version=$1
    local changes=$2
    local date=$(date +%Y-%m-%d)
    
    if [ ! -f "$CHANGELOG_FILE" ]; then
        # Create new changelog
        cat > "$CHANGELOG_FILE" << EOF
# Changelog

All notable changes to the OmniFocus plugins will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [${version}] - ${date}

${changes}

EOF
    else
        # Insert new version at the top (after header)
        local temp_file=$(mktemp)
        local header_done=false
        
        while IFS= read -r line; do
            echo "$line" >> "$temp_file"
            if [[ "$line" == "## "* ]] && [ "$header_done" = false ]; then
                # Found first version entry, insert new version before it
                echo "" >> "$temp_file"
                echo "## [${version}] - ${date}" >> "$temp_file"
                echo "" >> "$temp_file"
                echo "${changes}" >> "$temp_file"
                echo "" >> "$temp_file"
                header_done=true
            fi
        done < "$CHANGELOG_FILE"
        
        # If no version entries found, append to end
        if [ "$header_done" = false ]; then
            echo "" >> "$temp_file"
            echo "## [${version}] - ${date}" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "${changes}" >> "$temp_file"
        fi
        
        mv "$temp_file" "$CHANGELOG_FILE"
    fi
}

# Main script
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}OmniFocus Plugin Release${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if bump type is provided
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Usage: $0 <bump_type> [--no-sync] [--no-tag]${NC}"
    echo ""
    echo "Bump types:"
    echo "  major - Bump major version (1.0.0 -> 2.0.0)"
    echo "  minor - Bump minor version (1.0.0 -> 1.1.0)"
    echo "  patch - Bump patch version (1.0.0 -> 1.0.1)"
    echo ""
    echo "Options:"
    echo "  --no-sync  Skip iCloud sync"
    echo "  --no-tag   Skip git tag creation"
    echo ""
    echo "Examples:"
    echo "  $0 patch                # Full release: bump, sync, tag"
    echo "  $0 minor --no-tag       # Bump and sync, but don't tag"
    echo ""
    exit 1
fi

BUMP_TYPE=$1
NO_SYNC=false
NO_TAG=false

# Parse options
shift
while [[ $# -gt 0 ]]; do
    case $1 in
        --no-sync)
            NO_SYNC=true
            shift
            ;;
        --no-tag)
            NO_TAG=true
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Validate bump type
if [[ ! "$BUMP_TYPE" =~ ^(major|minor|patch)$ ]]; then
    echo -e "${RED}Error: Invalid bump type '$BUMP_TYPE'${NC}"
    echo "Valid types: major, minor, patch"
    exit 1
fi

# Get current version from first plugin
current_version=$(get_version "$SCRIPT_DIR/${PLUGINS[0]}")
new_version=$(bump_version "$current_version" "$BUMP_TYPE")

echo -e "${CYAN}Current version: ${current_version}${NC}"
echo -e "${CYAN}New version: ${GREEN}${new_version}${NC}"
echo ""

# Prompt for changelog entry
echo -e "${YELLOW}Enter changelog entry (press Ctrl+D when done):${NC}"
echo -e "${YELLOW}Tip: Use markdown format. Example:${NC}"
echo -e "${YELLOW}### Added${NC}"
echo -e "${YELLOW}- New feature description${NC}"
echo -e "${YELLOW}### Fixed${NC}"
echo -e "${YELLOW}- Bug fix description${NC}"
echo ""

changelog_entry=$(cat)

if [ -z "$changelog_entry" ]; then
    echo -e "${RED}Error: Changelog entry is required${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Release Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${CYAN}Version: ${current_version} → ${GREEN}${new_version}${NC}"
echo -e "${CYAN}Plugins to update: ${#PLUGINS[@]}${NC}"
echo -e "${CYAN}Sync to iCloud: $([ "$NO_SYNC" = true ] && echo "No" || echo "Yes")${NC}"
echo -e "${CYAN}Create git tag: $([ "$NO_TAG" = true ] && echo "No" || echo "Yes")${NC}"
echo ""
echo -e "${YELLOW}Changelog:${NC}"
echo "$changelog_entry"
echo ""

read -p "Proceed with release? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Release cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}Processing...${NC}"
echo ""

# Update version in all plugins
for plugin in "${PLUGINS[@]}"; do
    plugin_file="$SCRIPT_DIR/$plugin"
    
    if [ ! -f "$plugin_file" ]; then
        echo -e "${RED}✗ File not found: $plugin${NC}"
        continue
    fi
    
    update_version "$plugin_file" "$new_version"
    
    updated_version=$(get_version "$plugin_file")
    
    if [ "$updated_version" = "$new_version" ]; then
        echo -e "${GREEN}✓ Updated $plugin to v${new_version}${NC}"
    else
        echo -e "${RED}✗ Failed to update $plugin${NC}"
        exit 1
    fi
done

echo ""

# Update changelog
echo -e "${BLUE}Updating changelog...${NC}"
update_changelog "$new_version" "$changelog_entry"
echo -e "${GREEN}✓ Changelog updated${NC}"
echo ""

# Sync to iCloud
if [ "$NO_SYNC" = false ]; then
    echo -e "${BLUE}Syncing to iCloud...${NC}"
    if [ -f "$SCRIPT_DIR/sync-to-icloud.sh" ]; then
        "$SCRIPT_DIR/sync-to-icloud.sh"
    else
        echo -e "${RED}Warning: sync-to-icloud.sh not found${NC}"
    fi
    echo ""
fi

# Git operations
echo -e "${BLUE}Git operations...${NC}"

# Stage changes
git add *.omnifocusjs CHANGELOG.md 2>/dev/null || true

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo -e "${YELLOW}No changes to commit${NC}"
else
    # Commit
    git commit -m "Release v${new_version}

${changelog_entry}"
    echo -e "${GREEN}✓ Changes committed${NC}"
fi

# Create tag
if [ "$NO_TAG" = false ]; then
    if git rev-parse "v${new_version}" >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠ Tag v${new_version} already exists${NC}"
    else
        git tag -a "v${new_version}" -m "Release v${new_version}

${changelog_entry}"
        echo -e "${GREEN}✓ Tag v${new_version} created${NC}"
    fi
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Release Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${CYAN}Version: ${GREEN}v${new_version}${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  1. Test the plugins in OmniFocus"
echo "  2. Push changes: git push"
if [ "$NO_TAG" = false ]; then
    echo "  3. Push tags: git push --tags"
fi
echo ""

