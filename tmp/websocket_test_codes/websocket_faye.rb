require 'faye/websocket'
require 'eventmachine'
require 'thin'

EM.run {
	ws = Faye::WebSocket::Client.new('ws://192.168.1.54:8884/')

	ws.on :open do |event|
		p [:open]
		ws.send('Hello, world!')
	end

	ws.on :message do |event|
		p "XXXXXXXXXXXX"
		p [:message, event.data]
	end

	ws.on :close do |event|
		p [:close, event.code, event.reason]
		ws = nil
	end
}
