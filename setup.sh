#!/bin/bash               
#
# Program: Puppet Policy-based autosigning
# Author: scott
# Github: https://github.com/shazi7804

Welcome () {
  echo ""
  echo "Welcome to the autosign installation"
  echo ""
  echo "autosign installation infomation:"
  echo ""
  echo "prefix = $Autosign"
}

helpmsg() {
  echo ""
  echo "Usage: $0 [option]"
  echo ""
  echo "option:"
  echo "  install            Install autosign tools."
  echo ""
  echo "install perams:"
  echo "  --prefix=PATH     set installation prefix."
  echo "                    (default: $Autosign)"
  echo ""
}

setup_autosign() {
  test -d $Autosign || install -d -o $Puppet_USER -g $Puppet_GROUP -m 755 $Autosign
  
  $owner cp -R bin $Autosign/bin
  $owner cp -R config $Autosign/config

  # set prefix to config
  if [ -f $Autosign/config/autosign.conf ]; then
    Autosign_config="$Autosign/config/autosign.conf"
    echo "" >> $Autosign_config
    echo "# Autosign params" >> $Autosign_config
    echo "Autosign=$Autosign" >> $Autosign_config
    echo "Autosign_pks=$Autosign/pks" >> $Autosign_config
    echo "Autosign_confdir=$Autosign/config" >> $Autosign_config
    echo "Autosign_config=$Autosign_config" >> $Autosign_config
  else
    echo "Failed to write to the config file, check for \"$Autosign/config/autosign.conf\""
  fi

  # set verify tools for puppet master
  puppet config set --section master autosign $Autosign/bin/autosign-verify
  
  # verify puppet autosign finish
  if cat /etc/puppetlabs/puppet/puppet.conf | grep "$Autosign/bin/autosign-verify"; then
    echo ""
    echo "Installation successful !! You can enjoy the service."
  else
    echo ""
    echo "Installation failed."
  fi
}

# init setting
Install=0
Autosign="/opt/autosign"

if [ -f config/autosign.conf ]; then
  . config/autosign.conf
else
  echo "include \"config/autosign.conf\" not found."
  exit 1
fi

if [ $# -gt 0 ]; then
  for opt in $@
  do
    case $opt in
      install)
        shift
        Install=1
        ;;
      --prefix=*)
        shift
        Prefix="${opt#*=}"
        ;;
      -h|--help)
        helpmsg
        exit 1
        ;;
    esac
  done
else
  helpmsg
  exit 1
fi

if [ "1" = $Install ]; then
  if [ ! -z $Prefix ]; then
    Autosign=$Prefix
  fi

  if id $Puppet_USER &> /dev/null ; then
    owner="sudo -u $Puppet_USER"
  else
    echo "Did not find the \"puppet\" user, did not install puppet?"
    exit 1
  fi
    
  Welcome
  setup_autosign
fi
