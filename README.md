# Redis_Cloud_to_AWS_DMS_Data_Migration
Data Migration to Redis Enterprise Cloud on AWS using AWS DMS

Redis Enterprise Cloud is now being adopted by organizations who are thinking of leveraging Redis beyond cache, as a primary database itself. These organizations are migrating their workloads to Redis Enterprise Cloud on AWS, migrating their data layer from a traditional MySQL transactional database to Redis.

This partner solution showcases the data migration from a MySQL database to Redis Enterprise Cloud on AWS.  

# What you will build:
* Deployment of a reference architecture that showcases workload migration from a transactional database system like MySQL to Redis Enterprise Cloud on AWS.
* A VPC configured with a public and a private subnets, according to AWS best practices, to provide you with your own networking infrastructure on AWS.
* Within this VPC,
** In the public subnet, deploy a transactional database system like MySQL as the source database to migrate from.
** In the private subnet, deploy AWS DMS service( Data Migration service) with  source & target endpoints and DMS migration tasks that migrate the data from MySQL to Redis Enterprise Cloud on AWS.
** In a separate VPC created by Redis Inc's fully managed solution, you will perform deployment of Redis Enterprise Cloud on AWS as a target database system that will be leveraged as a primary database, replacing traditional transactional MySQL databases.
* You would also perform successful data migration verification steps, to ensure all data is migrated into Redis Enterprise Cloud on AWS.

# How to deploy:
1. Start with setting up AWS VPC with public and private subnets.
2. Prepare the source system : MySQL
3. Create and configure AWS DMS endpoint for your source system: MySQL
4. Prepare the target system: Redis Enterprise Cloud on AWS
5. Create and configure AWS DMS endpoint for your target system: Redis Enterprise Cloud on AWS
6. Test the source and target endpoint connections from DMS service.
7. Configure and run migration tasks
8. Evaluate and verify if data migration is successful.
9. Cleanup the resources.

# Reference Architecture Diagram:
![Alt text](image/data-migration-architecture.png?raw=true "Title")



*****************
Create a VPC
Create a EC2 node and install docker. Create a MySQL Db and load data into a few tables from an zip file in S3.
The DB may take about 20 minutes to load all the data.
After this configure AWS DMS.


###
You can check in the EC2 user_data how things are running by accessing the ec2 then running the following:
* cd /var/log
* cat cloud-init-output.log


### Instructions for Use:
1. Open repo in VS code
2. Copy the variables template. or rename it `terraform.tfvars`
    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```
3. Update `terraform.tfvars` variable inputs with your own inputs
    - Some require user input, some will will use a default value if none is given
4. Now you are ready to go!
    * Open a terminal in VS Code:
    ```bash
    # create virtual environment
    python3 -m venv ./venv
    # ensure ansible is in path (you should see an output showing ansible is there)
    # if you see nothing refer back to the prerequisites section for installing ansible.
    ansible --version
    # run terraform commands
    terraform init
    terraform plan
    terraform apply
    # Enter a value: yes
    # can take around 10 minutes to provision cluster
    ```