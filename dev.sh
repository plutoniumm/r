#!/bin/bash
function red(){
  echo "\033[0;31m$1\033[0m"
}
function green(){
  echo "\033[0;32m$1\033[0m"
}
function yellow(){
  echo "\033[0;33m$1\033[0m"
}
function blue(){
  echo "\033[0;34m$1\033[0m"
}
function purple(){
  echo "\033[0;35m$1\033[0m"
}
function cyan(){
  echo "\033[0;36m$1\033[0m"
}

# detect terminate
trap ctrl_c INT
function ctrl_c() {
  echo "$(red "\n\nTerminating dev server")"
  pkill -9 -f "r239" && wait
  exit 0
}

# fswatch to check for file changes
function watch() {
  pname="r239"
  # kill existing processes for good measure
  pkill -9 -f $pname && wait
  script="exec -a $pname $1"

  while true
  do
    bash -c "$script" &
    fswatch -1 .

    pkill -9 -f $pname && wait
    echo "Restarting $pname"
  done
}

# bash.v3 returns commands + flags
commands(){
  case $1 in
    "js") echo "npm run dev";;
    "go") echo "go run *.go";;
    "python") echo "python3";;
    "rust") echo "cargo run";;
    "c") echo "make run";;
    *) echo "unknown";;
  esac
}
# default args for where needed
args(){
  case $1 in
    "js") echo "";;
    "go") echo "";;
    "python") echo "server.py";;
    "rust") echo "";;
    "c") echo "";;
    *) echo "";;
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

lang=$(detect)
if [ "$lang" == "unknown" ]; then
  echo "Unknown language"
  exit 1
fi
cmd="$(commands $lang)"
if [ "$(args $lang)" != "" ]; then
  cmd="$cmd $(args $lang)"
fi
if [ "$1" != "" ]; then
  cmd="$cmd $@"
fi

echo "Starting dev server for $(blue $lang) at $(cyan "$(date)")"
echo "\tw $(green "$cmd")\n\t@$(yellow $PWD)"

# only, go, c, python need a watcher
# we also pass in all args as is
if [ "$lang" == "go" ] || [ "$lang" == "c" ] || [ "$lang" == "python" ]; then
  watch "$cmd"
else
  $cmd
fi