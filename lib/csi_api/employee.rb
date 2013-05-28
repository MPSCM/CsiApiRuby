module CsiApi
  
  class Employee
    extend AddAttrAccessor
    include ExtractAttributes
    
    attr_accessor :employee_ticket, :soap_client, :ols_settings
    
    
    def initialize(employee_info)
      self.employee_ticket = get_employee_ticket(employee_info)
      create_employee_csi_client(employee_info)
      create_ols_settings employee_info
      populate_attributes employee_info
    end
    
    private
    
    def get_employee_ticket(employee_info)
      employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_ticket]
    end
    
    def create_employee_csi_client(employee_info)
      self.soap_client = ClientFactory.generate_employee_client(self.employee_ticket)
    end
    
    def create_ols_settings(employee_info)
      self.ols_settings = employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:ols_settings]
    end
    
    def get_hash_from_info(employee_info)
      employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_info]
    end
    
  end
  
end