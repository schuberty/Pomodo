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
update_pub() {
  flutter clean
  rm -f pubspec.lock
  flutter pub get
}

start_time=$(date +%s.%N)

cd "$PACKAGES_FOLDER/pomodo_commons"

update_pub
dart run slang

cd "$ROOT_FOLDER"

update_pub

end_time=$(date +%s.%N)

execution_time=$(echo "$end_time - $start_time" | bc)

printf "\n${GREEN}>>${RESET} Refresh PUB and BUILD script executed in ${WHITE}%.2f${RESET} seconds\n" "$execution_time"
