module CsiApi
  
  class Employee
    
    ATTRS = [:employee_id, :last_pwd_date, :site_id, :employee_code, :employee_name, :user_name,
              :encrypted_password, :employee_online_status_type]
    
    ATTRS.each do |attr|
      attr_accessor attr
    end
    attr_accessor :employee_ticket, :employee_csi_client, :ols_settings
    
    
    def initialize(employee_info, csi_client)
      create_employee_csi_client(employee_info, csi_client)
      extract_attr(employee_info)
      create_ols_settings(employee_info)
    end
    
    private
    
    def create_employee_csi_client(employee_info, csi_client)
      @employee_csi_client = csi_client.dup
      auth_ticket = employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_ticket]
    end
    
    def create_ols_settings(employee_info)
      @ols_settings = employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:ols_settings]
    end
    
    def extract_attr(employee_info)
      emp_info = employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_info]
      ATTR.each do |attr|
        fn = "#{attr}="
        send(fn, emp_info[attr])      
      end
    end
    
  end
  
end