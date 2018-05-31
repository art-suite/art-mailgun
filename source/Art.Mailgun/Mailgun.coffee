{Promise, log} = require 'art-standard-lib'
Config = require './Config'

module.exports = class Mailgun

  @sendEmail: (sendOptions) ->
    {config, mailgunJs, useDomain2: false} = Config
    {verbose, domain, domain2} = config.mailgun if config.mailgun

    domain = domain2 if useDomain2 && domain2

    sendOptions.from ?= "#{sendOptions.fromName ? "Feedback"} <feedback@#{domain}>"

    log Mailgun: sendEmail: send: {sendOptions, config} if verbose

    Promise.then ->
      if mailgunJs
        Promise.withCallback (callback) => mailgunJs.messages().send sendOptions, callback

      else
        verbose = true
        Promise.resolve "mailgun not setup; mail not actually sent"

    .then (emailResult) ->
      log Mailgun: sendEmail: success: {sendOptions, config, emailResult} if verbose
      emailResult

    .catch (error) ->
      log Mailgun: sendEmail: failure: {sendOptions, config, error} if verbose
      throw new Error {sendOptions, error, mailgunJs, message: "Mailgun failed to send"}
