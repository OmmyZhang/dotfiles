#!/bin/bash

# Arrays for mapping and caching
declare -A window_map
declare -A icon_cache
declare -a wofi_input

# Common directories where apps hide their icons (defined ONCE outside the loop)
dirs=(
    "/usr/share/icons/hicolor/scalable/apps"
    "/usr/share/icons/hicolor/256x256/apps"
    "/usr/share/icons/hicolor/128x128/apps"
    "/usr/share/icons/hicolor/48x48/apps"
    "/usr/share/pixmaps"
    "$HOME/.local/share/icons/hicolor/scalable/apps"
)

zwsp=$'\u200B'
index=1

while read -r window; do
    class=$(echo "$window" | jq -r '.class')
    title=$(echo "$window" | jq -r '.title')
    address=$(echo "$window" | jq -r '.address')

    class_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')
    icon=""

    # 1. Check if we already searched for this class's icon
    # We check if the key exists in the cache, even if the value is empty (meaning no icon was found last time)
    if [[ -v icon_cache["$class_lower"] ]]; then
        icon="${icon_cache[$class_lower]}"
    else
        # 2. If not in cache, search the disk
        for dir in "${dirs[@]}"; do
            if [[ -f "$dir/$class_lower.svg" ]]; then icon="$dir/$class_lower.svg"; break; fi
            if [[ -f "$dir/$class_lower.png" ]]; then icon="$dir/$class_lower.png"; break; fi
            if [[ -f "$dir/$class.svg" ]]; then icon="$dir/$class.svg"; break; fi
            if [[ -f "$dir/$class.png" ]]; then icon="$dir/$class.png"; break; fi
        done
        
        # 3. Save the result to the cache for the next window
        icon_cache["$class_lower"]="$icon"
    fi

    # Generate a unique string of invisible characters based on the current index
    hidden_id=""
    for ((i=0; i<index; i++)); do
        hidden_id+="$zwsp"
    done

    # Build the exact line Wofi will display
    if [[ -n "$icon" ]]; then
        entry="img:${icon}:text: ${title}${hidden_id}"
    else
        entry="text:[${class}] ${title}${hidden_id}"
    fi

    # Save the mapping: Invisible String -> Real Address
    window_map["$entry"]="$address"
    
    # Add to our Wofi input array
    wofi_input+=("$entry")
    
    ((index++))
done < <(hyprctl clients -j | jq -c '.[]')

# Feed the array into Wofi
selected=$(printf "%s\n" "${wofi_input[@]}" | wofi --dmenu --allow-images)

# Exit cleanly on Escape
if [[ -z "$selected" ]]; then
    exit 0
fi

# Retrieve the address and dispatch
target_address="${window_map[$selected]}"

if [[ -n "$target_address" ]]; then
    hyprctl dispatch focuswindow address:"$target_address"
fi
