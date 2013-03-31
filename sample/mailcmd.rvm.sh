#!/bin/sh

# This is as simple wrapper for ruby application asterisk-mailcmd
# when using RVM (Ruby Version Manager: https://rvm.io/) 

# path to HTML and TEXT templates in ERB format
# see samples in "sample" directory
HTML_TMPL=/etc/asterisk/vmtemplate/html.erb
TEXT_TMPL=/etc/asterisk/vmtemplate/text.erb

# load RVM profile
source /etc/profile.d/rvm.sh
# run mail command
asterisk-mailcmd -t $TEXT_TMPL -m $HTML_TMPL

exit 0
