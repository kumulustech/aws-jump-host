# A Simple Terraform hcl to create an EC2 instance and set up basic users

Sometimes you just need a machine.  AWS provides the ability to run the t2.micro instance in their 'free' and this is a simple terraform script intended to launch that instance.

As there are often additional folks that need access, it is always good practice to give them their own accounts, and connect ssh keys.

Note that the administrative access (sudo) without password may not be appropriate for your team, but it is for mine.

Also, the default user "ubuntu" that is part of the default image gets the public ssh key from the terraform user's Home directory, so ensure that you have both parts of that key to support debugging this instance.

