module CsiApi
  
  class GroupExClassList
    
    attr_accessor :csi_client, :class_list
    
    def initialize(client)
      self.csi_client = client
      soap_response = self.csi_client.get_class_list(142)      
      extract_classes soap_response
    end
    
    private
    
    def extract_classes(soap_response)
      self.class_list ||= []
      class_array = soap_response.body[:get_class_schedules_response][:get_class_schedules_result][:value][:class_schedules_info]
      class_array.each do |group_ex_class_data|
        create_class group_ex_class_data
      end
    end
    
    def create_class(group_ex_class_data)
      group_ex_class = GroupExClass.new group_ex_class_data
      self.class_list << group_ex_class
    end
    
  end
  
end