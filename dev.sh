#!/bin/bash

# usage: $(col "red" "hello world")
function col(){
  case $1 in
    "red") echo "\033[0;31m$2\033[0m";;
    "green") echo "\033[0;32m$2\033[0m";;
    "yellow") echo "\033[0;33m$2\033[0m";;
    "blue") echo "\033[0;34m$2\033[0m";;
    "purple") echo "\033[0;35m$2\033[0m";;
    "cyan") echo "\033[0;36m$2\033[0m";;
    "white") echo "\033[0;37m$2\033[0m";;
    *) echo "$2";;
  esac
}


# This script is used to run the development server by auto detecting the
# language of proj and using the appropriate development server.

# fswatch to check for file changes
function watch(){
  fswatch -o $1 | xargs -n1 -I{} $2
}

# bash.v3 returns commands + flags
commands(){
  case $1 in
    "js") echo "npm run dev";;
    "go") echo "go run main.go";;
    "python") echo "python3 main.py";;
    "rust") echo "cargo run";;
    "c") echo "make run";;
    *) echo "unknown";;
  esac
}


# Detection order: js, go, python, rust, c
function detect(){
  if [ -f "package.json" ]; then
    echo "js"
  elif [ -f "go.mod" ]; then
    echo "go"
  elif [ -f "requirements.txt" ]; then
    echo "python"
  elif [ -f "Cargo.toml" ]; then
    echo "rust"
  elif [ -f "Makefile" ]; then
    echo "c"
  else
    echo "unknown"
  fi
}

function main(){
  lang=$(detect)
  if [ "$lang" == "unknown" ]; then
    echo "Unknown language"
    exit 1
  fi
  cmd=$(commands $lang)
  echo "Starting dev server for $(col "blue" $lang) at $(col "cyan" "$(date)")"
  echo "\tw $(col "green" "$cmd")\n\t@$(col "yellow" $PWD)"

  # only, go, c, python need a watcher
  if [ "$lang" == "go" ] || [ "$lang" == "c" ] || [ "$lang" == "python" ]; then
    watch . $cmd
  else
    $cmd
  fi
}

main