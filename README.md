This is test Cassandra deployment to AWS using terraform, packer and ansible, created for self-learning purpose. 

CAUTION! Launching this could cost you money!

If you want to use it (just for fun), you have to do some pre-requirements:

1. Install terraform, packer, ansible;
2. Clone repository to some dir;
3. Set nevironment variables for terraform and packer (credentials and regions)
4. Build custom image with packer. You need to provide it with subnet_id, vpc_id and source_ami of AWS Linux AMI for your region. IMPORTANT NOTE: your subnet MUST be public and accesible by ansible. Also, on some Linux distributions like CentOS 7, you could also have to rename packer binary because of another default tool, which is named packer.
5. Provide terraform with created AMI and ssh key name (edit the /terraform/vars.tf file, cassandra_ami and ssh_key variables). Feel free to change the other variables (tags, instance types, availability zones, etc). Note that not every region and AZ support all recources, which used in this  demo, so  for some regions you will have to modify this or to do some additional steps to make it work. This was tested in us-west-2 region.
6. Launch terraform. In the end you will get an output with public address of load balancer. Through that you can access your cassandra cluster with default credentials.

Detailed description of all the stuff is available here:
https://medium.com/devoops-and-universe/first-experience-deploying-cassandra-on-aws-4a1b93af311d

CAUTION! Launching this could cost you money!
