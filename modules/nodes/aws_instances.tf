#### Create EC2 Node for MySQL DB

# create EC2 Node for MySQL DB
resource "aws_instance" "test_node" {
  count                       = var.test-node-count
  ami                         = data.aws_ami.ec2-ami.id
  associate_public_ip_address = true
  availability_zone           = element(var.subnet_azs, count.index)
  subnet_id                   = element(var.vpc_subnets_ids, count.index)
  instance_type               = var.test_instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [ aws_security_group.dms_sg.id ]
  source_dest_check           = false

  root_block_device {
    volume_size = 40
    volume_type = "gp2"
  }

  tags = {
    Name = format("%s-mysql-node-%s", var.vpc_name,count.index+1),
    Owner = var.owner
  }

  # run cmds to create and load data to mysql db in docker
  user_data = <<-EOF
    #!/bin/bash

    sudo apt update -y
    sudo apt-get install expect -y
    sudo apt install docker.io -y
    sudo apt install wget -y
    sudo apt install unzip -y
    sudo service docker start
    sudo chmod 666 /var/run/docker.sock
    docker images
    docker run --name aws-dms-demo-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=Redis00$ -d mysql:latest
    docker ps

    echo "Now we will enter docker and create the tpcds db"
    sleep 20  # Add a delay of 10 seconds

    ###run the expect command
    expect -c '
      spawn docker exec -it aws-dms-demo-mysql mysql -uroot -p
      expect "Enter password:"
      send "Redis00$\r"
      expect "mysql>"
      send "create database tpcds;\r"
      expect "mysql>"
      send "show databases;\r"
      expect "mysql>"
      send "exit\r"
      expect eof
    '

    echo "The db is created, now get the awsdevday data"
    sleep 10  # Add a delay of 10 seconds

    wget https://aws-devday-resources.s3.us-west-2.amazonaws.com/awsdevday-dms-demo-data.zip
    unzip awsdevday-dms-demo-data.zip
    echo "You have unzipped the data"
    sleep 10  # Add a delay of 10 seconds
    cd /
    ls
    echo "Send the files to docker tmp folder"
    sudo docker cp tmp aws-dms-demo-mysql:/
    sleep 10  # Add a delay of 10 seconds
    echo "Add tables to the DB from tmp folder"

    expect -c '
      spawn docker exec -it aws-dms-demo-mysql bash
      expect "# "
      send "cd tmp\r"
      expect "# "
      send "ls\r"
      expect "# "
      send "mysql -uroot -pRedis00$ tpcds < tpcds.sql\r"
      expect "# "
      send "mysql -uroot -pRedis00$\r"
      expect "mysql>"
      send "show databases;\r"
      expect "mysql>"
      send "use tpcds;\r"
      expect "mysql>"
      send "show tables;\r"
      expect "mysql>"
      send "exit\r"
      send "exit\r"
      expect eof
    '

    echo "Now run the final step, fill the dbs"
    sleep 10  # Add a delay of 10 seconds

    expect -c '
      spawn docker exec -it aws-dms-demo-mysql bash
      expect "# "
      send "cd /tmp\r"
      expect "# "
      send "ls\r"
      expect "# "
      send "mysql -uroot -pRedis00$ -e \"SET GLOBAL local_infile=1;\"\r"
      expect "# "
      send "chmod 777 /tmp\r"
      send "exit\r"
      expect eof
    '

    echo "import dbs"
    #sleep 10  # Add a delay of 10 seconds
    #docker exec aws-dms-demo-mysql bash -c "cd /tmp && mysql -uroot -pRedis00$ --local-infile -Dtpcds -e 'load data local infile \"store_sales.dat\" replace into table store_sales character set latin1 fields terminated by \"|\"'"
    #echo "imported store_sales"
    sleep 10  # Add a delay of 10 seconds
    docker exec aws-dms-demo-mysql bash -c "cd /tmp && mysql -uroot -pRedis00$ --local-infile -Dtpcds -e 'load data local infile \"web_sales.dat\" replace into table web_sales character set latin1 fields terminated by \"|\"'"
    echo "imported web_sales"
    sleep 10  # Add a delay of 10 seconds
    
    echo "Check out count of rows in dbs"
    sleep 10  # Add a delay of 10 seconds

    expect -c '
      spawn docker exec -it aws-dms-demo-mysql bash
      expect "# "
      send "mysql -uroot -pRedis00$\r"
      expect "mysql>"
      send "show databases;\r"
      expect "mysql>"
      send "use tpcds;\r"
      expect "mysql>"
      send "show tables;\r"
      expect "mysql>"
      expect "mysql>"
      send "select count(*) from store_sales;\r"
      expect "mysql>"
      expect "mysql>"
      send "select count(*) from web_sales;\r"
      expect "mysql>"
      send "exit\r"
      send "exit\r"
      expect eof
    '
    echo "YOU DID IT!"

  EOF

}