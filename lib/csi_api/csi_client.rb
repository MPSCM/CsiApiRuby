require 'savon'

module CsiApi
  
  class CsiClient
  
    attr_accessor :soap_client

    def initialize(options = {})
      # options: :wsdl, :consumer_username, :consumer_password
      ClientFactory.configure_factory(options)
      self.soap_client = ClientFactory.generate_soap_client
    end
    
    def get_member_info(username, password)
      member = @soap_client.call(:authenticate_member, message: { username: username, password: password })
      return false if member.body[:authenticate_member_response][:authenticate_member_result][:is_exception]
      member
    end
    
    def get_employee_info(username, password)
      employee = @soap_client.call(:authenticate_employee, message: { user_name: username, password: password })
      return false if employee.body[:authenticate_employee_response][:authenticate_employee_result][:is_exception]
      employee
    end
    
    def get_class_list(site_id, start_date, end_date)
      message = { mod_for: "GRX_Group_Exercise", site_id: site_id, from_date: start_date, to_date: end_date }
      class_list = self.soap_client.call(:get_class_schedules, message: message)
      return false if class_list.body[:get_class_schedules_response][:get_class_schedules_result][:is_exception]
      class_list
    end
  
  end

end
