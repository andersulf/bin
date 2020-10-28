
# --- Variables ---------------------------------------
BINDIR="/usr/local/bin"
SHELLRC=".zshrc"

# --- Function definitions ----------------------------
function help {
cat << EOF
Setup of shell scripts and config files.

This script copies .zshrc to your home directory and everything
from ./bin folder to specified bin directory.

Options:
  -B <default:/usr/local/bin>  Directory that will hold executables.
  -h Print this help.
  -S <default:.zshrc>  Name of your shell run commands file.

EOF
}

function create_symlinks {
  # this will create symlinks in $BINDIR for all executables 
  # from ./bin so they can be called without extension
  for file_path in ./bin/* ; do
    fullname=$(basename -- $file_path)
    filename="${fullname%.*}"
    ln -sfn ${BINDIR}/${fullname} ${BINDIR}/${filename} 
  done
}

# --- Option processing -------------------------------
while getopts ":B:hS:" optname
  do
    case $optname in
      "B")
        BINDIR=$OPTARG
        ;;
      "h")
        help
        exit 0;
        ;;
      "S")
        SHELLRC=$OPTARG
        ;;
    esac
  done

cp ./home/.zshrc ~/${SHELLRC}

chmod -R +x ./bin
cp ./bin/* /usr/local/bin
create_symlinks
