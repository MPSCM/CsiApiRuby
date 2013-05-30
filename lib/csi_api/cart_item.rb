module CsiApi
  
  class CartItem
    
    attr_accessor :reservation_id, :schedule_id, :class_name, :description, :amount, :quantity, :tax, :site_id
    
    def initialize(item_info)
      self.reservation_id = item_info[:reservation_id] || nil
      self.schedule_id = item_info[:schedule_id] || nil
      self.class_name = item_info[:name] || nil
      self.description = item_info[:description] || nil
      self.amount = item_info[:amount] || nil
      self.quantity = item_info[:quantity] || nil
      self.tax = item_info[:tax] || nil
      self.site_id = item_info[:site_id] || nil
    end
    
  end
  
  class CartGenerator < ListGenerator
    
    private
    
    def self.get_equipment_array(api_item_list)
      api_item_info = api_item_list[:ols_cart_item]
      api_item_info.class == Array ? api_item_info : [api_item_info]
    end
    
    def self.create_object(object_hash)
      CartItem.new object_hash
    end
    
  end
  
end