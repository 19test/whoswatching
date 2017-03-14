require 'eventmachine'
require 'em-websocket'
require 'socket'

EM.run {
	EM::WebSocket.run(:host => "192.168.1.54", :port => 8884) do |ws|

		ws.onopen { |handshake|
			puts "WebSocket connection open"
			ws.send "Hello Client, you connected to: #{Socket.gethostname}. websocket server path: #{handshake.path}"

			timer = EventMachine::PeriodicTimer.new(0.5) do
				value =  (rand(100..6000) / 1000.0 )
				message = "time: #{Time.now} value: #{value.to_s}"
				ws.send message
				puts message
			end
		}
		
		ws.onclose { puts "Connection closed" }

		ws.onmessage { |msg|
			puts "Received message: #{msg}"
			ws.send "Pong: #{msg}"
		}
	end
}


#require 'websocket-eventmachine-client'
#
#EM.run do
#	# ws = WebSocket::EventMachine::Client.connect(:uri => 'ws://192.168.1.54:8884/')
#	ws = WebSocket::EventMachine::Client.connect(:uri => 'ws://192.168.1.54:8784/')
#	puts ws.comm_inactivity_timeout
#
#	ws.onopen do
#		puts "Connected"
#	end
#
#	ws.onmessage do |msg, type|
#		puts "Received message: #{msg}"
#	end
#
#	ws.onclose do |code, reason|
#		puts "Disconnected with status code: #{code}"
#	end
#
#	EventMachine.add_periodic_timer(1) do
#		ws.send "Heartbeat ... #{DateTime.now.to_i}"
#	end
#end
