# Nasıl?

## View

```slim
h1
	span#count 0
	| kişi sayfada onlinedir.
```

## Javascript-Client

```javascript
// app/assets/javascript/application.js
//= require websocket_rails/main
//= require_tree .
$(document).ready(function(){
	//var dispatcher = new WebSocketRails('pure-dawn-3745.herokuapp.com/websocket');
	var dispatcher = new WebSocketRails('localhost:3000/websocket');
	
	dispatcher.on_open = function(data) {
		console.log('Connection has been established: ', data);
		dispatcher.trigger('hello', 'Hello, there!');
	}
	
	var channel = dispatcher.subscribe('updates');
	channel.bind('update', function(count) {
		$('#count').text(count);
	});
});
```

## Controller

```ruby
# app/controllers/counter_controller.rb
class CounterController < WebsocketRails::BaseController
	before_filter :set_viewer
	
	def hello
		@count = Viewer.last.increment_counter!
		
		WebsocketRails[:updates].trigger(:update, @count)
	end

	def goodbye
		@count = Viewer.last.decrement_counter!
		
		WebsocketRails[:updates].trigger(:update, @count)
	end

	private
	def set_viewer
		Viewer.create(count: 0) unless Viewer.last
	end
end
```

## Model

```ruby
# app/models/viewer.rb
class Viewer < ActiveRecord::Base
	def increment_counter!
		self.update_attributes(count: self.count + 1)
		self.count
	end

	def decrement_counter!
		if self.count > 0
			self.update_attributes(count: self.count - 1)
		end

		self.count
	end
end
```

## Route

```ruby
# config/events.rb
WebsocketRails::EventMap.describe do
  subscribe :hello, 							'counter#hello'
	subscribe :client_disconnected, 'counter#goodbye'
	subscribe :connection_closed, 	'counter#goodbye'
end
```

## Application

```ruby
# config/application.rb
module Whoswatching
  class Application < Rails::Application
	  ...
		config.middleware.delete Rack::Lock
	end
end
```

## Initializers

```ruby
# initializers/websocket_rails.rb
WebsocketRails.setup do |config|
	config.standalone = false
	config.synchronize = false
  config.allowed_origins = ['http://localhost:3000']
end
```

## Kaynaklar
1. http://hereisahand.com/using-websockets-in-a-rails-project/
2. https://github.com/parkeristyping/whoswatching -> https://github.com/19test/whoswatching/
3. https://github.com/websocket-rails/websocket-rails

# Whoswatching

## Description

This is a simple site created as a demo of Websocket Rails. I wrote a blog post about it [here](http://www.hereisahand.com/using-websockets-in-a-rails-project/).

## License

Whoswatching is MIT Licensed. See LICENSE for details.
