module CsiApi
  
  class GroupExClass
    
    # attrs from GetClassSchedules
    ATTRS_FROM_LIST = [:class_name, :instructor, :bio_url, :location, :category_name, :fees, :mem_enrolled, :schedule_id, :mem_max]
    ATTRS_FROM_LIST.each do |atrb|
      attr_accessor atrb
    end
    
    attr_accessor :soap_client, :start_date_time, :end_date_time
    
    # group_ex_class_info is element from array of group ex classes returned
    # to the GroupExClassList object. It's just a hash
    def initialize(group_ex_class_info, date)
      # self.soap_client = ClientFactory.generate_soap_client
      set_attributes(group_ex_class_info, ATTRS_FROM_LIST)
      set_date_time(group_ex_class_info, date)
    end
    
    def long_date
      self.start_date_time.strftime '%A, %b %-d, %Y'
    end
    
    def short_date
      self.start_date_time.strftime '%-m/%-d/%Y'
    end
    
    def date
      self.start_date_time.to_date
    end
    
    def start_time
      format_time(self.start_date_time)
    end
    
    def end_time
      format_time(self.end_date_time)
    end
    
    def reserve_class(member, equipment_id = nil)
      message = {schedule_id: self.schedule_id, mem_id: member.member_id }
      message[:equipment_id] = equipment_id if equipment_id
      response = member.soap_client.call(:add_ol_s_cart_entry_for_group_x, message: message)
      if response.body[:add_ol_s_cart_entry_for_group_x_response][:add_ol_s_cart_entry_for_group_x_result][:is_exception]
        response.body[:add_ol_s_cart_entry_for_group_x_response][:add_ol_s_cart_entry_for_group_x_result][:exception][:message]
      else
        true
      end
    end
    
    def get_equipment_list(soap_client_container)
      response = soap_client_container.soap_client.call(:get_equipment_list, message: { schedule_id: self.schedule_id })
      response.body[:get_equipment_list_response][:get_equipment_list_result][:value][:equipment_list][:equipment_info]
    end
    
    private
    
    def format_time(time)
      time.strftime '%-l:%M %p'
    end
    
    def set_attributes(api_info, list_of_attrs)
      list_of_attrs.each do |atrb|
        fn = "#{atrb}="
        send(fn, api_info[atrb])
      end
    end
    
    def set_date_time(group_ex_class_info, date)
      class_start_time = Time.parse group_ex_class_info[:start_time]
      class_end_time = Time.parse group_ex_class_info[:end_time]
      self.start_date_time = DateTime.new(date.year, date.month, date.day, class_start_time.hour, class_start_time.min)
      self.end_date_time = DateTime.new(date.year, date.month, date.day, class_end_time.hour, class_end_time.min)
    end
        
  end

end