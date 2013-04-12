FactoryGirl.define do
	factory :user do
		name					"Bogdan Babacki"
		email					"b.babacki@example.com"
		password				"foobar"
		password_confirmation	"foobar"
	end
end