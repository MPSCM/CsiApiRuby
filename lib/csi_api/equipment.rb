module CsiApi
  
  class Equipment
    
    attr_writer :name, :x_coord, :y_coord, :associated_member, :booked
    
    def initialize(property_hash)
      self.name = property_hash[:equipment_name]
      self.x_coord = property_hash[:x_pos]
      self.y_coord = property_hash[:y_pos]
      self.associated_member = property_hash[:is_mem_associated]
      self.booked = property_hash[:is_booked]
    end
    
    def name
      @name
    end
    
    def x
      @x_coord.to_i
    end
    
    def y
      @y_coord.to_i
    end
    
    def member_associated?
      @associated_member
    end
    
    def booked?
      @booked == "0" ? false : true
    end
    
  end
  
  class EquipmentListGenerator < ListGenerator
    
    private
    
    def self.create_object(object_hash)
      Equipment.new object_hash
    end
    
    def self.get_equipment_array(api_item_list)
      api_item_info = api_item_list[:equipment_info]
      api_item_info.class == Array ? api_item_info : [api_item_info]
    end
    
  end
  
end
      