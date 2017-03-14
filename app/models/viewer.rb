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
