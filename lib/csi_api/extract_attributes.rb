module CsiApi
  
  module ExtractAttributes
    
    def populate_attributes(info)
      attributes = get_attribute_names(info)
      self.class.create_attr_accessors attributes if self.class.attr_list == nil
      extract_attr info
    end
    
    def extract_attr(info)
      info_hash = get_hash_from_info(info)
      self.class.attr_list.each do |attr|
        fn = "#{attr}="
        send(fn, info_hash[attr])
      end
    end
    
    def get_attribute_names(info)
      info_hash = get_hash_from_info(info)
      info_hash.keys
    end
    
  end
  
end 