# Redis_Cloud_to_AWS_DMS_Data_Migration
Data Migration to Redis Enterprise Cloud on AWS using AWS DMS

Redis Enterprise Cloud is now being adopted by organizations who are thinking of leveraging Redis beyond cache, as a primary database itself. These organizations are migrating their workloads to Redis Enterprise Cloud on AWS, migrating their data layer from a traditional MySQL transactional database to Redis.

This partner solution showcases the data migration from a MySQL database to Redis Enterprise Cloud on AWS.  

# What you will build:
* Deployment of a reference architecture that showcases workload migration from a transactional database system like MySQL to Redis Enterprise Cloud on AWS.
* A VPC configured with a public and a private subnets, according to AWS best practices, to provide you with your own networking infrastructure on AWS.
* Within this VPC,
    * In the public subnet, deploy a transactional database system like MySQL as the source database to migrate from.
    * In the private subnet, deploy AWS DMS service( Data Migration service) with  source & target endpoints and DMS migration tasks that migrate the data from MySQL to Redis Enterprise Cloud on AWS.
    * In a separate VPC created by Redis Inc's fully managed solution, you will perform deployment of Redis Enterprise Cloud on AWS as a target database system that will be leveraged as a primary database, replacing traditional transactional MySQL databases.
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
### Troubleshooting
When you create the EC2 instance docker and mysql will be installed, then a db zip file will be grabbed from s3.
Then it will create a MySQL Db and load data into a few tables from an zip file in S3.
The DB may take about 7 minutes to load all the data.
After this configure AWS DMS.
* If you would like to check out the *user_data* output that ran inside of the EC2 instance you can access the EC2 instance and run the following commands:
    ```bash
    cd /var/log
    cat cloud-init-output.log
    ```
*****************

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
    # run terraform commands
    terraform init
    terraform plan
    terraform apply
    # Enter a value: yes
    # can take around 15 minutes to provision everything
    ```
#### DMS Migration Task:
5. Now Do the DMS Data Migration!
* Follow the steps below:
* follow migration task instructions

![Alt text](image/dms-migration/Picture1.png?raw=true "Title")
![Alt text](image/dms-migration/Picture2.png?raw=true "Title")
![Alt text](image/dms-migration/Picture3.png?raw=true "Title")
![Alt text](image/dms-migration/Picture4.png?raw=true "Title")
![Alt text](image/dms-migration/Picture5.png?raw=true "Title")
![Alt text](image/dms-migration/Picture6.png?raw=true "Title")