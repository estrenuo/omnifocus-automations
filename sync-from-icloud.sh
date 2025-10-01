#!/bin/bash

# OmniFocus Plugin Reverse Sync Script
# Copies plugin files from iCloud Drive OmniFocus Plug-Ins folder back to this repository
# Useful if you edit plugins directly in OmniFocus and want to save changes to git

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
    "JIRA-Import.omnifocusjs"
)

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}OmniFocus Plugin Sync from iCloud${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if iCloud Drive OmniFocus folder exists
if [ ! -d "$ICLOUD_PLUGINS_DIR" ]; then
    echo -e "${RED}Error: iCloud Drive OmniFocus Plug-Ins folder not found!${NC}"
    echo -e "${YELLOW}Expected path: $ICLOUD_PLUGINS_DIR${NC}"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ Found iCloud OmniFocus Plug-Ins folder${NC}"
echo -e "  Path: $ICLOUD_PLUGINS_DIR"
echo ""

# Check if plugin files exist in iCloud
missing_files=0
for plugin in "${PLUGINS[@]}"; do
    if [ ! -f "$ICLOUD_PLUGINS_DIR/$plugin" ]; then
        echo -e "${YELLOW}⚠ Not in iCloud: $plugin${NC}"
        missing_files=$((missing_files + 1))
    fi
done

if [ $missing_files -eq ${#PLUGINS[@]} ]; then
    echo -e "${RED}Error: No plugin files found in iCloud${NC}"
    echo -e "${YELLOW}Run ./sync-to-icloud.sh first to copy plugins to iCloud${NC}"
    exit 1
fi

echo ""

# Sync each plugin
echo -e "${BLUE}Syncing plugins from iCloud...${NC}"
echo ""

synced_count=0
updated_count=0
new_count=0
skipped_count=0

for plugin in "${PLUGINS[@]}"; do
    source_file="$ICLOUD_PLUGINS_DIR/$plugin"
    dest_file="$SCRIPT_DIR/$plugin"
    
    # Check if file exists in iCloud
    if [ ! -f "$source_file" ]; then
        echo -e "${YELLOW}  - $plugin${NC} (not in iCloud, skipped)"
        skipped_count=$((skipped_count + 1))
        continue
    fi
    
    # Check if file exists in destination
    if [ -f "$dest_file" ]; then
        # Compare files
        if cmp -s "$source_file" "$dest_file"; then
            echo -e "${BLUE}  ≈ $plugin${NC} (no changes)"
        else
            # Files are different, show warning and copy
            echo -e "${YELLOW}  ↻ $plugin${NC} (updated from iCloud)"
            cp "$source_file" "$dest_file"
            updated_count=$((updated_count + 1))
        fi
    else
        # New file
        cp "$source_file" "$dest_file"
        echo -e "${GREEN}  + $plugin${NC} (new from iCloud)"
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
echo "  Total plugins checked: ${#PLUGINS[@]}"
echo "  Synced: $synced_count"
echo "  New: $new_count"
echo "  Updated: $updated_count"
echo "  Unchanged: $((synced_count - new_count - updated_count))"
echo "  Skipped: $skipped_count"
echo ""

if [ $updated_count -gt 0 ]; then
    echo -e "${YELLOW}⚠ Warning: $updated_count file(s) were updated from iCloud${NC}"
    echo "Review the changes before committing to git:"
    echo "  git diff"
    echo ""
fi

echo -e "${GREEN}Plugins synced from:${NC}"
echo "  $ICLOUD_PLUGINS_DIR"
echo -e "${GREEN}To repository:${NC}"
echo "  $SCRIPT_DIR"
echo ""

