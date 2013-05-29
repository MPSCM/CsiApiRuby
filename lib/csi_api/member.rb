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
      reservation_array = response.body[:get_group_ex_schedules_response][:get_group_ex_schedules_result][:value][:member_schedule_info]
      ReservationList.new(self.member_id, reservation_array)
    end
    
    def remove_item_from_cart(item)
      response = self.soap_client.call(:remove_cart_item_by_mem_num, message: { mem_num: self.member_number, reservation_id: item.reservation_id }) 
      if response.body[:remove_cart_item_by_mem_num_response][:remove_cart_item_by_mem_num_result][:is_exception] == true
        response.body[:remove_cart_item_by_mem_num_response][:remove_cart_item_by_mem_num_result][:exception][:message]
      else
        true
      end
    end
        
    def clear_cart
      response = self.soap_client.call(:member_clear_cart)
      if response.body[:member_clear_cart_response][:member_clear_cart_result][:is_exception] == true
        response.body[:member_clear_cart_response][:member_clear_cart_result][:exception][:message]
      else
        true
      end
    end
    
    def get_cart
      response = self.soap_client.call(:get_cart_by_mem_num, message: { mem_num: self.member_number })
      if response.body[:get_cart_by_mem_num_response][:get_cart_by_mem_num_result][:is_exception] == true
        response.body[:get_cart_by_mem_num_response][:get_cart_by_mem_num_result][:exception][:message]
      else
        create_cart response.body[:get_cart_by_mem_num_response][:get_cart_by_mem_num_result][:value]
      end
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
    
    def create_cart(item_list)
      CartGenerator.generate_list(item_list)
    end
    
  end
  
end
