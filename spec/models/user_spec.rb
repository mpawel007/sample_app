# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
	before { @user = User.new( name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar" ) }

	subject { @user }

	it { should respond_to( :name ) }
	it { should respond_to( :email ) }
	it { should respond_to( :password_digest ) }
	it { should respond_to( :password ) }
	it { should respond_to( :password_confirmation ) }

	it { should be_valid }

	it { should respond_to( :authenticate ) }

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authenticate method" do
		before{ @user.save }
		let( :found_user ){ User.find_by_email( @user.email ) }

		describe "valid with password" do
			it { should == found_user.authenticate( @user.password ) }
		end

		describe "invalid with password" do
			let( :user_for_invalid_password ) { found_user.authenticate( "invalid" ) }

			it { should_not == user_for_invalid_password }
			specify{ user_for_invalid_password.should be_false }
		end
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "when name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a"*51 }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			adressess = %w[user user@foo,COM A_U_R.f.b.org exap@pl foo@bar@baz.org foo@bar+baz.pl]
			adressess.each do |invalid_adress|
				@user.email = invalid_adress
				@user.should_not be_valid
			end 
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			adressess = %w[user@foo.com user@foo.COM A_U-R@f.b.org foo.bar@az.org]
			adressess.each do |valid_adress|
				@user.email = valid_adress
				@user.should be_valid
			end
		end
	end

	describe "when email adress is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

end

