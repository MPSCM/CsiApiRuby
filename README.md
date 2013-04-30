# CSI API gem

This gem uses savon to wrap the API from CSI SpectrumNG. The is designed around a self hosted API and has not been tested on the API that CSI hosts. The bulk of it should work in that situation, probably with modification needed to the `ClientFactory.generate_soap_client function`.

##Use
+ `main_client = CsiApi::CsiClient.new { wsdl: "wsdl_url", consumer_username: "username", consumer_password: "password" }
+ `member = main_client.create_member("member_username", "member_password")`
+ `employee = main_client.create_employee("employee_username", "employee_password")`

## Goal
The goal is to implement all (most (some?)) of the methods in CSI's API as methods on one of the relevent objects above, depending on which domain they fall in to, and which authentication ticket they require. 

## Next Steps
+ write live tests for current setup: actually interfacing with CSI
+ stub the expected CSI response and use Savon testing fixtures to test current code

