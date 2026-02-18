#!/bin/bash

# OmniFocus Plugin Sync Script
# Copies plugin files from this repository to iCloud Drive OmniFocus Plug-Ins folder
# This allows you to edit plugins locally and sync them to OmniFocus

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# iCloud Drive OmniFocus Plug-Ins path (portable using $USER)
ICLOUD_PLUGINS_DIR="/Users/$USER/Library/Mobile Documents/iCloud~com~omnigroup~OmniFocus/Documents/Plug-Ins"

# Plugin files to sync
PLUGINS=(
    "AI-Task-Clarifier.omnifocusjs"
    "AI-Task-Breakdown.omnifocusjs"
    "Headless-Settings.omnifocusjs"
    "JIRA-Import.omnifocusjs"
)

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}OmniFocus Plugin Sync to iCloud${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if iCloud Drive OmniFocus folder exists
if [ ! -d "$ICLOUD_PLUGINS_DIR" ]; then
    echo -e "${RED}Error: iCloud Drive OmniFocus Plug-Ins folder not found!${NC}"
    echo -e "${YELLOW}Expected path: $ICLOUD_PLUGINS_DIR${NC}"
    echo ""
    echo "Possible reasons:"
    echo "  1. iCloud Drive is not enabled"
    echo "  2. OmniFocus is not syncing to iCloud"
    echo "  3. OmniFocus has not created the Plug-Ins folder yet"
    echo ""
    echo "To fix:"
    echo "  1. Open OmniFocus"
    echo "  2. Go to Settings/Preferences"
    echo "  3. Enable iCloud sync if not already enabled"
    echo "  4. Install at least one plugin to create the Plug-Ins folder"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ Found iCloud OmniFocus Plug-Ins folder${NC}"
echo -e "  Path: $ICLOUD_PLUGINS_DIR"
echo ""

# Check if plugin files exist in current directory
missing_files=0
for plugin in "${PLUGINS[@]}"; do
    if [ ! -f "$SCRIPT_DIR/$plugin" ]; then
        echo -e "${RED}✗ Missing: $plugin${NC}"
        missing_files=$((missing_files + 1))
    fi
done

if [ $missing_files -gt 0 ]; then
    echo -e "${RED}Error: $missing_files plugin file(s) not found in current directory${NC}"
    echo -e "${YELLOW}Current directory: $SCRIPT_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All plugin files found in repository${NC}"
echo ""

# Sync each plugin
echo -e "${BLUE}Syncing plugins...${NC}"
echo ""

synced_count=0
updated_count=0
new_count=0

for plugin in "${PLUGINS[@]}"; do
    source_file="$SCRIPT_DIR/$plugin"
    dest_file="$ICLOUD_PLUGINS_DIR/$plugin"
    
    # Check if file exists in destination
    if [ -f "$dest_file" ]; then
        # Compare files
        if cmp -s "$source_file" "$dest_file"; then
            echo -e "${BLUE}  ≈ $plugin${NC} (no changes)"
        else
            # Files are different, copy and show what changed
            cp "$source_file" "$dest_file"
            echo -e "${YELLOW}  ↻ $plugin${NC} (updated)"
            updated_count=$((updated_count + 1))
        fi
    else
        # New file
        cp "$source_file" "$dest_file"
        echo -e "${GREEN}  + $plugin${NC} (new)"
        new_count=$((new_count + 1))
    fi
    
    synced_count=$((synced_count + 1))
done

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Sync Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Summary:"
echo "  Total plugins: $synced_count"
echo "  New: $new_count"
echo "  Updated: $updated_count"
echo "  Unchanged: $((synced_count - new_count - updated_count))"
echo ""

if [ $new_count -gt 0 ] || [ $updated_count -gt 0 ]; then
    echo -e "${YELLOW}Note: OmniFocus will automatically detect the changes.${NC}"
    echo "If OmniFocus is running, the plugins will be reloaded."
    echo ""
fi

echo -e "${GREEN}Plugins synced to:${NC}"
echo "  $ICLOUD_PLUGINS_DIR"
echo ""

