module CsiApi
  
  class ReservationList < GroupExClassList
    
    attr_accessor :member_id
    
    def initialize(member_id, array_of_reservations = nil)
      @member_id = member_id
      @class_list = []
      create_reservations array_of_reservations if array_of_reservations
    end
  
    private
    
    def create_reservations(reservations_list)
      array_of_reservations = get_reservations_array(reservations_list)
      array_of_reservations.each do |reservation_hash|
        reservation = Reservation.new(reservation_hash, self.member_id)
        self.class_list << reservation
      end
    end
    
    def get_reservations_array(reservations_list)
      reservations_list.class == Array ? reservations_list : [reservations_list]
    end
    
  end
  
end