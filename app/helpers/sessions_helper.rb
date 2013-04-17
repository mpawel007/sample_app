module SessionsHelper

	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
		#{ value: user.remember_token, expires: 20.years.from_now.utc }
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def current_user=(user)
		@current_user = user
	end	

	def current_user
		@current_user ||= User.find_by_remember_token( cookies[:remember_token] )
	end

	def current_user?(user)
		user == current_user
	end

	def redirect_back_or(default)
		redirect_to( session[:return_to] || default )
		session.delete( :return_to )
	end

	def store_location
		session[:return_to] = request.url
	end
end

# duza 1256.63
# srednia 804.24

# 2xsrednia 1608.49
# duza+srednia 2060.87 

# quattro duza 40.5
# quattro srednia 32.5

# insolito duza 35.5
# insolito srednia 25.5

# quattro promocja 2 za 5 zl 37.5 = 0.02331379119 zl/cm2
# quattro promocaja mala gratis 40.5 = 0.01965189458 zl/cm2

# insolito promocja 2 za 5zl 30.5 = 0.0189618835 zl/cm2
# insolito promocja mala gratis 35.5 = 0.01722573476 zl/cm2

