module CsiApi
  
  class Member
    extend AddAttrAccessor
    include ExtractAttributes 
    
    attr_accessor :member_ticket, :soap_client
    
    def initialize(member_info)
      self.member_ticket = get_member_ticket(member_info)
      create_csi_client member_info
      populate_attributes member_info
    end
    
    def get_gx_reservations
      response = self.soap_client.call(:get_group_ex_schedules, message: { mem_num: self.member_number })
      response.body[:get_group_ex_schedules_response][:get_group_ex_schedules_result][:value][:member_schedule_info]
    end
    
    private
    
    def get_member_ticket(member_info)
      member_info.body[:authenticate_member_response][:authenticate_member_result][:value][:member_ticket]
    end
    
    def create_csi_client(member_info)
      self.soap_client = ClientFactory.generate_member_client(self.member_ticket)
    end
    
    def get_hash_from_info(member_info)
      member_info.body[:authenticate_member_response][:authenticate_member_result][:value][:membership_info]
    end
    
  end
  
end
