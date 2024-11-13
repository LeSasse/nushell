# Manage venv python virtual environments in nushell.
def "venv" [] {}

def "venv create" [name: string] {
  python3 -m venv $name
  venv activate $name
}

# Source a python venv and invoke a nu subshell.
def "venv activate" [
  path: string # Path to the virtual environment (not the activation script).
] {
  sh -i -c $'source ($path)/bin/activate ; nu'
}

# Deactivate the current venv by exiting the subshell.
def "venv deactivate" [] {
  exit
}

# Show the name of the current venv.
#
# This very crudely takes the third last element of the `which python` path.
def "venv current" [] {
  let pyenv_path = which python | get path.0 | path split | reverse
  if (($pyenv_path | length) >= 3) {
    echo $pyenv_path | get 2
  } else {
    echo "base"
  }
}
