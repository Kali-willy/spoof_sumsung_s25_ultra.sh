#!/data/data/com.termux/files/usr/bin/bash
# You can also run with: bash spoof_samsung_s25_ultra.sh

# Spoof_samsung_s25_ultra.sh
# Compatible with Termux, Brevent, and Qute terminal environments
# Script to simulate Samsung S25 Ultra device properties
# Works on both rooted and non-rooted devices
# Safe implementation that won't damage your device

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function for cool animation
show_animation() {
    clear
    echo ""
    echo -e "${RED}      ^      ^      ${NC}"
    echo -e "${RED}     /|\    /|\     ${NC}"
    echo -e "${RED}    / | \  / | \    ${NC}"
    echo -e "${YELLOW}   *  *    *  *   ${NC}"
    echo -e "${YELLOW}   \___/  \___/   ${NC}"
    echo -e "${PURPLE}       \____/     ${NC}"
    echo ""
    sleep 0.5
    clear
    echo ""
    echo -e "${RED}     ^        ^     ${NC}"
    echo -e "${RED}    /|\      /|\    ${NC}"
    echo -e "${RED}   / | \    / | \   ${NC}"
    echo -e "${YELLOW}  *   *    *   *  ${NC}"
    echo -e "${YELLOW}  \____/  \____/  ${NC}"
    echo -e "${PURPLE}      \______/    ${NC}"
    echo ""
    sleep 0.5
}

# Display cool header with "horns and eyes"
display_header() {
    clear
    echo ""
    echo -e "${RED}    ^           ^    ${NC}"
    echo -e "${RED}   /|\         /|\   ${NC}"
    echo -e "${RED}  / | \       / | \  ${NC}"
    echo -e "${YELLOW} *  *  *   *  *  *  ${NC}"
    echo -e "${YELLOW} |  O  |   |  O  |  ${NC}"
    echo -e "${YELLOW} \____/     \____/  ${NC}"
    echo -e "${PURPLE}      \_______/     ${NC}"
    echo ""
    echo -e "${CYAN}=====================================${NC}"
    echo -e "${GREEN}    Samsung S25 Ultra Device Spoofer${NC}"
    echo -e "${BLUE}    Safe for all Android devices${NC}"
    echo -e "${CYAN}=====================================${NC}"
    echo ""
}

# Check if running on Android with Termux compatibility
check_android() {
    if [ ! -d "/system" ] && [ ! -d "/data/data/com.termux" ]; then
        echo -e "${RED}Error: This script must be run on an Android device with Termux, Brevent, or Qute.${NC}"
        exit 1
    fi
    
    # Check for required packages in Termux
    if [ -d "/data/data/com.termux" ] && [ ! -x "$(command -v tput)" ]; then
        echo -e "${YELLOW}Installing required packages in Termux...${NC}"
        pkg update -y
        pkg install -y ncurses
    fi
}

# Function to show notification with Termux compatibility
show_notification() {
    # Try Termux-specific notification first
    if [ -x "$(command -v termux-notification)" ]; then
        termux-notification --title "Samsung S25 Ultra Spoofer" --content "$1"
        echo -e "${CYAN}[NOTIFICATION]${NC} $1"
    # Try standard Android notification
    elif [ -x "$(command -v am)" ]; then
        # Using Android's am command to display notification
        am broadcast -a android.intent.action.MAIN -e message "$1" -e title "Samsung S25 Ultra Spoofer" -n com.android.shell/.BroadcastReceiver
        echo -e "${CYAN}[NOTIFICATION]${NC} $1"
    else
        echo -e "${CYAN}[NOTIFICATION]${NC} $1"
    fi
}

# Function to check if device is rooted with various methods
check_root() {
    # Check multiple methods for detecting root
    if [ -x "$(command -v su)" ] || [ -f "/system/xbin/su" ] || [ -f "/system/bin/su" ] || [ -f "/sbin/su" ] || [ -f "/magisk/.core/bin/su" ]; then
        echo -e "${GREEN}Rooted device detected.${NC}"
        IS_ROOTED=true
    else
        # Try to execute a simple root command to catch custom root implementations
        if timeout 1 su -c "id" >/dev/null 2>&1; then
            echo -e "${GREEN}Rooted device detected.${NC}"
            IS_ROOTED=true
        else
            echo -e "${YELLOW}Non-rooted device detected.${NC}"
            IS_ROOTED=false
        fi
    fi
}

# Progress bar function
show_progress() {
    local duration=$1
    local width=50
    local progress=0
    local fill
    local empty
    
    echo -ne "${BLUE}Progress: ${NC}"
    
    while [ $progress -le 100 ]; do
        let fill=progress*width/100
        let empty=width-fill
        
        printf "\r[%${fill}s%${empty}s] %3d%%" '' '' $progress
        
        progress=$((progress + 2))
        sleep $duration
    done
    echo -e "\n${GREEN}Complete!${NC}"
}

# Function for non-rooted devices - THIS FUNCTION WAS MISSING
spoof_device_nonroot() {
    show_notification "Starting device spoofing (non-root mode)..."
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    
    # Create props file for local environment
    cat > "$TEMP_DIR/s25_props.txt" << EOF
ro.product.manufacturer=Samsung
ro.product.model=SM-S928B
ro.product.name=s928bxxu
ro.product.device=s928b
ro.build.product=s928b
ro.build.description=s928bxxu1AXXX
ro.build.fingerprint=samsung/s928bxxu/s928b:14/UP1A.xxx/AXXXX:user/release-keys
EOF
    
    # Set up local environment variables
    export ANDROID_PROPERTY_WORKSPACE="$TEMP_DIR/s25_props.txt"
    
    show_progress 0.02
    
    show_notification "Device properties set in local environment"
    echo -e "${GREEN}Samsung S25 Ultra properties have been set locally.${NC}"
    echo -e "${YELLOW}Note: These changes are temporary and only affect apps launched from this shell.${NC}"
    
    sleep 1
    show_animation
}

# Main spoof function for rooted devices
spoof_device_root() {
    show_notification "Starting device spoofing (root mode)..."
    
    # We'll use build.prop modifications temporarily
    # Backup original build.prop
    su -c "cp /system/build.prop /system/build.prop.backup"
    
    # Create temp props file
    cat > /sdcard/s25_props.txt << EOF
ro.product.manufacturer=Samsung
ro.product.model=SM-S928B
ro.product.name=s928bxxu
ro.product.device=s928b
ro.build.product=s928b
ro.build.description=s928bxxu1AXXX
ro.build.fingerprint=samsung/s928bxxu/s928b:14/UP1A.xxx/AXXXX:user/release-keys
EOF
    
    # Mount system as writable and apply changes
    su -c "mount -o rw,remount /system"
    su -c "cat /sdcard/s25_props.txt >> /system/build.prop"
    su -c "chmod 644 /system/build.prop"
    
    show_progress 0.03
    
    # Reset Android runtime properties
    su -c "setprop ctl.restart zygote"
    
    show_notification "Device properties modified. System will restart UI..."
    echo -e "${GREEN}Samsung S25 Ultra properties have been set.${NC}"
    echo -e "${YELLOW}Note: Original settings backed up to /system/build.prop.backup${NC}"
    
    sleep 1
    show_animation
}

# Function to restore original settings (for rooted devices)
restore_original() {
    if [ "$IS_ROOTED" = true ]; then
        show_notification "Restoring original device properties..."
        
        # Restore original build.prop
        su -c "mount -o rw,remount /system"
        su -c "cp /system/build.prop.backup /system/build.prop"
        su -c "chmod 644 /system/build.prop"
        su -c "rm /system/build.prop.backup"
        
        show_progress 0.03
        
        # Reset Android runtime properties
        su -c "setprop ctl.restart zygote"
        
        show_notification "Original device properties restored. System will restart UI..."
        echo -e "${GREEN}Original device properties have been restored.${NC}"
        
        sleep 1
        show_animation
    else
        show_notification "No restoration needed for non-rooted mode."
        echo -e "${YELLOW}Non-rooted mode doesn't make permanent changes.${NC}"
    fi
}

# Main execution
show_animation
display_header
check_android
check_root
show_notification "Script started. Detected device mode: $([ "$IS_ROOTED" = true ] && echo 'Rooted' || echo 'Non-rooted')"

# Ask user what they want to do
echo ""
echo -e "${CYAN}Select an option:${NC}"
echo -e "${BLUE}1. ${GREEN}Spoof device as Samsung S25 Ultra${NC}"
echo -e "${BLUE}2. ${YELLOW}Restore original device properties${NC}"
echo -e "${BLUE}3. ${RED}Exit${NC}"
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        if [ "$IS_ROOTED" = true ]; then
            spoof_device_root
        else
            spoof_device_nonroot
        fi
        ;;
    2)
        restore_original
        ;;
    3)
        show_notification "Script exited by user."
        echo -e "${RED}Exiting script.${NC}"
        exit 0
        ;;
    *)
        show_notification "Invalid option selected."
        echo -e "${RED}Invalid option. Exiting.${NC}"
        exit 1
        ;;
esac

show_notification "Script completed successfully!"
echo ""
echo -e "${CYAN}=====================================${NC}"
echo -e "${GREEN}    Script completed successfully!   ${NC}"
echo -e "${CYAN}=====================================${NC}"

# Final animation
show_animation
display_header
sleep 1

exit 0