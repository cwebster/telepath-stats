class ApplicationController < ActionController::Base
  protect_from_forgery

 def median(array, already_sorted=false)
		return nil if array.empty?
		array.compact!
	 	array.sort!
	  	m_pos = array.size / 2
	return array.size % 2 == 1 ? array[m_pos] : mean(array[m_pos-1..m_pos])
end

def mean(array)
	return nil if array.empty?
	return array.inject(0.0) { |sum, el| sum + el } / array.size
end


end