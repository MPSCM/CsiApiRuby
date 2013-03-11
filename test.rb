require './CsiApiCalls.rb'

print "Username: "
username = gets.chomp
print "Password: "
password = gets.chomp

client = CsiApiCalls::SoapCalls.new("http://msc-app02.sccny0.local:10201/CSI-API/ApiService.asmx?wsdl", "olsuser", "olsuser")
response = client.getEmployeeInfo(username, password)
unless response
  puts "request failed"
else
  puts "Name: #{response[:name]}"
  puts "Scan Code: #{response[:scan_code]}"
  puts "Club ID: #{response[:home_site_info][:site_id]}"
end