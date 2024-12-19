#!/bin/bash

# Script to analyze basic server performance stats

# Function to gather CPU usage
get_cpu_usage() {
    echo "==== CPU Usage ===="
    mpstat | awk '/all/ {printf "CPU Usage: %.2f%%\n", 100-$13}'
}

# Function to gather memory usage
get_memory_usage() {
    echo "==== Memory Usage ===="
    free -h | awk '/^Mem/ {print "Total: " $2, "| Used: " $3, "| Free: " $4}'
}

# Function to gather disk usage
get_disk_usage() {
    echo "==== Disk Usage ===="
    df -h --total | awk '/total/ {print "Total: " $2, "| Used: " $3, "| Available: " $4}'
}

# Function to gather network stats
get_network_stats() {
    echo "==== Network Stats ===="
    ip -s link | awk '/RX/ {getline; print "RX Bytes: "$1, "| TX Bytes: "$2}'
}

# Function to gather system load
get_system_load() {
    echo "==== System Load ===="
    uptime | awk -F'load average:' '{print "Load Average:" $2}'
}

# Main script execution
echo "Server Performance Stats"
echo "========================="
get_cpu_usage
get_memory_usage
get_disk_usage
get_network_stats
get_system_load

# Optionally, log the output to a file
echo "Do you want to save the output to a log file? (y/n)"
read save_log
if [ "$save_log" == "y" ]; then
    log_file="server_stats_$(date +%F_%T).log"
    echo "Saving to $log_file..."
    {
        get_cpu_usage
        get_memory_usage
        get_disk_usage
        get_network_stats
        get_system_load
    } > "$log_file"
    echo "Log saved to $log_file"
fi

