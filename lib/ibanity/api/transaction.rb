module Ibanity
  class Transaction < Ibanity::BaseResource
    def self.list(financial_institution_id:, account_id:, customer_access_token:, **query_params)
      uri = Ibanity.api_schema["customer"]["financialInstitution"]["transactions"]
        .sub("{financialInstitutionId}", financial_institution_id)
        .sub("{accountId}", account_id)
        .sub("{transactionId}", "")
      list_by_uri(uri, query_params, customer_access_token)
    end

    def self.find(id:, financial_institution_id:, account_id:, customer_access_token:)
      uri = Ibanity.api_schema["customer"]["financialInstitution"]["transactions"]
        .sub("{financialInstitutionId}", financial_institution_id)
        .sub("{accountId}", account_id)
        .sub("{transactionId}", id)
      find_by_uri(uri, customer_access_token)
    end
  end
end
