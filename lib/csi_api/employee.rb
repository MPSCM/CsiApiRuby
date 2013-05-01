module CsiApi
  
  class Employee
    
    ATTRS = [:employee_id, :last_pwd_date, :site_id, :employee_code, :employee_name, :user_name,
              :encrypted_password, :employee_online_status_type]
    
    ATTRS.each do |attr|
      attr_accessor attr
    end
    attr_accessor :employee_ticket, :employee_csi_client, :ols_settings
    
    
    def initialize(employee_info)
      create_employee_csi_client(employee_info)
      extract_attr(employee_info)
      create_ols_settings(employee_info)
    end
    
    private
    
    def create_employee_csi_client(employee_info)
      self.employee_ticket = employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_ticket]
      self.employee_csi_client = ClientFactory.generate_employee_client(self.employee_ticket)
    end
    
    def create_ols_settings(employee_info)
      self.ols_settings = employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:ols_settings]
    end
    
    def extract_attr(employee_info)
      emp_info = employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_info]
      ATTRS.each do |attr|
        fn = "#{attr}="
        send(fn, emp_info[attr])      
      end
    end
    
  end
  
end