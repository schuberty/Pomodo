#!/bin/bash

# Set locale to use dot as decimal separator
LC_NUMERIC=C

# Get the root folder of the project
ROOT_FOLDER=$(git rev-parse --show-toplevel)
PACKAGES_FOLDER="$ROOT_FOLDER/packages"

# Colors
GREEN="\033[32m"
WHITE="\033[1m"
RESET="\033[0m"

# Remove the pubspec lock and run pub get
upgrade_dependencies() {
  flutter pub upgrade --tighten --major-versions
}

start_time=$(date +%s.%N)

cd "$PACKAGES_FOLDER/pomodo_commons"

upgrade_dependencies

cd "$ROOT_FOLDER"

upgrade_dependencies

end_time=$(date +%s.%N)

execution_time=$(echo "$end_time - $start_time" | bc)

printf "\n${GREEN}>>${RESET} Upgraded dependencies versions, script executed in ${WHITE}%.2f${RESET} seconds\n" "$execution_time"
