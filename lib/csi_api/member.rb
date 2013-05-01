module CsiApi
  
  class Member
    
    ATTRS = [:_PrspRelationship, :ParentMemberId, :IsSub, :IsGuest, :IsRParty, :IsProspect, :PhoneNumbers, 
              :EmergencyContact, :EmergencyPhoneInfo, :MemberId, :MemberNumber, :ScanCode, :ExpireDate, :JoinDate, 
              :RenewalDate, :Relationship, :MaritalStatus, :VisitsRemaining, :HomeSiteInfo, :Username, :PasswordChangeInfo, 
              :MemberOnlineStatusType, :MemberMessages, :CompanyInfo, :PrimaryAddressInfo, :AddressListInfo, :AcceptedAgreement, 
              :LastPwdChanged, :MTypeId, :AdditionalSites, :UdfList, :MemberContractStatus, :MemberContractGuid, :MemberContractId, 
              :PromotionId, :Grade, :IsRejoinProcess, :ExpiredContractGuid]
    ATTRS.each do |attr|
      attr_accessor attr
    end
    attr_accessor :member_ticket, :csi_client
    
    def initialize(member_info)
      create_csi_client(member_info)
      extract_attr(member_info)
    end
    
    def create_csi_client(member_info)
      self.member_ticket = member_info.body[:authenticate_member_response][:authenticate_member_result][:value][:member_ticket]
      self.csi_client = ClientFactory.generate_member_client(self.member_ticket)
    end
    
    def extract_attr(member_info)
      mbr_info = member_info.body[:authenticate_member_response][:authenticate_member_result][:value][:membership_info]
      ATTRS.each do |attr|
        fn = "#{attr}="
        send(fn, mbr_info[attr])
      end
    end
    
  end
  
end
