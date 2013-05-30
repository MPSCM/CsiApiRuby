module CsiApi

  class ListGenerator
    # This is meant to be a parent class; generators for lists of other types should be subclassed off this
    # See CartGenerator (cart_item.rb) and EquipmentListGenerator(equipment.rb) for example
  
    def self.generate_list(api_item_list)
      if api_item_list.nil?
        return []
      else
        self.populate_equipment_list api_item_list
      end
    end
  
    private
  
    def self.populate_equipment_list(api_item_list)
      generated_list = []
      api_item_array = self.get_equipment_array(api_item_list)
      api_item_array.each do |equipment_hash|
        item_obj = self.create_object(equipment_hash) 
        generated_list << item_obj
      end
      return generated_list
    end
  
    def self.get_equipment_array(api_item_list)
      # api_item_info = api_item_list[:api_key_for_array_of_items]
      # api_item_info.class == Array ? api_item_info : [api_item_info]
      raise NotImplementedError
    end
  
    def self.create_object(object_hash)
      # ObjectType.new object_hash
      raise NotImplementedError
    end
  
  end

end