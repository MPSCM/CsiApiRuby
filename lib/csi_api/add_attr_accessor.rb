module CsiApi
  
  module AddAttrAccessor
      
    attr_accessor :attr_list
    
    def create_attr_accessors(attributes)
      @attr_list ||= []
      attributes.each do |attr|
        atrb = attr.to_s.gsub("@", "").gsub!(":", "_") || attr
        attr_accessor atrb
        self.attr_list << atrb
      end
    end
    
  end
  
end