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
      if message.multipart?
        the_message_html = message.html_part.body.decoded
        the_message_text = message.text_part.body.decoded
        the_message_attachments = []
        message.attachments.each do |attachment|
          file = StringIO.new(attachment.decoded)
          file.class.class_eval { attr_accessor :original_filename, :content_type }
          file.original_filename = attachment.filename
          file.content_type = attachment.mime_type
          attachment = Attachment.new
          attachment.attached_file = file
          attachment.save
          the_message_attachments << attachment
        end
      else
        the_message_html = message.body.decoded
        the_message_text = message.body.decoded
        the_message_attachments = []
      end
      m = Message.new
      m.from = message.from.first
      m.to = message.to.first
      m.subject = message.subject
      m.html_body = the_message_html
      m.text_body = the_message_text
      m.save
   
   	  UserMailer.auto_respond_mail(m.from).deliver
 	  # map attachments with message object and save other stuff and do other processing or trigger other events..
   
    rescue Exception => e
      Mailman.logger.error "Exception occurred while receiving message:\n#{message}"
      Mailman.logger.error [e, *e.backtrace].join("\n")
    end
  end
end

end
