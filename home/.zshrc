# Aliases
alias gcp-console='docker run -ti --name gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk'
alias ll='ls -laG'

# Docker
function docker() {
    case $1 in
        kill)
            if [[ $2 == "all" ]] ; then
            echo "Killing all running containers."
                command docker kill $(command docker ps | grep -o -e "[a-z0-9]*_[a-z0-9]*")
            else
                shift 1
                echo not
                echo $@
                command docker kill "$@"
            fi
            ;;
        *)
            command docker "$@"
            ;;
    esac
}

# GCP SDK setup
# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/opt/google-cloud-sdk/path.zsh.inc' ]; then . '~/opt/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '~/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '~/opt/google-cloud-sdk/completion.zsh.inc'; fi


