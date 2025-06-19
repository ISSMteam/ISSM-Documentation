---
title: SSH
layout: default
parent: Supplements
has_children: false
has_toc: false
---

## SSH
There are many strategies for managing SSH connections that can help to reduce repeated actions and the amount of details that you have to remember.

### Aliases
Entries in `~/.ssh/config` (and `/etc/ssh/ssh_config`) allow you to For example, let's say you typically manually connect to a remote machine with,
````
ssh <USER>@<HOST>
````
where `<USER>` is your username on the remote machine and `<HOST>` is the remote machine's hostname. By adding the following entry in `~/.ssh/config`,
````
Host <ALIAS> <HOST>
	HostName <HOST>
	User <USER>
````
where `<ALIAS>` is a name of your choosing given to this connection, you can now log in to the remote machine with, simply,
````
ssh <ALIAS>
````

Likewise, you can create shell aliases that offer the same reusability and time savings. For example, if your default shell is `bash` and configuration `~/.bash_profile`, you might create the following alias,
````
alias ssh-<ALIAS>="ssh <USER>@<HOST>"
````
which would you to log in to the remote machine with, simply,
````
ssh-<ALIAS>
````

**See also**: <a href="https://www.ssh.com/academy/ssh/config\#format-of-ssh-client-config-file-ssh_config" target="_blank">Format of SSH client config file ssh&#95;config | ssh.com</a>

### Public Key Authentication
Some remote machines require public key authentication to establish an SSH connection. But it can also be used if it is available and you do not want to have to enter your password on each connection. To set up public key authentication, you will first need an SSH key pair. You may already have a default key pair at `~/.ssh/id_rsa[.pub]`, and it is perfectly acceptable to use this key for authenticating all of your SSH connections. That said, you may wish to create a separate key for each connection, which can be done with the `ssh-keygen` utility.

After copying the public key to `~/.ssh` on the remote machine, either with the `ssh-copy-id` utility or by manually copying its contents to `~/.ssh/authorized_keys`, you can connect with,
````
ssh -i <PRIVATE_KEY> <USER>@<HOST>
````
where `<PRIVATE_KEY>` is the path to the private key on disk (e.g. the default private key is located at `~/.ssh/id_rsa`).

You can also update any aliases you may have created for a connection to use private key authentication.

- In the case of an SSH config file, use the `IdentityFile` property.
- In the case of a shell configuration file, simply add `-i <PRIVATE_KEY>` to the alias command.

**See also**: <a href="https://www.ssh.com/academy/ssh/public-key-authentication" target="_blank">What is SSH Public Key Authentication? | ssh.com</a>

### Tunneling
Another possibility is to establish an SSH tunnel between the local and remote machines. For example, running,
````
$ ssh -L 1025:localhost:22 <USER>@<HOST>
````
will redirect all traffic from port 1025 on your machine to port 22 on remote machine `<HOST>`. To use the tunnel in ISSM, change `md.cluster.port` from 0 to 1025. Solutions can now be run in the typical way (e.g. `md = md.solve(md, [options])`) but will be conducted on the remote `<HOST>` rather than the local machine.

Tunneling is especially useful on clusters with multi-stop authentication (e.g. authentication required by both login node and compute nodes).

**See also**: <a href="https://www.ssh.com/academy/ssh/tunneling-example" target="_blank">SSH Tunneling: Examples, Command, Server Config | ssh.com</a>

