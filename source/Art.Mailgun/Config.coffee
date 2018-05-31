{
  defineModule
  Promise
} = require 'art-standard-lib'
{Configurable} = require 'art-config'

defineModule module, class Config extends Configurable
  @defaults
    mailgun: {}
      ###
      altDomain:  "my2.domain.com"
        Useful if you are migrating your mail slowely from one domain to another
        To use, make sure altDomain is set in config, then, When calling sendEmail, pass:
          useAltDomain: true

      domain:   "my.domain.com"
      apiKey:   "blah"
      ###

  @configured: ->
    super
    if @config.mailgun?.apiKey && global.MailgunJs
      @mailgunJs = global.MailgunJs @config.mailgun
