module CsiApi
  
  class Member
    extend AddAttrAccessor
    include ExtractAttributes 
    
    attr_accessor :member_ticket, :csi_client
    
    def initialize(member_info)
      self.member_ticket = get_member_ticket(member_info)
      create_csi_client member_info
      populate_attributes member_info
    end
    
    private
    
    def get_member_ticket(member_info)
      member_info.body[:authenticate_member_response][:authenticate_member_result][:value][:member_ticket]
    end
    
    def create_csi_client(member_info)
      self.csi_client = ClientFactory.generate_member_client(self.member_ticket)
    end
    
    def get_hash_from_info(member_info)
      member_info.body[:authenticate_member_response][:authenticate_member_result][:value][:membership_info]
    end
    
  end
  
end
