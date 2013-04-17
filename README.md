# Asterisk::Mailcmd
[![Build Status](https://travis-ci.org/staskobzar/asterisk-mailcmd.png?branch=master)](https://travis-ci.org/staskobzar/asterisk-mailcmd)
[![Code Climate](https://codeclimate.com/github/staskobzar/asterisk-mailcmd.png)](https://codeclimate.com/github/staskobzar/asterisk-mailcmd)
[![Gem Version](https://badge.fury.io/rb/asterisk-mailcmd.png)](http://badge.fury.io/rb/asterisk-mailcmd)
# Extending Asterisk voicemail message body for emails

Asterisk Voicemail email seems to be quite limited when it comes about 
configuring email body:
* Email body is a one line text with backslash escapes and Asterisk variables.
* It is limited to *512* characters (see voicemail.conf.sample)

Under these circumstances it is impossible to create nice looking, formatted emails,
to have individual email templates per user or multi-languages emails' templates.

This simple a simple library which is supposed to address these shortcomings.

## HTML Voicemail notification example
![html email](https://raw.github.com/staskobzar/asterisk-mailcmd/master/sample/html_email.png)

## Installation

### Library for your application
Add this line to your application's Gemfile:

    gem 'asterisk-mailcmd', :git => git://github.com/staskobzar/asterisk-mailcmd.git

And then execute:

    $ bundle

### Command line application
Or install it yourself as:

    $ git clone git://github.com/staskobzar/asterisk-mailcmd.git
    $ cd asterisk-mailcmd
    $ gem build asterisk-mailcmd.gemspec
    $ gem install asterisk-mailcmd-X.X.X.gem

## Asterisk configuration
Asterisk voice mail must be configured to run this library when new voicemail received. There is an option **mailcmd** in voicemail.conf which must link to the executable script with this library: 

    mailcmd=/usr/local/bin/mailcmd

Another option that must be set is the `mailbody` :
```
mailbody=VM_NAME:${VM_NAME}\nVM_DUR:${VM_DUR}\nVM_MSGNUM:${VM_MSGNUM}\nVM_MAILBOX:${VM_MAILBOX}\nVM_CALLERID:${VM_CALLERID}\nVM_CIDNUM:${VM_CIDNUM}\nVM_CIDNAME:${VM_CIDNAME}\nVM_DATE:${VM_DATE}\nVM_MESSAGEFILE:${VM_MESSAGEFILE}
```

This is a list of variables that will be used in ERB templates.

You can not use *asterisk-mailcmd* CLI application installed with this gem directly as a reference in in option **mailcmd** because Asterisk when asterisk run the command, it will not have information about your environment like path to ruby interpreter. 
For that you must have a wrapper. Example of the wrapper can be found with the source: "sample/mailcmd.rvm.sh". Here is sample code:


```bash

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

```

Save this to file */usr/local/bin/mailcmd*, just like it is set with **mailcmd** option.
Make sure that the file is executable.


### Ruby gem library
You can create your own ruby script:

```ruby
require 'asterisk/mailcmd'

Asterisk::Mailcmd::Email.set_and_send :text_tmpl => '/path/text.erb',
                                      :html_tmpl => '/path/html.erb'
```

## `Asterisk::Mailcmd::Email.set_and_send` parameters list:

```
:html_tmpl  => String: MANDATORY: HTML part ERB template file path
:text_tmpl  => String: MANDATORY: Text part ERB template file path
:charset    => String: OPTIONAL: Content type charset
:date       => Time: OPTIONAL: Email date
```
## Templates
Templates are ERB format with variables that are set with Asterisk (see option *mailbody*):

```
<h1>There is new mail in mailbox: <%= @astvars[:VM_MAILBOX].to_s %> </h1>
```
There are two example files in directory *sample*. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

