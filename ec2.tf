resource "aws_instance" "existing_rstudio" {
  ami             = "ami-039c19f6de5d8bd93"  # Ubuntu 20.04 LTS AMI ID
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.existing_public_subnet_1.id
  security_groups = [aws_security_group.existing_rstudio_sg.id]

  tags = {
    Name = "rstudio-server-test"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y gdebi-core r-base
              sudo wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1106-amd64.deb
              sudo gdebi -n rstudio-server-1.4.1106-amd64.deb
              sudo systemctl enable rstudio-server
              sudo systemctl start rstudio-server

              sudo apt install fontconfig openjdk-17-jre -y
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
              https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              sudo echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
              https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update
              sudo apt-get install jenkins -y
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              EOF
}

resource "aws_instance" "existing_sonarqube" {
  ami             = "ami-039c19f6de5d8bd93"  # Ubuntu 20.04 LTS AMI ID
  instance_type   = "t2.medium"
  subnet_id       = aws_subnet.existing_public_subnet_1.id
  security_groups = [aws_security_group.existing_rstudio_sg.id]

  tags = {
    Name = "sonarqube-server-test"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install fontconfig openjdk-17-jre -y
              
              # Install SonarQube
              sudo apt-get install ca-certificates curl gnupg -y
              sudo install -m 0755 -d /etc/apt/keyrings
              sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              sudo chmod a+r /etc/apt/keyrings/docker.gpg
              sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update
              sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
              sudo apt install docker-compose -y
              sudo service docker restart
              sudo usermod -aG docker $USER
              sudo newgrp docker
              sudo chmod 666 /var/run/docker.sock
              sudo systemctl restart docker
              sudo docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
              EOF
}
