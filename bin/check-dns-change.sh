#!/bin/bash

# --- Variables --------------------------------------------
DELAY=60
LOOP=1
SILENT=0
BEEP=0
FQDN=
EXPECTED_RESULT=

# --- Function definitions --------------------------------------------

function help {
cat << EOF
check-dns-change [options] <FQDN> <expected result>

This script uses dig to lookup FQDN and checks n lines in answer section for expected result.

Parameters:
  <FQDN> - FQDN you want to check
  <expected result> - Regular expression used by grep to check for current entry.

Options:
  -d <default:60>  Seconds between each lookup.
  -h Print this help.
  -o Run this only once.
  -s Silent mode.
  -S Make five beep sounds when there is an expected match.
     Usefull when you run this in a background and want to be alerted.

EOF
}

function print_message {
    if [ $SILENT -eq 0 ] ; then
        echo $1
    fi
}

function make_beep {
    if [ $BEEP -eq 1 ] ; then
        for ii in 1 2 3 4 5 ; do
            echo -en "\007"
            sleep 1
        done
    fi
}

function check_dns {
    matched=$(dig $FQDN | grep -i "answer section" | grep -o $EXPECTED_RESULT)
    if [ ! -z $matched ] ; then
        print_message "Matched entry: $matched"
        make_beep
        exit 0
    fi
}

# --- Option processing --------------------------------------------

if [ $# == 0 ] ; then
    help
    exit 1;
fi

while getopts "d:hosS" optname
  do
    echo $optname
    case "$optname" in
      "d")
        DELAY=$OPTARG;
        ;;
      "h")
        help
        exit 0;
        ;;
      "o")
        LOOP=0;
        ;;
      "s")
        SILENT=1;
        ;;
      "S")
        BEEP=1;
        ;;
    esac
  done


shift $(($OPTIND - 1))

FQDN=$1
EXPECTED_RESULT=$2

# --- Script logic --------------------------------------------

check_dns

if [ $LOOP -eq 1 ] ; then
  print_message "Running in loop. Press CTRL+C to interrupt."
  while :
    do
      check_dns
      sleep $DELAY
    done
fi
