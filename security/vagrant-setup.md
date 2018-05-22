## Spin up the M310 Environments

We can now bring up our Vagrant machines. This course provides you with two VMs: database and infrastructure. You'll spend most of your time using the database VM, but for certain labs you'll use both the database and infrastructure VMs.

Go ahead and download the attached handout which contains the Vagrantfile and the associated provisioning scripts. After extracting the zip file you can run the following commands to setup the VMs.

```
$ cd m310-vagrant-env
$ vagrant plugin install vagrant-vbguest
$ vagrant up
```

After vagrant up exits successfully you'll have two VMs provisioned and up and running. You can confirm this by running vagrant status.

You'll notice that in spinning up these VMs a new shared folder was created. This folder is automatically synced with both of your VMs. You'll use this as a mechanism to bring different files and scripts into your virtual environments.

Let's go ahead confirm that each VM is up and running and that the shared folder is being synced properly. Create a temporary file on your host machine's shared folder, connect to each of the VMs, and confirm that the file was properly synced.

```
$ echo hello >> shared/test.txt
$ vagrant ssh database
$ cat ~/shared/test.txt
$ exit
$ vagrant ssh infrastructure
$ cat ~/shared/test.txt
```

Once you've confirmed that both machines are up and running and that files are seamlessly synced between your host machine and the VMs you're all set to complete the homework!

## Troubleshooting

Occasionally Vagrant will fail to sync files in the shared folder. If this happens you should perform the following steps from the host machine:

```
$ vagrant plugin install vagrant-vbguest
$ vagrant reload <machine>
$ vagrant provision <machine>
```

You can then test if this worked in the same fashion explained in step 5.

On some systems after rsync is installed it will require permissions to actually sync data between the host and the VM. This means that your first vagrant up might fail. If this is the case simply running vagrant up a second time should resolve the issue.

If you have another set of Unix utilities for Windows, those may conflict with MinGW. This will result in an rsync error that says "Error: dup() in/out/err failed". In these circumstances you should move the C:\MinGW\msys\1.0\bin directory to the beginning of your PATH.
