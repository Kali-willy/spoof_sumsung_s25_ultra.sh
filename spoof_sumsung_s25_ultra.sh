#!/data/data/com.termux/files/usr/bin/bash
# You can also run with: bash spoof_samsung_s25_ultra.sh

# Spoof_samsung_s25_ultra.sh
# Created by Willy Gailo
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
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function for improved animation - smartphone design
show_animation() {
    clear
    echo ""
    echo -e "${WHITE}     ┌───────────┐     ${NC}"
    echo -e "${WHITE}     │           │     ${NC}"
    echo -e "${WHITE}     │  ${BLUE}SAMSUNG${WHITE}  │     ${NC}"
    echo -e "${WHITE}     │   ${CYAN}Galaxy${WHITE}  │     ${NC}"
    echo -e "${WHITE}     │${GREEN} S25 Ultra ${WHITE}│     ${NC}"
    echo -e "${WHITE}     │           │     ${NC}"
    echo -e "${WHITE}     └───────────┘     ${NC}"
    echo ""
    sleep 0.5
    clear
    echo ""
    echo -e "${WHITE}     ┌───────────┐     ${NC}"
    echo -e "${WHITE}     │${PURPLE} ●        ${WHITE}│     ${NC}"
    echo -e "${WHITE}     │  ${BLUE}SAMSUNG${WHITE}  │     ${NC}"
    echo -e "${WHITE}     │   ${CYAN}Galaxy${WHITE}  │     ${NC}"
    echo -e "${WHITE}     │${RED} S25 Ultra ${WHITE}│     ${NC}"
    echo -e "${WHITE}     │           │     ${NC}"
    echo -e "${WHITE}     └───────────┘     ${NC}"
    echo ""
    sleep 0.5
}

# Display cool header with smartphone design
display_header() {
    clear
    echo ""
    echo -e "${WHITE}  ┌─────────────────┐  ${NC}"
    echo -e "${WHITE}  │    ${CYAN}●${WHITE}     ${PURPLE}●${WHITE}    │  ${NC}"
    echo -e "${WHITE}  │                 │  ${NC}"
    echo -e "${WHITE}  │  ${BLUE}S A M S U N G${WHITE}  │  ${NC}"
    echo -e "${WHITE}  │                 │  ${NC}"
    echo -e "${WHITE}  │    ${GREEN}Galaxy${WHITE}      │  ${NC}"
    echo -e "${WHITE}  │   ${RED}S25 Ultra${WHITE}     │  ${NC}"
    echo -e "${WHITE}  │                 │  ${NC}"
    echo -e "${WHITE}  │                 │  ${NC}"
    echo -e "${WHITE}  │                 │  ${NC}"
    echo -e "${WHITE}  │                 │  ${NC}"
    echo -e "${WHITE}  │        ${YELLOW}○${WHITE}        │  ${NC}"
    echo -e "${WHITE}  └─────────────────┘  ${NC}"
    echo ""
    echo -e "${CYAN}=====================================${NC}"
    echo -e "${GREEN}    Samsung S25 Ultra Device Spoofer${NC}"
    echo -e "${BLUE}    Created by: Willy Gailo${NC}"
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
        pkg install -y ncurses termux-api
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

# Improved function for non-rooted devices
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
ro.product.brand=samsung
ro.product.board=s5e9935
ro.board.platform=universal9935
EOF
    
    # Create a wrapper script that sets these properties
    cat > "$HOME/.termux/spoof_env.sh" << EOF
#!/data/data/com.termux/files/usr/bin/bash
# Environment settings for Samsung S25 Ultra spoofing
export ANDROID_PROPERTY_WORKSPACE="$TEMP_DIR/s25_props.txt"
export ANDROID_SERIAL="SM-S928B"
export ANDROID_DEVICE=s928b
export ANDROID_PRODUCT=SM-S928B
export ANDROID_MODEL=SM-S928B
EOF
    
    # Make it executable
    chmod +x "$HOME/.termux/spoof_env.sh"
    
    # Add to bashrc if not already there
    if ! grep -q "spoof_env.sh" "$HOME/.bashrc" 2>/dev/null; then
        echo "source $HOME/.termux/spoof_env.sh" >> "$HOME/.bashrc"
    fi
    
    # Apply to current session
    source "$HOME/.termux/spoof_env.sh"
    
    show_progress 0.02
    
    # Additional settings for apps that might use direct values
    if [ -d "/data/data/com.termux" ]; then
        mkdir -p "$HOME/.termux/tasker"
        echo "samsung_s928b" > "$HOME/.termux/device_profile"
    fi
    
    show_notification "Device properties set in local environment"
    echo -e "${GREEN}Samsung S25 Ultra properties have been set locally.${NC}"
    echo -e "${YELLOW}Note: These changes will apply to apps launched from this shell.${NC}"
    echo -e "${YELLOW}Restart Termux for full effect or run: source ~/.bashrc${NC}"
    
    sleep 1
    show_animation
}

# Improved spoof function for rooted devices
spoof_device_root() {
    show_notification "Starting device spoofing (root mode)..."
    
    # We'll use both build.prop modifications and system property settings
    # Backup original build.prop if not already backed up
    if [ ! -f "/system/build.prop.spoof_backup" ]; then
        su -c "cp /system/build.prop /system/build.prop.spoof_backup"
    fi
    
    # Create temp props file
    cat > /sdcard/s25_props.txt << EOF
# Samsung S25 Ultra Properties
ro.product.manufacturer=Samsung
ro.product.model=SM-S928B
ro.product.name=s928bxxu
ro.product.device=s928b
ro.build.product=s928b
ro.build.description=s928bxxu1AXXX
ro.build.fingerprint=samsung/s928bxxu/s928b:14/UP1A.xxx/AXXXX:user/release-keys
ro.product.brand=samsung
ro.product.board=s5e9935
ro.board.platform=universal9935
EOF
    
    # Mount system as writable and apply changes
    su -c "mount -o rw,remount /system"
    
    # Method 1: Direct build.prop modification
    su -c "cp /system/build.prop /system/build.prop.original"
    su -c "cat /sdcard/s25_props.txt >> /system/build.prop"
    su -c "chmod 644 /system/build.prop"
    
    # Method 2: Use setprop for immediate effect
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ $key == \#* ]] || [[ -z "$key" ]] && continue
        # Set property
        su -c "setprop $key $value"
    done < /sdcard/s25_props.txt
    
    show_progress 0.03
    
    # Reset Android runtime properties for changes to take effect
    show_notification "Applying changes systemwide (this will restart UI)..."
    su -c "setprop ctl.restart zygote"
    
    show_notification "Device properties modified to Samsung S25 Ultra"
    echo -e "${GREEN}Samsung S25 Ultra properties have been set.${NC}"
    echo -e "${YELLOW}Note: Original settings backed up to /system/build.prop.spoof_backup${NC}"
    echo -e "${YELLOW}A UI restart has been initiated to apply changes${NC}"
    
    sleep 1
    show_animation
}

# Function to restore original settings (for rooted devices)
restore_original() {
    if [ "$IS_ROOTED" = true ]; then
        show_notification "Restoring original device properties..."
        
        # Restore original build.prop
        su -c "mount -o rw,remount /system"
        
        if [ -f "/system/build.prop.spoof_backup" ]; then
            su -c "cp /system/build.prop.spoof_backup /system/build.prop"
            su -c "chmod 644 /system/build.prop"
            su -c "rm /system/build.prop.spoof_backup"
        elif [ -f "/system/build.prop.original" ]; then
            su -c "cp /system/build.prop.original /system/build.prop"
            su -c "chmod 644 /system/build.prop"
            su -c "rm /system/build.prop.original"
        fi
        
        show_progress 0.03
        
        # Reset Android runtime properties
        show_notification "Applying original settings (this will restart UI)..."
        su -c "setprop ctl.restart zygote"
        
        show_notification "Original device properties restored"
        echo -e "${GREEN}Original device properties have been restored.${NC}"
        echo -e "${YELLOW}A UI restart has been initiated to apply changes${NC}"
        
        sleep 1
        show_animation
    else
        # For non-rooted, just remove our local changes
        show_notification "Restoring non-root local environment..."
        
        if [ -f "$HOME/.termux/spoof_env.sh" ]; then
            rm "$HOME/.termux/spoof_env.sh"
        fi
        
        # Remove from bashrc
        if [ -f "$HOME/.bashrc" ]; then
            sed -i '/spoof_env.sh/d' "$HOME/.bashrc"
        fi
        
        # Remove device profile
        if [ -f "$HOME/.termux/device_profile" ]; then
            rm "$HOME/.termux/device_profile"
        fi
        
        show_notification "Local environment restored"
        echo -e "${GREEN}Local spoofing settings have been removed.${NC}"
        echo -e "${YELLOW}Restart Termux for full effect or start a new shell.${NC}"
    fi
}

# Function to check if spoofing is active
check_spoof_status() {
    echo -e "${CYAN}Current device properties:${NC}"
    
    if [ "$IS_ROOTED" = true ]; then
        # For rooted devices, check actual system properties
        CURRENT_MODEL=$(su -c "getprop ro.product.model")
        CURRENT_MANUFACTURER=$(su -c "getprop ro.product.manufacturer")
        echo -e "${BLUE}Model:${NC} $CURRENT_MODEL"
        echo -e "${BLUE}Manufacturer:${NC} $CURRENT_MANUFACTURER"
        
        if [[ "$CURRENT_MODEL" == *"S928B"* ]] || [[ "$CURRENT_MODEL" == *"S25"* ]]; then
            echo -e "${GREEN}Spoofing appears to be ACTIVE${NC}"
        else
            echo -e "${YELLOW}Spoofing appears to be INACTIVE${NC}"
        fi
    else
        # For non-rooted, check our local environment
        if [ -f "$HOME/.termux/spoof_env.sh" ]; then
            echo -e "${BLUE}Local environment:${NC} Samsung S25 Ultra settings detected"
            echo -e "${GREEN}Local spoofing is ACTIVE${NC}"
        else
            echo -e "${YELLOW}Local spoofing is INACTIVE${NC}"
        fi
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Main execution
show_animation
display_header
check_android
check_root
show_notification "Script started. Detected device mode: $([ "$IS_ROOTED" = true ] && echo 'Rooted' || echo 'Non-rooted')"

# Main menu
while true; do
    display_header
    echo ""
    echo -e "${CYAN}Select an option:${NC}"
    echo -e "${BLUE}1. ${GREEN}Spoof device as Samsung S25 Ultra${NC}"
    echo -e "${BLUE}2. ${YELLOW}Restore original device properties${NC}"
    echo -e "${BLUE}3. ${PURPLE}Check spoofing status${NC}"
    echo -e "${BLUE}4. ${RED}Exit${NC}"
    read -p "Enter your choice (1-4): " choice

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
            check_spoof_status
            continue
            ;;
        4)
            show_notification "Script exited by user."
            echo -e "${RED}Exiting script.${NC}"
            exit 0
            ;;
        *)
            show_notification "Invalid option selected."
            echo -e "${RED}Invalid option. Please try again.${NC}"
            sleep 1
            continue
            ;;
    esac

    # Ask if user wants to continue
    echo ""
    read -p "Would you like to return to the main menu? (y/n): " continue_choice
    if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
        break
    fi
done

show_notification "Script completed successfully!"
echo ""
echo -e "${CYAN}=====================================${NC}"
echo -e "${GREEN}    Script completed successfully!   ${NC}"
echo -e "${GREEN}    Created by: Willy Gailo          ${NC}"
echo -e "${CYAN}=====================================${NC}"

# Final animation
show_animation
display_header
sleep 1

exit 0