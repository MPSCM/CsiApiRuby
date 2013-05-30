module CsiApi
  
  module GroupExClassSharedMethods
    #classes including this module must also include CsiApi::CheckSoapResponse
    
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
    
    private
    
    def format_time(time)
      time.strftime '%-l:%M %p'
    end
    
  end
  
end