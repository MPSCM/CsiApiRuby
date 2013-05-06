module CsiApi
  
  class Member
    extend AddAttrAccessor
    
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
    
    def populate_attributes(member_info)
      attributes = get_attribute_names(member_info)
      Member.create_attr_accessors attributes if Member.attr_list == nil
      extract_attr member_info
    end
    
    def get_attribute_names(member_info)
      member_info.body[:authenticate_member_response][:authenticate_member_result][:value][:membership_info].keys
    end
    
    def extract_attr(member_info)
      mbr_info = member_info.body[:authenticate_member_response][:authenticate_member_result][:value][:membership_info]
      Member.attr_list.each do |attr|
        fn = "#{attr}="
        send(fn, mbr_info[attr])
      end
    end
    
  end
  
end
