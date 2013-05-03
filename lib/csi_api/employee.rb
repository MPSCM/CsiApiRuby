module CsiApi
  
  class Employee
    
    class << self
      attr_accessor :attr_list
    end
    @attr_list = []
    
    attr_accessor :employee_ticket, :employee_csi_client, :ols_settings
    
    
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
      self.employee_csi_client = ClientFactory.generate_employee_client(self.employee_ticket)
    end
    
    def create_ols_settings(employee_info)
      self.ols_settings = employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:ols_settings]
    end
    
    def populate_attributes(employee_info)
      attributes = get_attribute_names(employee_info)
      Employee.create_attr_accessors attributes # if not already done
      extract_attr employee_info
    end
    
    def get_attribute_names(employee_info)
      employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_info].keys
    end
    
    def self.create_attr_accessors(attributes)
      attributes.each do |attr|
        atrb = attr.to_s.gsub("@", "").gsub!(":", "_") || attr
        attr_accessor atrb
        self.attr_list << atrb
      end
    end    
    
    def extract_attr(employee_info)
      emp_info = employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_info]
      Employee.attr_list.each do |attr|
        fn = "#{attr}="
        send(fn, emp_info[attr])      
      end
    end
    
  end
  
end