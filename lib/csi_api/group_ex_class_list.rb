module CsiApi
  
  class GroupExClassList
    
    attr_accessor :csi_client, :class_list, :start_date, :end_date
    
    # options: :site_id, :start_date, :end_date
    def initialize(client, options = {})
      self.csi_client = client
      self.start_date = get_date_from_options(options[:start_date])
      self.end_date = get_date_from_options(options[:end_date])
      soap_response = get_class_list(options[:site_id])
    end
    
    private
    
    def get_date_from_options(entered_date = nil)
      if entered_date.kind_of? Date
        entered_date
      elsif entered_date =~ /\A\d{4}\-\d{2}\-\d{2}\z/
        DateTime.parse entered_date
      elsif entered_date =~ /\A\d{1,2}\/\d{1,2}\/\d{4}\z/
        DateTime.strptime entered_date, '%m/%d/%Y'
      else
        DateTime.now
      end
    end
    
    def get_class_list(site_id)
      self.start_date.to_date.upto(self.end_date.to_date) do |date|
        soap_response = self.csi_client.get_class_list(site_id, date.to_date.to_s, date.to_date.to_s)       
        extract_classes(soap_response, date)
      end
    end
    
    def extract_classes(soap_response, date)
      self.class_list ||= []
      response_body = soap_response.body[:get_class_schedules_response][:get_class_schedules_result][:value][:class_schedules_info]
      class_array = response_body.class == Array ? response_body : [response_body]
      class_array.each do |group_ex_class_data|
        create_class(group_ex_class_data, date)
      end
    end
    
    def create_class(group_ex_class_data, date)
      group_ex_class = GroupExClass.new(group_ex_class_data, date)
      self.class_list << group_ex_class
    end
    
  end
  
end