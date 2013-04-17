require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe 'autohorization' do

		describe 'as wrong user' do
			let( :user ) { FactoryGirl.create(:user) }
			let( :wrong_user ) { FactoryGirl.create( :user, email: 'wrong@example.com' ) }

			before{ sign_in user }

			describe "visiting wrong user Users#edit page" do
				before { visit edit_user_path( wrong_user ) }
				it { should_not have_selector 'title', text: full_title( 'Edit user' ) }
			end

			describe "submitting to wrong user User#update with PUT" do
				before { put user_path( wrong_user ) }
				specify { response.should redirect_to( root_path ) }				
			end
		end

		describe 'for non signed in users' do
			let( :user ) { FactoryGirl.create(:user) }

			describe 'when attempting to protected page' do
				before do
					visit edit_user_path( user )
					fill_in "Email", with: user.email.downcase
					fill_in "Password", with: user.password
					click_button "Sign in"
				end

				describe "after sign in on correct account" do
					it "should render the desired protected page" do
						page.should have_selector 'title', text: 'Edit user'
					end
				end
			end

			describe 'in the Users controller' do
				describe 'visiting the index page' do
					before { visit users_path }
					it { should have_selector 'title', text: 'Sign in' }
				end

				describe 'visiting the edit page' do
					before { visit edit_user_path( user ) }
					it { should have_selector 'title', text: 'Sign in' }
				end

				describe 'submitting to the update path' do
					before { put user_path( user ) }
					specify { response.should redirect_to( signin_path ) }
				end
			end
		end
	end

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

			before { sign_in user }

			it { should have_selector 'title', text: full_title( user.name ) }

			it { should have_link('Users', href: users_path ) }
			it { should have_link('Profile', href: user_path(user) ) }
			it { should have_link('Settings', href: edit_user_path(user) ) }
			it { should have_link('Sign out', href: signout_path ) }
			
			it { should_not have_link('Sign in', href: signin_path ) }
		end
	end

end
