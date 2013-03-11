require 'savon'

module CsiApiCalls
  
  class SoapCalls
  
    attr_accessor :soap_client

    def initialize(wsdl_url, consumer_username, consumer_password)
      client = Savon.client(wsdl: wsdl_url)
      resp = client.call(:authenticate_consumer, message: { consumer_name: consumer_username, consumer_password: consumer_password })
      auth_ticket = resp.body[:authenticate_consumer_response][:authenticate_consumer_result][:value][:auth_ticket]
      client.globals[:soap_header] = { "tns:ConsumerAuthTicket" => { "tns:Value" => auth_ticket[:value] } }
      @soap_client = client
    end
  
    def getMemberInfo(member_username, member_password)
      member = @soap_client.call(:authenticate_member, message: { username: member_username, password: member_password })
      return false if member.body[:authenticate_member_response][:authenticate_member_result][:is_exception]
      member_info = member.body[:authenticate_member_response][:authenticate_member_result][:value][:membership_info]
    end
  
    def getMemberAuthToken(member_username, member_password)
      member = @soap_client.call(:authenticate_member, message: { username: member_username, password: member_password })
      return false if member.body[:authenticate_member_response][:authenticate_member_result][:is_exception]
      member_info = member.body[:authenticate_member_response][:authenticate_member_result][:value][:membership_ticket]
    end
  
    def getEmployeeInfo(emp_username, emp_password)
      employee = @soap_client.call(:authenticate_employee, message: { user_name: emp_username, password: emp_password })
                              call(:authenticate_employee, message: {user_name: username, password: password} )
      return false if employee.body[:authenticate_employee_response][:authenticate_employee_result][:is_exception]
      emp_ticket = employee.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_info]
    end
  
    def getEmployeeAuthTicket(emp_username, emp_password)
      employee = @soap_client.call(:authentiate_employee, message: { user_name: emp_username, password: emp_password })
      return false if employee.body[:authenticate_employee_response][:authenticate_employee_result][:is_exception]
      emp_ticket = employee.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_ticket]
    end
    
    def getGroupExCategoriesList(site_id)
      categories = @soap_client.call(:get_categories, message: { module_for: "GRX", site_id: site_id, include_all_option: true, check_s_s_count: true })
      return false if categories.body[:get_categories_response][:get_categories_result][:is_exception]
      category_list = categories.body[:get_categories_response][:get_categories_result][:value]
    end
    
    def getGroupExServicesList(site_id, cat_guid=nil)
      cat_guid ||= "00000000-0000-0000-0000-000000000000" # All Categories
      gp_x = @soap_client.call(:get_group_x_services, message: { site_id: site_id, category_guid: cat_guid, mod_for: "GRX", show_inactive: false, include_all: true })
      return false if gp_x.body[:get_group_x_services_response][:get_group_x_services_result][:is_exception]
      gp_x_list = gp_x.body[:get_grou_x_services_response][:get_group_ex_services_result][:value]
    end
    
    def getClassesList(site_id)
      classes = @soap_client.call(:get_classes, message: { site_id: site_id })
      return false if classes.body[:get_classes_response][:get_classes_result][:is_exception]
      classes_list = classes.body[:get_classes_response][:get_classes_result][:value]
    end
    
  end

end