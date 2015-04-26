task :get_mail => :environment do
	#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require "mailman"
# require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

#Mailman.config.logger = Logger.new("log/mailman.log")
Mailman.config.poll_interval = 3
Mailman.config.pop3 = {
  server: 'pop.gmail.com', port: 995, ssl: true,
  username: "puneetgupta1801@gmail.com",
  password: "puneet18"
  # server: 'mail.bov.nu', port: 995, ssl: true,
  # username: "info@sealproperties.co.uk",
  # password: "info1234"
}

Mailman::Application.run do
  default do
    begin
      p "Found a new message"
      p "-------------------------------"
      p message
      p "-------------------------------"
      p message.multipart?
      p "-------------------------------"

      p "-------------------------------1"
      m = Message.new
      p "-------------------------------2"
      m.from = message.from.first
      p "-------------------------------3"
      m.to = message.to.first
      p "-------------------------------4"
      m.subject = message.subject
      p "-------------------------------5"
      m.html_body = message.multipart? ? message.html_part.body.decoded : message.body.decoded
      p "-------------------------------6"
      m.text_body = message.multipart? ? message.text_part.body.decoded : message.body.decoded
      p "-------------------------------7"
      p message.date
      p "-------------------------------8"
      m.date = message.date
      p "-------------------------------9"
      m.save
      p "-------------------------------10"

      if message.multipart?
        the_message_html = message.html_part.body.decoded
        the_message_text = message.text_part.body.decoded
        the_message_attachments = []
        message.attachments.each do |attachment|
          file = StringIO.new(attachment.decoded)
          file.class.class_eval { attr_accessor :original_filename, :content_type }
          file.original_filename = attachment.filename
          file.content_type = attachment.mime_type
          attachment = m.attachments.new
          attachment.attached_file = file
          attachment.save
          the_message_attachments << attachment
        end
      else
        the_message_html = message.body.decoded
        the_message_text = message.body.decoded
        the_message_attachments = []
      end

   	   UserMailer.auto_respond_mail(m.from).deliver
   	   UserMailer.copy_to_emma(m.from, m.html_body).deliver
 	  # map attachments with message object and save other stuff and do other processing or trigger other events..
   
    rescue Exception => e
      Mailman.logger.error "Exception occurred while receiving message:\n#{message}"
      Mailman.logger.error [e, *e.backtrace].join("\n")
    end
  end
end

end
