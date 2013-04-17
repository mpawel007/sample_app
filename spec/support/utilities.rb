def full_title( title ) 
	base_title = "Ruby on Rails Tutorial Sample App"

	return base_title if title.empty?
	return "#{base_title} | #{title}"
end

def sign_in(user)
	visit signin_path
	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
	# Sign in when not using Capybara as well.
	cookies[:remember_token] = user.remember_token
end