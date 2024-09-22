#!/bin/bash

CONFIG_FILE="config.yaml"

# Funktion, um Umgebungen aus der YAML-Datei zu lesen
function get_environments() {
    yq eval '.environments[].name' "$CONFIG_FILE"
}

# Hauptmenü anzeigen
function main_menu() {
    clear
    echo "Question: Which environment"
    echo

    mapfile -t envs < <(get_environments)
    for i in "${!envs[@]}"; do
        echo "$((i+1)). ${envs[$i]}"
    done
    echo
    read -p "Enter the number of the desired environment (1-${#envs[@]}): " choice

    if [[ $choice -ge 1 && $choice -le ${#envs[@]} ]]; then
        selected_environment="${envs[$((choice-1))]}"
        handle_environment_selection "$selected_environment"
    else
        echo "Invalid selection, please try again."
        sleep 2
        main_menu
    fi
}

# Umgebung verarbeiten
function handle_environment_selection() {
    local env_name="$1"
    requires_zone=$(yq eval ".environments[] | select(.name == \"$env_name\") | .requires_zone" "$CONFIG_FILE")
    requires_specific_env=$(yq eval ".environments[] | select(.name == \"$env_name\") | .requires_specific_env" "$CONFIG_FILE")

    if [[ $requires_zone == "true" ]]; then
        select_zone "$env_name"
    fi

    if [[ $requires_specific_env == "true" ]]; then
        select_specific_environment
    fi

    select_tool
    create_directory
}

# Netzwerkzone auswählen
function select_zone() {
    local env_name="$1"
    clear
    echo "Question: Which network zone"
    echo

    mapfile -t zones < <(yq eval ".environments[] | select(.name == \"$env_name\") | .zones[]" "$CONFIG_FILE")
    for i in "${!zones[@]}"; do
        echo "$((i+1)). ${zones[$i]}"
    done
    echo
    read -p "Enter the number of the desired network zone (1-${#zones[@]}): " zone_choice

    if [[ $zone_choice -ge 1 && $zone_choice -le ${#zones[@]} ]]; then
        selected_zone="${zones[$((zone_choice-1))]}"
    else
        echo "Invalid selection, please try again."
        sleep 2
        select_zone "$env_name"
    fi
}

# Spezifische Umgebung auswählen
function select_specific_environment() {
    clear
    echo "Which specific environment"
    echo

    mapfile -t specific_envs < <(yq eval '.specific_environments[]' "$CONFIG_FILE")
    for i in "${!specific_envs[@]}"; do
        echo "$((i+1)). ${specific_envs[$i]}"
    done
    echo
    read -p "Enter the number of the desired specific environment (1-${#specific_envs[@]}): " env_choice

    if [[ $env_choice -ge 1 && $env_choice -le ${#specific_envs[@]} ]]; then
        selected_specific_environment="${specific_envs[$((env_choice-1))]}"
    else
        echo "Invalid selection, please try again."
        sleep 2
        select_specific_environment
    fi
}

# Tool auswählen
function select_tool() {
    clear
    echo "Which tool"
    echo

    mapfile -t tools < <(yq eval '.tools[]' "$CONFIG_FILE")
    for i in "${!tools[@]}"; do
        echo "$((i+1)). ${tools[$i]}"
    done
    echo
    read -p "Enter the number of the desired tool (1-${#tools[@]}): " tool_choice

    if [[ $tool_choice -ge 1 && $tool_choice -le ${#tools[@]} ]]; then
        selected_tool="${tools[$((tool_choice-1))]}"
    else
        echo "Invalid selection, please try again."
        sleep 2
        select_tool
    fi
}

# Verzeichnis erstellen
function create_directory() {
    dir_path="./"

    # Füge die spezifische Umgebung hinzu, falls vorhanden
    if [[ -n $selected_specific_environment ]]; then
        dir_path+="$selected_specific_environment/"
    fi

    dir_path+="${selected_environment,,}/"

    # Spezifische Pfaderstellung für RUNTIME
    if [[ $selected_environment == "RUNTIME" ]]; then
        dir_path+="${selected_specific_environment}_${selected_zone,,}_01/"
    fi

    # Spezifische Pfaderstellung für SERVICE
    if [[ $selected_environment == "SERVICE" ]]; then
        dir_path+="devops_${selected_specific_environment,,}_01/"
    fi

    dir_path+="$selected_tool/"

    mkdir -p "$dir_path"

    echo "The directory '$dir_path' has been created."

    # Variablen zurücksetzen
    unset selected_environment
    unset selected_zone
    unset selected_specific_environment
    unset selected_tool

    # Erneute Erstellung abfragen
    read -p "Do you want to create another directory? (y/n): " repeat_choice
    case $repeat_choice in
        y|Y) main_menu ;;
        *) echo "Program terminated." ;;
    esac
}

# Skript starten
main_menu
