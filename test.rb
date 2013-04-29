require './CsiApiCalls.rb'

print "Username: "
username = gets.chomp
print "Password: "
password = gets.chomp
print "Member (m) or Employee (e): "
user = gets.chomp

csi_test = "http://csitest.sccny0.local:10201/csi45api/ApiService.asmx?wsdl"
csi_prod = "http://msc-app02.sccny0.local:10201/CSI-API/ApiService.asmx?wsdl"

client = CsiApiCalls::SoapCalls.new(csi_prod, "olsuser", "olsuser")
if user.downcase == "e" || user.downcase == "employee"  
  response = client.getEmployeeInfo(username, password)
  10.times { puts "\n" }
  unless response
    puts "request failed"
  else
    puts "Name: #{response[:first_name]} #{response[:last_name]}"
    puts "Employee ID: #{response[:employee_id]}"
    puts "Username: #{response[:user_name]}"
    puts "Employee Code: #{response[:employee_code]}"
    puts "Admin: #{response[:primary_address][:address1]}"
  end
elsif user.downcase == "m" || user.downcase == "member"
  response = client.getMemberInfo(username, password)
  10.times { puts "\n" }
  unless response
    puts "request failed"
  else
    puts "Name: #{response[:name]}"
    puts "Scan Code: #{response[:scan_code]}"
    puts "Member ID: #{response[:member_number]}"
    puts "Club ID: #{response[:home_site_info][:site_id]}"
  end
end