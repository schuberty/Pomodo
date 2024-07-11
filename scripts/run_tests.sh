#!/bin/bash

# Function to display help menu
show_help() {
  echo "Usage: $0 <command> [options]"
  echo
  echo "Commands:"
  echo "  unit               Runs only unit tests"
  echo "  integration        Runs integration tests with API key"
  echo "  all                Runs both unit and integration tests"
  echo
  echo "Options:"
  echo "  --todoist-key <key>  Specify the API key for integration tests (required for integration and all tests)"
  echo
  echo "Examples:"
  echo "  $0 unit"
  echo "  $0 integration --todoist-key YOUR_API_KEY"
  echo "  $0 all --todoist-key YOUR_API_KEY"
}

# Function to run unit tests
run_unit_tests() {
  echo "Running unit tests..."

  flutter test -r compact -j 2 --tags "unit" --coverage
}

# Function to run integration tests
run_integration_tests() {
  local api_key="$1"

  if [ -z "$api_key" ]; then
    echo "The API key in --todoist-key option is required for integration tests."
    exit 1
  fi

  echo "Running integration tests..."

  flutter test -r compact -j 1 --dart-define TODOIST_API_TEST_TOKEN="$api_key" --tags integration
}

# Function to run both unit and integration tests
run_all_tests() {
  local api_key="$1"

  if [ -z "$api_key" ]; then
    echo "The API key in --todoist-key option is required for integration tests."
    exit 1
  fi

  echo "Running both unit and integration tests..."

  flutter test -r compact -j 1 --dart-define TODOIST_API_TEST_TOKEN="$api_key" --tags "unit || integration"
}

# Function to parse command line arguments
parse_args() {
  api_key=""
  while [[ "$#" -gt 0 ]]; do
    case $1 in
    --todoist-key)
      if [ -n "$2" ]; then
        api_key="$2"
        shift 2
      else
        echo "Option --todoist-key requires a value."
        exit 1
      fi
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
    esac
  done
  echo "$api_key"
}

# Main execution logic
main() {
  if [ $# -eq 0 ]; then
    show_help
    exit 1
  fi

  command="$1"
  shift

  case "$command" in
  unit)
    run_unit_tests
    ;;
  integration)
    api_key=$(parse_args "$@")
    run_integration_tests "$api_key"
    ;;
  all)
    api_key=$(parse_args "$@")
    run_all_tests "$api_key"
    ;;
  *)
    echo "Unknown command: $command"
    show_help
    exit 1
    ;;
  esac
}

# Start execution
main "$@"
