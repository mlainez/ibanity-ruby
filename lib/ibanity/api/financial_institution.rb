module Ibanity
  class FinancialInstitution < Ibanity::BaseResource
    def self.list(**query_params)
      uri = Ibanity.api_schema["financialInstitutions"].sub("{financialInstitutionId}", "")
      list_by_uri(uri, query_params)
    end

    def self.find(id:)
      uri = Ibanity.api_schema["financialInstitutions"].sub("{financialInstitutionId}", id)
      find_by_uri(uri)
    end
  end
end
