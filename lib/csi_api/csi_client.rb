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
    
    def get_class_list(site_id)
      message = { mod_for: "GRX_Group_Exercise", site_id: site_id }
      class_list = @soap_client.call(:get_class_schedules, message: message)
      return false if class_list.body[:get_class_schedules_response][:get_class_schedules_result][:is_exception]
      class_list
    end
  
  end

end


# def getGroupExCategoriesList(site_id)
#   categories = @soap_client.call(:get_categories, message: { module_for: "GRX", site_id: site_id, include_all_option: true, check_s_s_count: true })
#   return false if categories.body[:get_categories_response][:get_categories_result][:is_exception]
#   category_list = categories.body[:get_categories_response][:get_categories_result][:value]
# end
# 
# def getGroupExServicesList(site_id, cat_guid=nil)
#   cat_guid ||= "00000000-0000-0000-0000-000000000000" # All Categories
#   gp_x = @soap_client.call(:get_group_x_services, message: { site_id: site_id, category_guid: cat_guid, mod_for: "GRX", show_inactive: false, include_all: true })
#   return false if gp_x.body[:get_group_x_services_response][:get_group_x_services_result][:is_exception]
#   gp_x_list = gp_x.body[:get_grou_x_services_response][:get_group_ex_services_result][:value]
# end
# 
# def getClassesList(site_id)
#   classes = @soap_client.call(:get_classes, message: { site_id: site_id })
#   return false if classes.body[:get_classes_response][:get_classes_result][:is_exception]
#   classes_list = classes.body[:get_classes_response][:get_classes_result][:value]
# end