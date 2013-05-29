# CSI API gem

This gem uses _savon_ to wrap the API from CSI SpectrumNG. The is designed around a self hosted API and has not been tested on the API that CSI hosts. The bulk of it should work in that situation, probably with modification needed to the `ClientFactory.generate_soap_client` method.

##Use
#### setup
+ `require 'csi_api'`
+ `CsiApi::ClientFactory` should not be accessed directly.
+ All classes are within the `CsiApi` module; can reference the namespace or `include CsiApi`

#### generating a soap client

Functions in the CSI API are implemented as methods on one of the below clients, based on what authentication tokens are required for the function. This will result in *extremely* method-heavy client classes if/when all of the API calls are implemented. Methods may be moved out into modules or perhaps even other classes, grouped by related tasks.

All calls to `:get_<something>_info` below return `true` if successfull and `false` otherwise.

##### For a general, authenticated client
+ `main_client = CsiApi::CsiClient.new({ wsdl: "wsdl_url", consumer_username: "username", consumer_password: "password" })`

##### For an authenticated member client
+ `member_info = main_client.get_member_info(username, password)`
+ `member = CsiApi::Member.new(member_info)`

##### For an authenticated employee client
+ `employee_info = main_client.get_employee_info(username, password)`
+ `employee = CsiApi::Employee.new(employee_info)`

#### The Group Ex module
##### Getting a list of classes - within a date range

+ `class_list = CsiApi::GroupExClassList.new(main_client, { site_id: numeric_site_id, start_date: start_date_of_range, end_date: end_date_of_range })`
  + Dates can be entered as "yyyy-mm-dd", "mm/dd/yyyy", or a Ruby `Date` or `DateTime` object.
+ `class_list.class_list` is array of CsiApi::GroupExClass objects.
+ `class_list.sort_by_<attribute_name>` returns an array of `CsiApi::GroupExClass` objects, sorted by the attribute.
+ `class_list.choose_by_<attribute_name>(attribute_value)` returns an array of `CsiApi::GroupExClass` objects, containing those where `group_ex_class.attribute_name == attribute_value`
  + `attribute_name` must be an attribute name on `CsiApi::GroupExClass`

##### Manipulating an individual Group Ex Class
+ `CsiApi::GroupExClass` is basically an attribute container with a few helper methods for time and date formatting. 
  + Attributes: `[:class_name, :instructor, :bio_url, :location, :category_name, :fees, :mem_enrolled, :schedule_id, :mem_max]`
  
##### Reserving a Group Ex Class
+ If `gx_class` is an instance of `CsiApi::GroupExClass`, and `member` is an instance of `CsiApi::Member`:
  + `gx_class.reserve_class(member)`
  + returns `true` if successful; otherwise returns a string containing the returned error message

###### Reserving Specific Equipment
+ To list equipment available for reservation:
  + `equipment_list = gx_class.get_equipment_list(csi_client)` - `csi_client` can be any class that responds to `:soap_client` (ie CsiClient, Employee, Member)
  + `equipment_list` is an array of `CsiApi::Equipment` objects
+ `gx_class.reserve_class(member, equipment)` where `equipment` is an instance of `CsiApi::Equipment` or any object that responds to `:equipment_id`

##### Listing reservations for a member
+ `reservation_list = member.get_gx_reservations` where `member` is an instance of `CsiApi::Member`
+ `reservation_list` is a subclass of `CsiApi::GroupExClassList` and has all the same methods available. It contains instances of `CsiApi::Reservation`
+ `CsiApi::Reservation` shares most methods with `CsiApi::GroupExClass`, but not all of the available attributes are the same, and the construction is much different
  + accesing any of `:equipment_id`, `:short_desc`, `:bio_url`, `:instructor` for the first time will result in a second call to the API
  + after any of these methods is called once on a particular instance, all four will be filled in and no more API calls will result

##### Canceling Reservation  
+ if `reservation` is an instance of `CsiApi::Reservation`
  + `reservation.cancel_reservation`
  + returns `true` if successful; otherwise returns a string containing the returned error message (truthy)


## Goal
The goal is to implement all (most (some?)) of the methods in CSI's API as methods on one of the relevent objects above, depending on which domain they fall in to, and which authentication ticket they require. 

## Next Steps

