require "ostruct"
require "openssl"
require "uri"
require "rest_client"
require "json"

require_relative "ibanity/util"
require_relative "ibanity/error"
require_relative "ibanity/client"
require_relative "ibanity/api/base_resource"
require_relative "ibanity/api/customer"
require_relative "ibanity/api/account"
require_relative "ibanity/api/transaction"
require_relative "ibanity/api/authorization"
require_relative "ibanity/api/financial_institution"
require_relative "ibanity/api/synchronization"
require_relative "ibanity/api/sandbox_account"
require_relative "ibanity/api/sandbox_transaction"
require_relative "ibanity/api/sandbox_user"

module Ibanity
  class << self
    def client
      options = configuration.to_h.delete_if { |_, v| v.nil? }
      @client ||= Ibanity::Client.new(options)
    end

    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Struct.new(
        :certificate,
        :key,
        :key_passphrase,
        :api_scheme,
        :api_host,
        :api_port
      ).new
    end

    def api_schema
      @urls ||= {
        "customers"                    => "https://api.ibanity.com/customers/{customerId}",
        "customerAccounts"             => "https://api.ibanity.com/customers/{customerId}/accounts/{accountId}",
        "applicationAccounts"          => "https://api.ibanity.com/accounts",
        "applicationTransactions"      => "https://api.ibanity.com/transactions",
        "customerAccountTransactions"  => "https://api.ibanity.com/customers/{customerId}/accounts/{accountId}/transactions/{transactionId}",
        "financialInstitutions"        => "https://api.ibanity.com/financial-institutions/{financialInstitutionId}",
        "customerAuthorizations"       => "https://api.ibanity.com/customers/{customerId}/authorizations/{authorizationId}",
        "customerSynchronizations"     => "https://api.ibanity.com/customers/{customerId}/synchronizations/{authorizationId}",
        "sandbox"                      => {
          "financialInstitutions" => "https://api.ibanity.com/sandbox/financial-institutions/{financialInstitutionId}",
          "users"                 => "https://api.ibanity.com/sandbox/users/{sandboxUserId}",
          "accounts"              => "https://api.ibanity.com/sandbox/financial-institutions/{financialInstitutionId}/users/{sandboxUserId}/accounts/{sandboxAccountId}",
          "transactions"          => "https://api.ibanity.com/sandbox/financial-institutions/{financialInstitutionId}/users/{sandboxUserId}/accounts/{sandboxAccountId}/transactions/{sandboxTransactionId}"
        }
      }
    end

    def respond_to_missing?(method_name, include_private = false)
      client.respond_to?(method_name, include_private)
    end

    def method_missing(method_name, *args, &block)
      if client.respond_to?(method_name)
        client.__send__(method_name, *args, &block)
      else
        super
      end
    end
  end
end