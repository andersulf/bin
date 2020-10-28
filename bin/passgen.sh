# --- Variables ---------------------------------------
CHARSET='A-Za-z0-9!"&()*+,-./:<=>?@[]^_`{|}'  # not exactly OWASP but at least it wont mess up with config files, just make sure it is long enough
LENGTH=30
RANDOMDEV=urandom

# --- Function definitions ----------------------------
function help {
cat << EOF
Generate random password using /dev/urandom.

Options:
  -A Use only alfanumeric characters.
  -c <default:30> Password length
  -h Print this help.
  -R Use /dev/random instead of /dev/urandom.

EOF
}

# --- Option processing -------------------------------
while getopts ":Ac:hR" optname
  do
    case $optname in 
      "A")
        CHARSET='A-Za-z0-9'
        ;;
      "c")
        LENGTH=$OPTARG
        ;;
      "h")
        help
        exit 0
        ;;
      "R")
        RANDOMDEV=random
        ;;
    esac
  done

LC_ALL=C tr -dc "${CHARSET}" </dev/${RANDOMDEV} | head -c $LENGTH
echo ""
