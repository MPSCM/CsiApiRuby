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
  
  class EquipmentListGenerator
    
    def self.generate_list(csi_equipment_list)
      if csi_equipment_list.nil?
        return []
      else
        self.populate_equipment_list csi_equipment_list
      end
    end
    
    private
    
    def self.populate_equipment_list(csi_equipment_list)
      equipment_list = []
      csi_equipment_array = self.get_equipment_array(csi_equipment_list)
      csi_equipment_array.each do |equipment_hash|
        equipment_obj = Equipment.new(equipment_hash) 
        equipment_list << equipment_obj
      end
      return equipment_list
    end
    
    def self.get_equipment_array(csi_equipment_list)
      equipment_info = csi_equipment_list[:equipment_info]
      equipment_info.class == Array ? equipment_info : [equipment_info]
    end
  end
  
end
      