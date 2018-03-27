#! /bin/bash
#
# this script is intended to run within a docker container.
#
# It requires:
#  * an interactive terminal to read user options at runtime
#  * ncftp, a fancy ftp client
#  * ncurses for colored output
#
# the following three parameters
#
# $1 SITE (e.g. aim42.org)
# $2 SERVER, e.g. xy.webpack.hosteurope.de
# $3 localdir, the local directory which shall be uploaded to SERVER
# $4 REMOTEDIR, directory on remote SERVER


# some colors to highlight certain output
GREEN=`tput setaf 2`
RED=`tput setaf 5`
BLUE=`tput setaf 6`
RESET=`tput sgr0`

# show given parameters
# =====================
echo "called with parameters: $@"


# check input params
# ==================

if [ $# -lt 4 ]
  then
  echo "too few arguments given, expect SITE, SERVER, LOCALDIR and REMOTEDIR (in that order)"
  exit 1
fi

if [ $# -gt 4 ]
  then
  echo "too many arguments given, expect SITE, SERVER, LOCALDIR and REMOTEDIR (in that order)"
  exit 1
fi


if [ $# -eq 4 ]
  then
    SITE=$1      # i.e. aim42.org
    SERVER=$2    # i.e. wp290.webpack.hosteurope.de
    localdir=$3  # i.e. zz-production-site
    REMOTEDIR=$4 # i.e. .
fi


##
## utility functions
##

function upload_to_production {
  echo "I need the ${GREEN} ftp credentials ${RESET} to authenticate at ${SERVER}."
  read -p "Enter ftp ${RED}username ${RESET} for ${SITE}: " username

  # check if credentials are plausible - assumption: empty strings are not allowed
  if [[ -z $username ]] ; then
    echo "empty username won't work. Aborted!"
    exit 1
  fi

  read -p "Enter ${RED}password ${RESET} for ${username}: " password

  if [[ -z $password ]] ; then
    echo "empty password won't work. Aborted!"
    exit 1
  fi


  echo "Thanx. Now using ${RED} $username:$password ${RESET}to authenticate at $SERVER."
  echo


  # ncftp is a fancy (and free) ftp program that allows for recursive put operation
  # see https://www.ncftp.com/ncftp/doc/ncftpput.html
  #
  # Example:
  # ncftpput -R -v -u "username" -p "passwordHere" <remote-server> <remote-dir> <local-dir>
  #
  # where:
  # -u username
  # -p password
  # -R recursive
  # <remote-server> : Remote ftp server (use FQDN or IP).
  # <remote-dir> : Remote ftp server directory where all files and subdirectories will be uploaded.
  # <local-dir> : Local directory (or list of files) to upload remote ftp server directory

  echo "using the following commands to upload: $BLUE"
  echo cd $localdir
  echo ncftpput -R -v -u $username -p $password $SERVER $REMOTEDIR .
  echo $RESET

  cd $localdir
  ncftpput -R -v -u $username -p $password $SERVER $REMOTEDIR .
  echo "...done"

}

##
## main
##

echo
echo "Docker container to upload your (generated) website:"
echo "===================================================="
echo "You want to upload to ${BLUE}$SITE ${RESET},"
echo "residing on server ${BLUE}$SERVER ${RESET}"
echo "uploading files from directory ${BLUE}$localdir ${RESET}"
echo "Please select:"
echo
echo "${RED}(u)upload ${RESET} uploads $localdir to ${BLUE} $SERVER/$REMOTEDIR ${RESET}."
echo "${BLUE}(q)uit ${RESET} quit..."
echo "====================================================="
echo

read -p "Enter your selection (default: quit, q) : " choice


if [[ -z $choice ]]; then
    choice='quit'
fi

case "$choice" in
  u|U|upload)  echo "upload to server"
                   upload_to_production
                   ;;

  q|Q|quit)        echo "quit"
                   exit 1
                   ;;
  # catchall: abort
  *)               echo "${RED} unknown option $choice ${RESET}, aborted."
                   exit 1
                   ;;
esac
