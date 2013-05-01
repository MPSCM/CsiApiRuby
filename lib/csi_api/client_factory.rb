module CsiApi
  
  class ClientFactory
    
    class << self
      attr_accessor :wsdl, :consumer_username, :consumer_password
    end
    
    def self.configure_factory(options = {})
      self.wsdl = options[:wsdl] || nil
      self.consumer_username = options[:consumer_username] || nil
      self.consumer_password = options[:consumer_password] || nil
    end

    def self.generate_soap_client
      client = Savon.client(wsdl: self.wsdl)
      resp = client.call(:authenticate_consumer, message: { consumer_name: self.consumer_username, consumer_password: self.consumer_password })
      auth_ticket = resp.body[:authenticate_consumer_response][:authenticate_consumer_result][:value][:auth_ticket]
      client.globals[:soap_header] = { "tns:ConsumerAuthTicket" => { "tns:Value" => auth_ticket[:value] } }
      client
    end
    
    def self.generate_member_client(member_auth_ticket)
      client = self.generate_soap_client
      client.globals[:soap_header]["tns:MemberAuthTicket"] = { "tns:Value" => member_auth_ticket[:value] }
      client
    end
    
    def self.generate_employee_client(employee_auth_ticket)
      client = self.generate_soap_client
      client.globals[:soap_header]["tns:EmployeeAuthTicket"] = { "tns:Value" => employee_auth_ticket[:value] }
      client
    end
    
  end
  
end 