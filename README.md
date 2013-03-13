# Asterisk::Mailcmd

# Extending Asterisk voicemail message body for emails

Asterisk Voicemail email seems to be quite limited when it comes about 
configuring email body:
* Email body is a one line text with backslash escapes and Asterisk variables.
* It is limited to *512* characters (see voicemail.conf.sample)

Under these circumstances it is imposible to create nice looking, formated emails,
to have individual email templates per user or multi-languages emails' temaplets.

This simple CLI program is supposed to address these shortcomings.

## Available options
* ERB templates for HTML formatted emails
* Multilanguage templates
* Additional YAML configuration file


## Installation

Add this line to your application's Gemfile:

    gem 'asterisk-mailcmd'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install asterisk-mailcmd

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

