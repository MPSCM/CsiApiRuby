module CsiApi
  
  class Reservation
    include GroupExClassSharedMethods
    include CheckSoapResponse
    
    attr_accessor :soap_client, :schedule_id, :class_name, :site_id, :equipment_name, :start_date_time, 
                  :end_date_time, :equipment_id, :short_desc, :bio_url, :instructor, :member_id
                  
    def initialize(gx_reservation_hash, member_id)
      set_date_time gx_reservation_hash
      self.member_id = member_id
      self.schedule_id = gx_reservation_hash[:schedule_id]
      self.class_name = gx_reservation_hash[:schedule_name]
      self.site_id = gx_reservation_hash[:site_id]
      self.equipment_name = gx_reservation_hash[:equipment_name]
    end
    
    def equipment_id
      get_additional_info unless @equipment_id
      @equipment_id
    end
    
    def short_desc
      get_additional_info unless @short_desc
      @short_desc
    end
    
    def bio_url
      get_additional_info unless @bio_url
      @bio_url
    end
    
    def instructor
      get_additional_info unless @instructor
      @instructor
    end
    
    def cancel_reservation
      get_csi_client unless @soap_client
      response = self.soap_client.call(:cancel_grop_ex_enrollmentfor_no_fee, message: { schedule_id: self.schedule_id, mem_id: self.member_id })
      if exception = check_soap_response(response, :cancel_grop_ex_enrollmentfor_no_fee)
        exception
      else
        true
      end
    end  
  
    private 
    
    def set_date_time(gx_reservation_hash)
      inner_hash = gx_reservation_hash[:sessions][:schedule_session_info]
      self.start_date_time = inner_hash[:start_time]
      self.end_date_time = inner_hash[:end_time]
    end
    
    def get_csi_client
      @soap_client = ClientFactory.generate_soap_client
    end
    
    def get_additional_info
      get_csi_client unless self.soap_client
      response = self.soap_client.call(:get_schedule_by_mem_id, message: { mem_id: self.member_id })
      add_remaining_attrs response.body[:get_schedule_by_mem_id_response][:get_schedule_by_mem_id_result][:value]
    end
    
    def add_remaining_attrs(attr_hash)
      self.equipment_id = attr_hash[:equipment_id] || ""
      self.short_desc = attr_hash[:short_desc] || ""
      self.bio_url = attr_hash[:instructor_bio_url] || ""
      self.instructor = attr_hash[:instructor_name] || ""
    end
    
  end
  
end