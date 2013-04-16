require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "signin page" do
		before { visit signin_path }

		let( :login ) { "Sign in" }

		it { should have_selector 'title', text: full_title( login ) }
		it { should have_selector 'h1', text: login }

		describe "with invalid signin information" do
			before { click_button login }

			it { should have_selector 'div.alert.alert-error', text: 'Invalid' }

			describe "after visiting another page" do
				before { click_link "Home" }

				it { should_not have_selector 'div.alert.alert-error' }
			end
		end

		describe "with valid signin information" do
			let( :user ) { FactoryGirl.create(:user) }

			before do
				fill_in "Email", with: user.email.upcase
				fill_in "Password", with: user.password
				click_button login
			end

			it { should have_selector 'title', text: full_title( user.name ) }
			it { should have_link('Profile', href: user_path(user) ) }
			it { should have_link('Sign out', href: signout_path ) }
			it { should_not have_link('Sign in', href: signin_path ) }
		end
	end

end
