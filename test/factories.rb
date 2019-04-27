require 'factory_bot'
FactoryBot.define do
    factory :user do
      name {'Joe Chen'}
      email { 'chenjoe@gmail.com' }
      password { '88888888' }
      membership {'Club Member'}
      # using dynamic attributes over static attributes in FactoryBot
  
      # if needed
      # is_active true
    end
  end