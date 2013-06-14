module CsiApi
  
  module GroupExClassSharedMethods
    #classes including this module must also include CsiApi::CheckSoapResponse
    
    attr_accessor :soap_client, :long_waiver, :short_waiver
    
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
    
    def get_equipment_list(soap_client_container)
      response = soap_client_container.soap_client.call(:get_equipment_list, message: { schedule_id: self.schedule_id })
      if exception = check_soap_response(response, :get_equipment_list)
        exception
      else
        CsiApi::EquipmentListGenerator.generate_list response.body[:get_equipment_list_response][:get_equipment_list_result][:value][:equipment_list]
      end
    end
    
    def long_waiver
      get_waivers unless @long_waiver
      @long_waiver
    end
    
    def short_waiver
      get_waivers unless @short_waiver
      @short_waiver
    end
    
    def soap_client
      get_soap_client unless @soap_client
      @soap_client
    end
    
    private
    
    def get_soap_client
      @soap_client = CsiApi::ClientFactory.generate_soap_client
    end
    
    def format_time(time)
      time.strftime '%-l:%M %p'
    end
    
    def get_waivers
      response = self.soap_client.call(:get_waiver_by_schedule_id, message: { schedule_id: self.schedule_id })
      value = response.body[:get_waiver_by_schedule_id_response][:get_waiver_by_schedule_id_result][:value]
      @short_waiver = value[:short_waiver].to_s
      @long_waiver = value[:long_waiver].to_s
    end
    
  end
  
end