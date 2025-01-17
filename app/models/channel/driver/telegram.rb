# Copyright (C) 2012-2025 Zammad Foundation, https://zammad-foundation.org/

class Channel::Driver::Telegram

=begin

  instance = Channel::Driver::Telegram.new
  instance.send(
    {
      adapter: 'telegram',
      auth: {
        api_key: api_key
      },
    },
    telegram_attributes,
    notification
  )

=end

  def deliver(options, article, _notification = false)

    # return if we run import mode
    return if Setting.get('import_mode')

    options = check_external_credential(options)

    @client = TelegramHelper.new(options[:auth][:api_key])
    @client.from_article(article)

  end

=begin

  Channel::Driver::Telegram.streamable?

returns

  true|false

=end

  def self.streamable?
    false
  end

  private

  def check_external_credential(options)
    if options[:auth] && options[:auth][:external_credential_id]
      external_credential = ExternalCredential.find_by(id: options[:auth][:external_credential_id])
      raise "No such ExternalCredential.find(#{options[:auth][:external_credential_id]})" if !external_credential

      options[:auth][:api_key] = external_credential.credentials['api_key']
    end
    options
  end

end
