class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  # Force sign out to protect CSRF atacks
  def handle_unverified_request
  	sign_out
  	super
  end
end
