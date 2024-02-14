# A Simple Terraform hcl to create an EC2 instance and set up basic users

Sometimes you just need a machine.  AWS provides the ability to run the t2.micro instance in their 'free' and this is a simple terraform script intended to launch that instance.

As there are often additional folks that need access, it is always good practice to give them their own accounts, and connect ssh keys.

Note that the administrative access (sudo) without password may not be appropriate for your team, but it is for mine.

Also, the default user "ubuntu" that is part of the default image gets the public ssh key from the terraform user's Home directory, so ensure that you have both parts of that key to support debugging this instance.

## Launch a host

Ensure your AWS SSO credentials are configured, or capture your AWS SECRET KEY and AWS SECRET KEY ID {not recommended}

```sh
export AWS_PROFILE={yourAWSssoProfile}
export AWS_REGION=us-west-2 # this is where the Ubuntu AMI comes from
```

### Get a static IP

For consistency, if you need to set up VPN/Firewall whitelists, etc., and if you want a DNS name associated with the address.

1. Update the Route53 zone_id and name fields, and if needed change the TTL (in case you're likely to change this IP often) information in pub-ip/pub-ip.tf.
2. Allocate and associate the IP with the DNS name

```sh
cd pub-ip/
terraform init
terraform plan -out ip.tfplan
terraform apply ip.tfplan
cd ..
```

### Launch a Host

You'll need to modify this file host/host.tf to include your own users and their ssh-keys

then:

```sh
cd host/
terraform init
terraform plan -out host.tfplan
terraform apply host.tfplan
```


## Finished?  Tear it down

```sh
cd pub-ip
terraform apply -destroy
# answer 'yes'
cd ../host
terraform apply -destroy
# answer 'yes'
cd ..
```
