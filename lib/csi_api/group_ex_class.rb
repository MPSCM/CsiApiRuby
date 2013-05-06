module CsiApi
  
  class GroupExClass
    
    # attrs from GetClassSchedules
    ATTRS_FROM_LIST = [:class_name, :instructor, :bio_url, :location, :category_name, :fees, :mem_enrolled, :schedule_id, :mem_max]
    ATTRS_FROM_LIST.each do |atrb|
      attr_accessor atrb
    end
    
    # attrs from GetScheduleByMemId
    ATTRS_FROM_SINGLE= [:short_desc, :schedule_date_from, :schedule_date_to]
    ATTRS_FROM_SINGLE.each do |atrb|
      attr_accessor atrb
    end
    
    attr_accessor :soap_client
    
    def schedule_date_from=(value)
      @schedule_date_from = parse_csi_date(value)
    end
    
    def schedule_date_to=(value)
      @schedule_date_to = parse_csi_date(value)
    end
    
    def parse_csi_date(value)
      DateTime.strptime value, '%m/%d/%Y %H:%M:%S %p'
    end
    
    # group_ex_class_info is element from array of group ex classes returned
    # to the GroupExClassList object
    def initialize(group_ex_class_info)
      self.soap_client = ClientFactory.generate_soap_client
      set_attributes(group_ex_class_info, ATTRS_FROM_LIST)
      get_remaining_info
    end
    
    def set_attributes(api_info, list_of_attrs)
      list_of_attrs.each do |atrb|
        fn = "#{atrb}="
        send(fn, api_info[atrb])
      end
    end
    
    def get_remaining_info
      message = { schedule_id: self.schedule_id}
      soap_response = self.soap_client.call(:get_schedule_by_mem_id, message: message)
      class_info = soap_response.body[:get_schedule_by_mem_id_response][:get_schedule_by_mem_id_result][:value]
      set_attributes(class_info, ATTRS_FROM_SINGLE)
    end
        
  end

end