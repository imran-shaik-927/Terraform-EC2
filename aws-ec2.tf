#EC2 instance
resource "aws_instance" "ec2-linux" {
  ami           = "ami-00c6177f250e07ec1"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.ecomm-pub-sn.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ecomm-pub-sg.id]
  key_name = "imran927"
  user_data = file("ecomm.sh")
  tags = {
    Name = "ecomm-server"
  }
}

output "ec2-linux-pip" {
    value=["${aws_instance.ec2-linux.*.public_ip}"]
}