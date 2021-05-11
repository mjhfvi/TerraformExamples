## This File Contain Output Information to Terminal ##

output "Public_IP_Address" {
  value                         = aws_instance.my_instance.public_ip
  description                   = "Public IP Address of Instance"
}

output "Public_DNS_Address" {
  value                         = aws_instance.my_instance.public_dns
  description                   = "Public IP Address of Instance"
}

#output "Public_Elastic_IP_Address" {
#  value                        = aws_eip.my_subnet.public_ip
#  description                  = "Public Elastic IP Address of Instance"
#}