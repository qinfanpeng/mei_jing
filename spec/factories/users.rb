# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	email "qinfanpeng@gmail.com"
  	password "qinfanpeng"
    role_id 1
  end
end
