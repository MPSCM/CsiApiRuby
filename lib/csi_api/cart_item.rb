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
  
  class CartGenerator
    
    def self.generate_list(cart_item_list)
      if cart_item_list.nil?
        return []
      else
        self.populate_item_list cart_item_list
      end
    end
    
    private
    
    def self.populate_item_list(cart_item_list)
      item_list = []
      cart_item_array = get_cart_item_array(cart_item_list)
      cart_item_array.each do |item_hash|
        cart_item = CartItem.new(item_hash)
        item_list << cart_item
      end
      return item_list
    end
   
    def self.get_cart_item_array(cart_item_list)
      cart_item_info = cart_item_list[:ols_cart_item]
      cart_item_info.class == Array ? cart_item_info : [cart_item_info]
    end
    
  end
  
end