output "cicd_lab-public_ip" {
  value       = aws_instance.cicd_lab.public_ip
  description = "Public IP of the lab instance"
}

output "cicd_lab-public_dns" {
  value       = aws_instance.cicd_lab.public_dns
  description = "Public DNS of the lab instance"
}