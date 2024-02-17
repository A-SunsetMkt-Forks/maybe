# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create the default user
family = Family.create_or_find_by(name: "The Maybe Family")
puts "Family created: #{family.name}"
user = User.create_or_find_by(email: "user@maybe.local") do |u|
  u.first_name = "Josh"
  u.last_name = "Maybe"
  u.password = "password"
  u.password_confirmation = "password"
  u.family_id = family.id
end
puts "User created: #{user.email} for family: #{family.name}"

# Create default currency
Currency.find_or_create_by(iso_code: "USD", name: "United States Dollar")

current_balance = 350000

account = Account.create_or_find_by(name: "Seed Property Account", accountable: Account::Property.new, family: family, original_balance: current_balance, original_currency: "USD")
puts "Account created: #{account.name}"

# Represent user-defined "Valuations" at various dates
appraisals = [
  { date: Date.today - 30, balance: 300000 },
  { date: Date.today - 22, balance: 300700 },
  { date: Date.today - 17, balance: 301400 },
  { date: Date.today - 10, balance: 300000 },
  { date: Date.today - 3, balance: 301900 }
]

# In prod, this would be calculated from the current balance and the appraisals with a background job
# Hardcoded for readability
balances = [
  { date: Date.today - 30, balance: 300000 },
  { date: Date.today - 29, balance: 300000 },
  { date: Date.today - 28, balance: 300000 },
  { date: Date.today - 27, balance: 300000 },
  { date: Date.today - 26, balance: 300000 },
  { date: Date.today - 25, balance: 300000 },
  { date: Date.today - 24, balance: 300000 },
  { date: Date.today - 23, balance: 300000 },
  { date: Date.today - 22, balance: 300700 },
  { date: Date.today - 21, balance: 300700 },
  { date: Date.today - 20, balance: 300700 },
  { date: Date.today - 19, balance: 300700 },
  { date: Date.today - 18, balance: 300700 },
  { date: Date.today - 17, balance: 301400 },
  { date: Date.today - 16, balance: 301400 },
  { date: Date.today - 15, balance: 301400 },
  { date: Date.today - 14, balance: 301400 },
  { date: Date.today - 13, balance: 301400 },
  { date: Date.today - 12, balance: 301400 },
  { date: Date.today - 11, balance: 301400 },
  { date: Date.today - 10, balance: 300000 },
  { date: Date.today - 9, balance: 300000 },
  { date: Date.today - 8, balance: 300000 },
  { date: Date.today - 7, balance: 300000 },
  { date: Date.today - 6, balance: 300000 },
  { date: Date.today - 5, balance: 300000 },
  { date: Date.today - 4, balance: 300000 },
  { date: Date.today - 3, balance: 301900 },
  { date: Date.today - 2, balance: 301900 },
  { date: Date.today - 1, balance: 301900 },
  { date: Date.today, balance: 302000 }
]


appraisals.each do |appraisal|
  Appraisal.find_or_create_by(
    account_id: account.id,
    date: appraisal[:date]
  ) do |appraisal_record|
    appraisal_record.value = appraisal[:balance]
    appraisal_record.currency = "USD"
  end
end

balances.each do |balance|
  AccountBalance.find_or_create_by(
    account_id: account.id,
    date: balance[:date]
  ) do |balance_record|
    balance_record.balance = balance[:balance]
    balance_record.currency = "USD"
  end
end
