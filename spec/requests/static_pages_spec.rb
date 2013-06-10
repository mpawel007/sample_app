require 'spec_helper.rb'

describe "StaticPages" do

	#let( :base_title ) { "Ruby on Rails Tutorial Sample App" }

	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector( 'h1', 	:text => heading ) }
		it { should have_selector( 'title', :text => full_title(page_title) ) }
	end

	after(:all) do 
		User.delete_all
		Micropost.delete_all
	end

	describe "Home page" do
		before { visit root_path }

		let( :heading ) { "Sample App" }
		let( :page_title ) { "" }

		it_should_behave_like "all static pages" 
		it { should_not have_selector('title', :text => "| Home") }

		describe "for signed in users" do
			let(:user) { FactoryGirl.create(:user) }

			before do 
				FactoryGirl.create(:micropost,user: user, content: "lorem ipsum")
				FactoryGirl.create(:micropost,user: user, content: "dolar sit")
				sign_in user
				visit root_path
			end

			it "should render the user's feed" do
				user.feed.each do |item|
					page.should have_selector "li##{item.id}", text: item.content
				end
			end

			describe "follower/following counts" do
				let( :other_user ){ FactoryGirl.create(:user) }
				before do
					other_user.follow!(user)
					visit root_path
				end

				it { should have_link "0 following", href: following_user_path( user ) }
				it { should have_link "1 followers", href: followers_user_path( user ) }

			end

			it "should not have paginaton" do
				page.should_not have_selector "div.pagination"
			end

			describe "with proper microposts count" do
				before do
					Micropost.delete_all
					visit root_path
				end

				describe "for no feed" do
					it { should have_selector 'span.count', text: "0 microposts" }
				end
				describe "1 feed" do
					before do
						FactoryGirl.create( :micropost, user: user )
						visit root_path
					end
					it { should have_selector 'span.count', text: "1 micropost" }
				end
				describe "more than 1 feeds" do 
					before do
						100.times{ FactoryGirl.create( :micropost, user: user ) }
						visit root_path
					end
					it { should have_selector 'span.count', text: "#{user.microposts.count} microposts" }
				end
			end

			describe "with bigger amount of feed" do
				before(:all) { 30.times { FactoryGirl.create( :micropost, user: user ) } }
				after(:all) { Micropost.delete_all }

				it "should have pagination" do
					page.should have_selector "div.pagination"
				end
			end
		end
	end

	describe "Help page" do
		before { visit help_path }

		let( :heading ) { "Help" }
		let( :page_title ) { "Help" }
		
		it_should_behave_like "all static pages"
	end

	describe "About page" do
		before { visit about_path }

		let( :heading ) { "About us" }
		let( :page_title ) { "About Us" }

		it_should_behave_like "all static pages"
	end

	describe "Contact page" do
		before { visit contact_path }

		let( :heading ) { "Contact" }
		let( :page_title ) { "Contact" }

		it_should_behave_like "all static pages"
	end


	it "should have the right link on the layout" do
		visit root_path

		click_link "About"
		page.should have_selector 'title', text: full_title('About Us')

		click_link "Help"
		page.should have_selector 'title', text: full_title('Help')

		click_link "Contact"
		page.should have_selector 'title', text: full_title('Contact')

		click_link "sample app"
		page.should have_selector 'title', text: full_title('')

		click_link "Sign up now!"
		page.should have_selector 'title', text: full_title('Sign up')
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
