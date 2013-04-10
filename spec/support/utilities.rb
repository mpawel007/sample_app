def full_title( title ) 
	base_title = "Ruby on Rails Tutorial Sample App"

	return base_title if title.empty?
	return "#{base_title} | #{title}"
end