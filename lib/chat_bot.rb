
require 'xmpp4r'

class ChatBot

  attr_accessor :jid, :password, :room, :nick, :chat_server

  def initialize
    self.jid         = Jabber::JID.new('admin@localhost/admin')
    self.password    = 'password'
    self.room        = 'chat'
    self.chat_server = 'conference.localhost'
    self.nick        = 'ChatBot'
  end

  def run
    begin
      establish_connection
      @client.add_message_callback do |message|
        puts "From: #{message.from}"
        puts message.body
        puts '---'

        @client.send(Jabber::Message.new(message.from, `fortune`))
      end

      @client.add_presence_callback do |presence|
        puts "#{presence.from} is #{presence.type || 'available'}"
      end

      @client.send(Jabber::Presence.new)

      Thread.stop
      puts "Shutting down clean."
    rescue => e
      puts e
      puts e.backtrace
    ensure
      # exit_rooms
      close_connection
      puts "Shut down."
    end
  end

  private

    def establish_connection
      @client = Jabber::Client.new(Jabber::JID.new(jid))
      @client.connect
      @client.auth(password)
    end

    def close_connection
      @client.close if @client
    end
end
