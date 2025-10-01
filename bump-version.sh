#!/bin/bash

# OmniFocus Plugin Version Bumper
# Bumps the version number in plugin metadata and syncs to iCloud

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
    
    # Use sed to replace version in the JSON metadata
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/\"version\": \"[^\"]*\"/\"version\": \"$new_version\"/" "$file"
    else
        # Linux
        sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$new_version\"/" "$file"
    fi
}

# Main script
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}OmniFocus Plugin Version Bumper${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if bump type is provided
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Usage: $0 <bump_type> [plugin_name]${NC}"
    echo ""
    echo "Bump types:"
    echo "  major - Bump major version (1.0.0 -> 2.0.0)"
    echo "  minor - Bump minor version (1.0.0 -> 1.1.0)"
    echo "  patch - Bump patch version (1.0.0 -> 1.0.1)"
    echo ""
    echo "Examples:"
    echo "  $0 patch                    # Bump patch version for all plugins"
    echo "  $0 minor AI-Task-Clarifier  # Bump minor version for specific plugin"
    echo ""
    exit 1
fi

BUMP_TYPE=$1
SPECIFIC_PLUGIN=$2

# Validate bump type
if [[ ! "$BUMP_TYPE" =~ ^(major|minor|patch)$ ]]; then
    echo -e "${RED}Error: Invalid bump type '$BUMP_TYPE'${NC}"
    echo "Valid types: major, minor, patch"
    exit 1
fi

# Determine which plugins to bump
PLUGINS_TO_BUMP=()
if [ -n "$SPECIFIC_PLUGIN" ]; then
    # Check if specific plugin exists
    found=false
    for plugin in "${PLUGINS[@]}"; do
        if [[ "$plugin" == *"$SPECIFIC_PLUGIN"* ]]; then
            PLUGINS_TO_BUMP+=("$plugin")
            found=true
        fi
    done
    
    if [ "$found" = false ]; then
        echo -e "${RED}Error: Plugin matching '$SPECIFIC_PLUGIN' not found${NC}"
        echo "Available plugins:"
        for plugin in "${PLUGINS[@]}"; do
            echo "  - $plugin"
        done
        exit 1
    fi
else
    # Bump all plugins
    PLUGINS_TO_BUMP=("${PLUGINS[@]}")
fi

echo -e "${CYAN}Bump type: $BUMP_TYPE${NC}"
echo -e "${CYAN}Plugins to update: ${#PLUGINS_TO_BUMP[@]}${NC}"
echo ""

# Process each plugin
for plugin in "${PLUGINS_TO_BUMP[@]}"; do
    plugin_file="$SCRIPT_DIR/$plugin"
    
    if [ ! -f "$plugin_file" ]; then
        echo -e "${RED}✗ File not found: $plugin${NC}"
        continue
    fi
    
    # Get current version
    current_version=$(get_version "$plugin_file")
    
    if [ -z "$current_version" ]; then
        echo -e "${RED}✗ Could not extract version from $plugin${NC}"
        continue
    fi
    
    # Calculate new version
    new_version=$(bump_version "$current_version" "$BUMP_TYPE")
    
    # Update version in file
    update_version "$plugin_file" "$new_version"
    
    # Verify update
    updated_version=$(get_version "$plugin_file")
    
    if [ "$updated_version" = "$new_version" ]; then
        echo -e "${GREEN}✓ $plugin${NC}"
        echo -e "  ${current_version} → ${GREEN}${new_version}${NC}"
    else
        echo -e "${RED}✗ Failed to update $plugin${NC}"
        echo -e "  Expected: $new_version, Got: $updated_version"
    fi
done

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Version Bump Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Ask if user wants to sync to iCloud
echo -e "${YELLOW}Sync updated plugins to iCloud?${NC}"
read -p "Press 'y' to sync, any other key to skip: " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    if [ -f "$SCRIPT_DIR/sync-to-icloud.sh" ]; then
        "$SCRIPT_DIR/sync-to-icloud.sh"
    else
        echo -e "${RED}Error: sync-to-icloud.sh not found${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Skipped iCloud sync${NC}"
    echo "Run './sync-to-icloud.sh' manually when ready"
fi

echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  1. Test the updated plugins in OmniFocus"
echo "  2. Commit changes: git add *.omnifocusjs && git commit -m 'Bump version to $new_version'"
echo "  3. Tag release: git tag v$new_version && git push --tags"
echo ""

