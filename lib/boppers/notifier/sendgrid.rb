# frozen_string_literal: true

module Boppers
  module Notifier
    class Sendgrid
      attr_reader :username, :password, :domain, :email

      def initialize(username:, password:, domain:, email:, subscribe: nil)
        require "mail"

        @username = username
        @password = password
        @domain = domain
        @email = email
        @subscribe = subscribe
      end

      def call(title, message, _options)
        mail = Mail.new
        mail.delivery_method :smtp,
                             address: "smtp.sendgrid.net",
                             port: 587,
                             user_name: username,
                             password: password,
                             domain: domain,
                             authentication: :plain,
                             enable_starttls_auto: true

        mail.subject(title)
        mail.to(email)
        mail.from("Boppers <noreply@boppers>")
        mail.part("text/plain") do |part|
          part.body = message
        end

        mail.deliver
      end
    end
  end
end
