#!/usr/bin/env bash

# Function to add GPG key and repository
add_repo() {
    local key_url=$1
    local key_path=$2
    local repo_entry=$3
    local list_file=$4

    # Add GPG key if not already present
    if [[ ! -f "$key_path" ]]; then
        curl -fsSL "$key_url" | gpg --dearmor -o "$key_path"
    fi

    # Add repository if not already present
    if [[ ! -f "$list_file" ]]; then
        echo "$repo_entry" | tee "$list_file"
    fi
}

# Update and install required packages
apt-get update --yes && apt-get install --yes gpg

# Add Grafana repository and key
add_repo \
    "https://apt.grafana.com/gpg.key" \
    "/etc/apt/keyrings/grafana.gpg" \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
    "/etc/apt/sources.list.d/grafana.list"

# Add Docker repository and key
add_repo \
    "https://download.docker.com/linux/debian/gpg" \
    "/etc/apt/keyrings/docker.asc" \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    "/etc/apt/sources.list.d/docker.list"

# Update package lists
apt-get update --yes
