require_relative "../lib/ibanity"
require "awesome_print"
require "date"
require "json"

Ibanity.configure do |config|
  config.certificate    = ENV["IBANITY_CERTIFICATE"]
  config.key            = ENV["IBANITY_KEY"]
  config.key_passphrase = ENV["IBANITY_PASSPHRASE"]
end

sandbox_financial_institution = Ibanity::FinancialInstitution.create_sandbox(name: "Fake Bank TEAMLEADER")
ap sandbox_financial_institution

sandbox_user = Ibanity::SandboxUser.create(attributes: {login: "plop", password: "lelutin", firstName: "Plop", lastName: "Polp"})

sandbox_account = Ibanity::SandboxAccount.create(
  sandbox_user_id: sandbox_user.id,
  financial_institution_id: sandbox_financial_institution.id,
  attributes: {
  subtype: "checking",
  relationship: "owner",
  iban: "BE123456679",
  description: "Checking account",
  currency: "EUR",
  balance: 56.42
})
ap sandbox_account

sandbox_transaction = Ibanity::SandboxTransaction.create(
  sandbox_user_id: sandbox_user.id,
  financial_institution_id: sandbox_financial_institution.id,
  sandbox_account_id: sandbox_account.id,
  attributes: {
    valueDate: "2017-05-22T00:00:00Z",
    executionDate: "2017-05-25T00:00:00Z",
    counterpart: "BE9786154282554",
    communication: "Small Cotton Shoes",
    amount: 6.99,
    currency: "EUR"
  }
)

ap "---- Financial Institutions ------ "
ap Ibanity::FinancialInstitution.all


sandbox_users = Ibanity::SandboxUser.all

sandbox_users.each do |sandbox_user|
  ap "---- Sandbox User:  ------ "
  ap sandbox_user

  sandbox_accounts = sandbox_user.sandbox_accounts
  sandbox_accounts.each do |sandbox_account|
    ap "---- Sandbox Accounts: ------ "
    ap sandbox_account

      ap "---- Sandbox Transactions ------ "
      ap sandbox_account.sandbox_transactions
  end
end

ap Ibanity::Customer.all
ap Ibanity::Customer.all.first.accounts
ap Ibanity::Customer.all.first.accounts.first.transactions

sandbox_user = Ibanity::SandboxUser.all.first
sandbox_account = sandbox_user.sandbox_accounts.first
financial_institution = sandbox_account.financial_institution

Ibanity::SandboxTransaction.create(
  sandbox_user_id: sandbox_user.id,
  financial_institution_id: financial_institution.id,
  sandbox_account_id: sandbox_account.id,
  attributes: {
    valueDate: "2017-05-22T00:00:00Z",
    executionDate: "2017-05-25T00:00:00Z",
    counterpart: "BE9786154282554",
    communication: "Second Transaction",
    amount: 100,
    currency: "EUR"
  }
)

ap Ibanity::Synchronization.create_and_wait(Ibanity::Customer.all.first.id)

ap Ibanity::Customer.all
ap Ibanity::Customer.all.first.accounts
ap Ibanity::Customer.all.first.accounts.first.transactions