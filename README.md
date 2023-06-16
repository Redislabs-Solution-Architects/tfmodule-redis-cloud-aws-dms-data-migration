# Redis_Cloud_to_AWS_DMS_Data_Migration
Data Migration to Redis Enterprise Cloud on AWS using AWS DMS

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