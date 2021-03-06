require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe 'autohorization' do

		describe "for non signed-in users" do
			let( :user ) { FactoryGirl.create(:user) }

			describe "in Microposts controller" do
				describe "submitting to create post" do
					before { post microposts_path }
					specify { response.should redirect_to signin_path }
				end
				describe "submitting to delete post" do
					before { delete micropost_path( FactoryGirl.create(:micropost, user: user ) ) }
					specify { response.should redirect_to signin_path }
				end
			end
		end

		describe 'as wrong user' do
			let( :user ) { FactoryGirl.create(:user) }
			let( :wrong_user ) { FactoryGirl.create( :user, email: 'wrong@example.com' ) }

			before{ sign_in user }

			# describe "in Microposts controller" do
			# 	describe "visiting wrong user profile page with posts" do
			# 		before { visit user_path( wrong_user ) }
			# 		it { should_not have_selector 'textarea' }
			# 	end
			# 	describe "submitting to delete wrong user post" do
			# 		before { delete micropost_path( FactoryGirl.create( :micropost, user: wrong_user ) ) }
			# 		specify { response.should redirect_to signin_path }
			# 	end
			# end

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

			describe "in Relationship controller" do
				describe "submitting to the create action" do
					before { post relationships_path }
					specify { response.should redirect_to signin_path }
				end

				describe "submitting to the destroy action" do
					before { delete relationship_path( 1 ) }
					specify { response.should redirect_to signin_path }
				end
			end

			describe 'when attempting to protected page' do
				before do
					visit edit_user_path( user )
					sign_in user
				end

				describe "after sign in on correct account" do
					it "should render the desired protected page" do
						page.should have_selector 'title', text: 'Edit user'
					end

					describe "when signing_in again" do
						before do
							click_link "Sign out"
							# delete signout_path # ???
							sign_in user
						end

						it "should render the default profile page" do
							page.should have_selector 'title', text: user.name
						end
					end
				end
			end

			describe 'in the Users controller' do
				describe 'visiting the following page' do
					before { visit following_user_path( user ) }
					it { should have_selector 'title', text: 'Sign in' }
				end

				describe 'visiting the followers page' do
					before { visit followers_user_path( user ) }
					it { should have_selector 'title', text: 'Sign in' }
				end

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
		let( :user ) { FactoryGirl.create(:user) }

		it { should have_selector 'title', text: full_title( login ) }
		it { should have_selector 'h1', text: login }

		it { should_not have_link('Users', href: users_path ) }
		it { should_not have_link('Profile', href: user_path(user) ) }
		it { should_not have_link('Settings', href: edit_user_path(user) ) }
		it { should_not have_link('Sign out', href: signout_path ) }

		it { should have_link('Sign in', href: signin_path ) }

		describe "visited as already signed in user" do 
			before do
				sign_in user
				visit signin_path
			end

			it { should_not have_selector 'title', text: login }

			describe "posting new signin information" do
				before { post signin_path }
				specify { response.should redirect_to root_path }
			end
		end

		describe "with invalid signin information" do
			before { click_button login }

			it { should have_selector 'div.alert.alert-error', text: 'Invalid' }

			describe "after visiting another page" do
				before { click_link "Home" }

				it { should_not have_selector 'div.alert.alert-error' }
			end
		end

		describe "with valid signin information" do
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
