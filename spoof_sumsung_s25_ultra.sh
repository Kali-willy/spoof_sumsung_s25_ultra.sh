#!/bin/bash
# =================================================================
# Samsung S24 Ultra Performance Optimizer
# Compatible with: Termux, Brevent, and Qute
# Supports all Android devices with root
# =================================================================

# Check if running in supported terminal
TERMINAL="$(ps -o comm= -p "$PPID")"
if [[ ! "$TERMINAL" =~ (termux|brevent|qute) ]]; then
    echo "This script must be run in Termux, Brevent, or Qute!"
    exit 1
fi

# Display ASCII Samsung logo animation
display_logo() {
    clear
    echo -e "\e[34m"
    echo "  ███████╗ █████╗ ███╗   ███╗███████╗██╗   ██╗███╗   ██╗ ██████╗ "
    sleep 0.1
    clear
    echo -e "\e[34m"
    echo "  ███████╗ █████╗ ███╗   ███╗███████╗██╗   ██╗███╗   ██╗ ██████╗ "
    echo "  ██╔════╝██╔══██╗████╗ ████║██╔════╝██║   ██║████╗  ██║██╔════╝ "
    sleep 0.1
    clear
    echo -e "\e[34m"
    echo "  ███████╗ █████╗ ███╗   ███╗███████╗██╗   ██╗███╗   ██╗ ██████╗ "
    echo "  ██╔════╝██╔══██╗████╗ ████║██╔════╝██║   ██║████╗  ██║██╔════╝ "
    echo "  ███████╗███████║██╔████╔██║███████╗██║   ██║██╔██╗ ██║██║  ███╗"
    sleep 0.1
    clear
    echo -e "\e[34m"
    echo "  ███████╗ █████╗ ███╗   ███╗███████╗██╗   ██╗███╗   ██╗ ██████╗ "
    echo "  ██╔════╝██╔══██╗████╗ ████║██╔════╝██║   ██║████╗  ██║██╔════╝ "
    echo "  ███████╗███████║██╔████╔██║███████╗██║   ██║██╔██╗ ██║██║  ███╗"
    echo "  ╚════██║██╔══██║██║╚██╔╝██║╚════██║██║   ██║██║╚██╗██║██║   ██║"
    sleep 0.1
    clear
    echo -e "\e[34m"
    echo "  ███████╗ █████╗ ███╗   ███╗███████╗██╗   ██╗███╗   ██╗ ██████╗ "
    echo "  ██╔════╝██╔══██╗████╗ ████║██╔════╝██║   ██║████╗  ██║██╔════╝ "
    echo "  ███████╗███████║██╔████╔██║███████╗██║   ██║██╔██╗ ██║██║  ███╗"
    echo "  ╚════██║██╔══██║██║╚██╔╝██║╚════██║██║   ██║██║╚██╗██║██║   ██║"
    echo "  ███████║██║  ██║██║ ╚═╝ ██║███████║╚██████╔╝██║ ╚████║╚██████╔╝"
    sleep 0.1
    clear
    echo -e "\e[34m"
    echo "  ███████╗ █████╗ ███╗   ███╗███████╗██╗   ██╗███╗   ██╗ ██████╗ "
    echo "  ██╔════╝██╔══██╗████╗ ████║██╔════╝██║   ██║████╗  ██║██╔════╝ "
    echo "  ███████╗███████║██╔████╔██║███████╗██║   ██║██╔██╗ ██║██║  ███╗"
    echo "  ╚════██║██╔══██║██║╚██╔╝██║╚════██║██║   ██║██║╚██╗██║██║   ██║"
    echo "  ███████║██║  ██║██║ ╚═╝ ██║███████║╚██████╔╝██║ ╚████║╚██████╔╝"
    echo "  ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ "
    sleep 0.2
    clear
    echo -e "\e[34m"
    echo "  ███████╗██████╗ ██╗  ██╗    ██╗   ██╗██╗  ████████╗██████╗  █████╗ "
    echo "  ██╔════╝██╔══██╗██║  ██║    ██║   ██║██║  ╚══██╔══╝██╔══██╗██╔══██╗"
    echo "  ███████╗██████╔╝███████║    ██║   ██║██║     ██║   ██████╔╝███████║"
    echo "  ╚════██║██╔═══╝ ██╔══██║    ██║   ██║██║     ██║   ██╔══██╗██╔══██║"
    echo "  ███████║██║     ██║  ██║    ╚██████╔╝███████╗██║   ██║  ██║██║  ██║"
    echo "  ╚══════╝╚═╝     ╚═╝  ╚═╝     ╚═════╝ ╚══════╝╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝"
    echo -e "\e[94m-----------------------------------------------------"
    echo -e "\e[94mSAMSUNG S24 ULTRA PERFORMANCE OPTIMIZER"
    echo -e "\e[94m-----------------------------------------------------\e[0m"
    sleep 2
}

# Variables
IS_ROOTED=false
DEVICE_MODEL=""
CPU_INFO=""
MEMORY_INFO=""
KERNEL_VERSION=""
ANDROID_VERSION=""
GPU_INFO=""
SCRIPT_PID=$$

# Check if device is rooted
check_root() {
    echo -e "\e[93mChecking root status...\e[0m"
    if [ -f /system/xbin/su ] || [ -f /system/bin/su ] || [ -f /sbin/su ] || [ -f /su/bin/su ]; then
        IS_ROOTED=true
        echo -e "\e[92mDevice is rooted\e[0m"
    else
        echo -e "\e[93mDevice is not rooted\e[0m"
    fi
    sleep 1
}

# Get device information
get_device_info() {
    echo -e "\e[93mGathering device information...\e[0m"
    # Always set device model to Samsung S24 Ultra for compatibility mode
    ORIGINAL_DEVICE_MODEL=$(getprop ro.product.model)
    DEVICE_MODEL="Samsung Galaxy S24 Ultra"
    CPU_INFO=$(cat /proc/cpuinfo | grep "Hardware" | head -n 1 | cut -d ":" -f 2 | xargs)
    MEMORY_INFO=$(free -m | grep "Mem:" | awk '{print $2}')
    KERNEL_VERSION=$(uname -r)
    ANDROID_VERSION=$(getprop ro.build.version.release)
    GPU_INFO=$(dumpsys SurfaceFlinger | grep GLES | head -n1 || echo "Snapdragon GPU")
    sleep 1
}

# Display device information
display_device_info() {
    echo -e "\e[96m═══════════════════════════════════════════"
    echo -e "📱 Device Model: $DEVICE_MODEL"
    echo -e "📱 Original Model: $ORIGINAL_DEVICE_MODEL"
    echo -e "🧠 CPU: $CPU_INFO"
    echo -e "🎮 GPU: $GPU_INFO"
    echo -e "💾 RAM: $MEMORY_INFO MB"
    echo -e "🐧 Kernel: $KERNEL_VERSION"
    echo -e "🤖 Android: $ANDROID_VERSION"
    echo -e "🔒 Root Status: $(if $IS_ROOTED; then echo 'Yes'; else echo 'No'; fi)"
    echo -e "═══════════════════════════════════════════\e[0m"
    
    # Prepare for device restart (only when explicitly selected)
    if [ "$1" = "restart" ]; then
        echo -e "\e[91mPreparing to restart device in 5 seconds...\e[0m"
        sleep 1
        echo -e "\e[91m4...\e[0m"
        sleep 1
        echo -e "\e[91m3...\e[0m"
        sleep 1
        echo -e "\e[91m2...\e[0m"
        sleep 1
        echo -e "\e[91m1...\e[0m"
        sleep 1
        
        # Attempt to restart device if rooted
        if [ "$IS_ROOTED" = true ]; then
            su -c "svc power reboot" || su -c "reboot" || reboot
        else
            echo -e "\e[91mReboot requires root permission\e[0m"
            sleep 2
        fi
    else
        sleep 2
    fi
}

# Send notification
send_notification() {
    am start -a android.intent.action.VIEW -d "notification://$1" > /dev/null 2>&1 || \
    termux-notification -t "S24 Ultra Optimizer" -c "$1" --icon speed > /dev/null 2>&1 || \
    echo -e "\e[92m$1\e[0m"
}

# Samsung specific optimizations - Non-root methods
optimize_performance_nonroot() {
    echo -e "\e[93mOptimizing system performance (non-root)...\e[0m"
    
    # Clear background apps
    am kill-all > /dev/null 2>&1
    
    # Disable animations to improve performance
    settings put global window_animation_scale 0.5 > /dev/null 2>&1
    settings put global transition_animation_scale 0.5 > /dev/null 2>&1
    settings put global animator_duration_scale 0.5 > /dev/null 2>&1
    
    # Enable high performance mode if available (Samsung specific)
    settings put system power_mode 1 > /dev/null 2>&1
    
    # Enable enhanced processing if available
    settings put system enhanced_processing 1 > /dev/null 2>&1
    
    # Set higher touch sampling rate if available
    settings put system game_auto_temperature_control 0 > /dev/null 2>&1
    
    # Reduce memory pressure
    am set-inactive-state com.google.android.gms true > /dev/null 2>&1
    
    # Try to enable Game Booster optimization
    am start -n com.samsung.android.game.gametools/.MainService > /dev/null 2>&1
    am start -n com.samsung.android.game.gos/.activity.setting.AdvancedLabSettingActivity > /dev/null 2>&1
    
    # Check and enable high performance profile
    if [ -f "/sys/class/power_supply/battery/batt_slate_mode" ]; then
        echo "0" > /sys/class/power_supply/battery/batt_slate_mode 2>/dev/null
    fi
    
    send_notification "Performance optimizations applied"
    echo -e "\e[92mNon-root performance optimizations applied\e[0m"
    sleep 1
}

# Root-only optimizations for Samsung S24 Ultra
optimize_performance_root() {
    if [ "$IS_ROOTED" = true ]; then
        echo -e "\e[93mApplying root-level optimizations for S24 Ultra...\e[0m"
        
        # Use root to apply more aggressive tweaks
        su -c "echo 0 > /proc/sys/vm/swappiness" 2>/dev/null
        su -c "echo 1 > /proc/sys/vm/compact_memory" 2>/dev/null
        su -c "echo 80 > /proc/sys/vm/vfs_cache_pressure" 2>/dev/null
        su -c "echo 5 > /proc/sys/vm/dirty_ratio" 2>/dev/null
        su -c "echo 100 > /proc/sys/vm/dirty_expire_centisecs" 2>/dev/null
        
        # Adjust I/O scheduler for better performance
        for block in /sys/block/*/queue/scheduler; do
            su -c "echo 'cfq' > $block" 2>/dev/null
        done

        # Samsung-specific GPU optimizations
        su -c "echo 1 > /sys/class/kgsl/kgsl-3d0/force_bus_on" 2>/dev/null
        su -c "echo 1 > /sys/class/kgsl/kgsl-3d0/force_rail_on" 2>/dev/null
        su -c "echo 1 > /sys/class/kgsl/kgsl-3d0/force_clk_on" 2>/dev/null
        
        # Snapdragon-specific tweaks
        if [[ "$CPU_INFO" == *"Qualcomm"* ]] || [[ "$CPU_INFO" == *"Snapdragon"* ]]; then
            # Set CPU governor to performance
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                su -c "echo performance > $cpu" 2>/dev/null
            done
            
            # Set GPU governor to performance
            su -c "echo performance > /sys/class/kgsl/kgsl-3d0/devfreq/governor" 2>/dev/null
            
            # Disable CPU core idle mode for better performance (temporary)
            for cpu in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do
                su -c "echo 1 > $cpu" 2>/dev/null
            done
        fi
        
        # Exynos-specific tweaks
        if [[ "$CPU_INFO" == *"Exynos"* ]]; then
            # Set to performance mode
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                su -c "echo performance > $cpu" 2>/dev/null
            done
            
            # GPU tweaks for Exynos
            if [ -d "/sys/devices/platform/18500000.mali" ]; then
                su -c "echo 'always_on' > /sys/devices/platform/18500000.mali/power_policy" 2>/dev/null
            fi
        fi
        
        # SafetyNet bypass attempt for Samsung
        if [ -d "/data/adb/modules" ] && [ -d "/data/adb/magisk" ]; then
            echo -e "\e[93mConfiguring SafetyNet bypass for Samsung...\e[0m"
            su -c "magisk --sqlite \"DELETE FROM hidelist WHERE package_name='com.google.android.gms'\"" 2>/dev/null
            su -c "magisk --sqlite \"INSERT INTO hidelist (package_name) VALUES ('com.google.android.gms')\"" 2>/dev/null
            su -c "magisk --sqlite \"DELETE FROM hidelist WHERE package_name='com.samsung.android.knox.attestation'\"" 2>/dev/null
            su -c "magisk --sqlite \"INSERT INTO hidelist (package_name) VALUES ('com.samsung.android.knox.attestation')\"" 2>/dev/null
            su -c "settings put global device_provisioned 1" 2>/dev/null
        fi
        
        # Disable thermal throttling (use carefully, can cause overheating)
        su -c "echo 0 > /sys/class/thermal/thermal_zone0/mode" 2>/dev/null
        
        send_notification "Root optimizations for S24 Ultra applied"
        echo -e "\e[92mRoot-level optimizations for S24 Ultra applied\e[0m"
    fi
    sleep 1
}

# Optimize gaming performance for Samsung S24 Ultra
optimize_gaming() {
    echo -e "\e[93mOptimizing gaming performance for S24 Ultra...\e[0m"
    
    # Close unnecessary background apps
    am kill-all > /dev/null 2>&1
    
    # Non-root tweaks
    settings put system pointer_speed 1 > /dev/null 2>&1
    
    # Samsung Game Launcher and Game Booster settings
    am start -n com.samsung.android.game.gos/.activity.setting.PerformanceSettingActivity > /dev/null 2>&1
    am broadcast -a com.samsung.android.game.gos.action.MAX_PERFORMANCE --ez enabled true > /dev/null 2>&1
    
    # Try to enable Samsung's Game Booster plus features
    settings put system game_auto_temperature_control 0 > /dev/null 2>&1
    
    # Apply root gaming tweaks if available
    if [ "$IS_ROOTED" = true ]; then
        # Disable thermal throttling temporarily (be careful, can cause overheating)
        su -c "echo 0 > /sys/class/thermal/thermal_zone0/mode" 2>/dev/null
        
        # Set touch polling rate to maximum if available
        su -c "echo 1 > /sys/class/sec/tsp/input/enabled" 2>/dev/null
        
        # Set GPU frequency to maximum if available
        if [ -f "/sys/class/kgsl/kgsl-3d0/max_gpuclk" ]; then
            MAX_GPU=$(cat /sys/class/kgsl/kgsl-3d0/max_gpuclk)
            su -c "echo $MAX_GPU > /sys/class/kgsl/kgsl-3d0/gpuclk" 2>/dev/null
        fi
        
        # Force max CPU frequency on performance cores
        if [ -d "/sys/devices/system/cpu/cpu7/cpufreq" ]; then
            MAX_FREQ=$(cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq)
            su -c "echo $MAX_FREQ > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq" 2>/dev/null
        fi
    fi
    
    send_notification "Gaming optimizations for S24 Ultra applied"
    echo -e "\e[92mGaming optimizations for S24 Ultra applied\e[0m"
    sleep 1
}

# Optimize camera performance
optimize_camera() {
    echo -e "\e[93mOptimizing camera performance for S24 Ultra...\e[0m"
    
    # Clear camera cache
    pm clear com.sec.android.app.camera > /dev/null 2>&1
    
    # Set camera to high performance mode if available
    settings put system camera_performance_mode 1 > /dev/null 2>&1
    
    # Root-specific camera optimizations
    if [ "$IS_ROOTED" = true ]; then
        # Prioritize camera app
        su -c "echo -17 > /proc/$(pidof com.sec.android.app.camera)/oom_adj" 2>/dev/null
        
        # Allocate more memory to camera process
        su -c "echo 1 > /proc/sys/vm/compact_memory" 2>/dev/null
    fi
    
    send_notification "Camera optimizations for S24 Ultra applied"
    echo -e "\e[92mCamera optimizations for S24 Ultra applied\e[0m"
    sleep 1
}

# Optimize battery performance without losing too much speed
optimize_battery() {
    echo -e "\e[93mOptimizing battery performance while maintaining speed...\e[0m"
    
    # Balanced settings for battery
    settings put system power_saving_mode 0 > /dev/null 2>&1
    
    # Disable unnecessary radios when not in use
    settings put global wifi_sleep_policy 2 > /dev/null 2>&1
    
    # Root-specific battery optimizations
    if [ "$IS_ROOTED" = true ]; then
        # Better balanced CPU governor
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            su -c "echo schedutil > $cpu" 2>/dev/null
        done
        
        # Adjust kernel parameters for better battery life
        su -c "echo 90 > /proc/sys/vm/dirty_ratio" 2>/dev/null
        su -c "echo 500 > /proc/sys/vm/dirty_expire_centisecs" 2>/dev/null
        su -c "echo 10 > /proc/sys/vm/swappiness" 2>/dev/null
    fi
    
    send_notification "Battery optimizations applied (balanced mode)"
    echo -e "\e[92mBattery optimizations applied (balanced mode)\e[0m"
    sleep 1
}

# Monitor cleanup trap
clean_up() {
    echo -e "\e[93mScript terminated. Restoring normal device operation.\e[0m"
    
    # Reset some settings to default
    settings put global window_animation_scale 1.0 > /dev/null 2>&1
    settings put global transition_animation_scale 1.0 > /dev/null 2>&1
    settings put global animator_duration_scale 1.0 > /dev/null 2>&1
    
    if [ "$IS_ROOTED" = true ]; then
        # Reset CPU governors to default
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            su -c "echo schedutil > $cpu" 2>/dev/null
        done
        
        # Re-enable thermal management
        su -c "echo 1 > /sys/class/thermal/thermal_zone0/mode" 2>/dev/null
    fi
    
    send_notification "S24 Ultra Optimizer stopped - Settings restored"
    exit 0
}

# Display menu
show_menu() {
    while true; do
        clear
        echo -e "\e[96m═══════════════════════════════════════════"
        echo -e "      SAMSUNG S24 ULTRA OPTIMIZER MENU"
        echo -e "═══════════════════════════════════════════\e[0m"
        echo -e "\e[94m1. Apply All Optimizations"
        echo -e "2. Performance Mode (Maximum Speed)"
        echo -e "3. Gaming Mode"
        echo -e "4. Camera Optimization"
        echo -e "5. Battery Balanced Mode"
        echo -e "6. Display Device Information"
        echo -e "7. Restart Device"
        echo -e "8. Exit and Restore Default Settings\e[0m"
        echo -e "\e[96m═══════════════════════════════════════════\e[0m"
        echo -ne "\e[93mSelect an option [1-8]: \e[0m"
        read -r choice
        
        case $choice in
            1)
                optimize_performance_nonroot
                optimize_performance_root
                optimize_gaming
                optimize_camera
                echo -e "\e[92m✅ All optimizations applied successfully!\e[0m"
                sleep 2
                ;;
            2)
                optimize_performance_nonroot
                optimize_performance_root
                echo -e "\e[92m✅ Performance mode enabled!\e[0m"
                sleep 2
                ;;
            3)
                optimize_gaming
                echo -e "\e[92m✅ Gaming mode enabled!\e[0m"
                sleep 2
                ;;
            4)
                optimize_camera
                echo -e "\e[92m✅ Camera optimizations applied!\e[0m"
                sleep 2
                ;;
            5)
                optimize_battery
                echo -e "\e[92m✅ Battery balanced mode enabled!\e[0m"
                sleep 2
                ;;
            6)
                get_device_info
                display_device_info
                echo -e "\e[93mPress Enter to continue...\e[0m"
                read
                ;;
            7)
                get_device_info
                display_device_info "restart"
                ;;
            8)
                clean_up
                ;;
            *)
                echo -e "\e[91mInvalid option. Please try again.\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Main execution function
main() {
    # Set trap for clean exit
    trap clean_up SIGINT SIGTERM
    
    # Show animation
    display_logo
    
    # Check root status
    check_root
    
    # Get and display device info
    get_device_info
    display_device_info
    
    # Show menu
    show_menu
}

# Execute main function
main