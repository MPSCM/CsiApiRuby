module CsiApi
  
  class GroupExClassList
    include Enumerable
    
    attr_accessor :csi_client, :class_list, :start_date, :end_date
    
    # options: :site_id, :start_date, :end_date
    def initialize(client, options = {})
      self.class_list ||= []
      self.csi_client = client
      self.start_date = get_date_from_options(options[:start_date])
      self.end_date = get_date_from_options(options[:end_date])
      get_class_list(options[:site_id]) unless options.empty?
    end
    
    def each &block  
      @class_list.each do |gx_class|
        yield gx_class
      end  
    end
    
    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^sort_by_(.+)$/
        run_sort_by_method($1)
      elsif meth.to_s =~ /^choose_by_(.+)$/
        run_choose_by_method($1, args)
      else
        super
      end
    end
    
    def respond_to?(meth)
      if meth.to_s =~ /^sort_by_(.+)$/
        true
      elsif meth.to_s =~ /^choose_by_(.+)$/
        true
      else
        super
      end
    end
    
    private
    
    def run_sort_by_method(atrb)
      @class_list.sort_by { |gx_class| gx_class.send(atrb) }
    end
    
    def run_choose_by_method(atrb, args)
      @class_list.select { |gx_class| gx_class.send(atrb) == args[0] }
    end
    
    def get_date_from_options(entered_date = nil)
      if entered_date.kind_of? Date
        entered_date
      elsif entered_date =~ /\A\d{4}\-\d{2}\-\d{2}\z/
        DateTime.parse entered_date
      elsif entered_date =~ /\A\d{1,2}\/\d{1,2}\/\d{4}\z/
        DateTime.strptime entered_date, '%m/%d/%Y'
      else
        DateTime.now
      end
    end
    
    def get_class_list(site_id)
      self.start_date.to_date.upto(self.end_date.to_date) do |date|
        soap_response = self.csi_client.get_class_list(site_id, date.to_date.to_s, date.to_date.to_s)       
        extract_classes(soap_response, date)
      end
    end
    
    def extract_classes(soap_response, date)
      if soap_response.body[:get_class_schedules_response][:get_class_schedules_result][:value]
        response_body = soap_response.body[:get_class_schedules_response][:get_class_schedules_result][:value][:class_schedules_info]
        class_array = response_body.class == Array ? response_body : [response_body]
        class_array.each do |group_ex_class_data|
          create_class(group_ex_class_data, date)
        end
      end
    end
    
    def create_class(group_ex_class_data, date)
      group_ex_class = GroupExClass.new(group_ex_class_data, date)
      self.class_list << group_ex_class
    end
    
  end
  
end