module CsiApi
  
  module CheckSoapResponse
   
    def check_soap_response(response, method_name)
      response_body = response.body["#{method_name}_response".to_sym]["#{method_name}_result".to_sym] 
      if response_body[:is_exception]
        response_body[:exception][:message]
      else
        false
      end
    end
    
  end
  
end