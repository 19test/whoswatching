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
