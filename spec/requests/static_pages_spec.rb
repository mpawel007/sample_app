require 'spec_helper'

describe "StaticPages" do

	describe "Home page" do
		it "Should have content 'Sample App'" do
			visit '/static_pages/home'
			page.should have_selector('h1', :text => "Sample App")
		end

		it "Should have right title" do
			visit "/static_pages/home"
			page.should have_selector('title', :text => "Ruby on Rails Tutorial Sample App | Home")
		end
	end

	describe "Help page" do
		it "Should have content 'Help'" do
			visit '/static_pages/help'
			page.should have_selector('h1', :text => "Help")
		end

		it "Should have right title" do
			visit "/static_pages/help"
			page.should have_selector('title', :text => "Ruby on Rails Tutorial Sample App | Help")
		end
	end

	describe "About page" do
		it "Should have content 'About us'" do
			visit '/static_pages/about'
			page.should have_selector('h1', :text => "About us")
		end

		it "Should have right title" do
			visit "/static_pages/about"
			page.should have_selector('title', :text => "Ruby on Rails Tutorial Sample App | About Us")
		end
	end

end
#   describe "GET /static_pages" do
#     it "works! (now write some real specs)" do
#       # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#       get static_pages_index_path
#       response.status.should be(200)
#     end
#   end
# end
