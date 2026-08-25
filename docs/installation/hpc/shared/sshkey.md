You can setup a public key authentication in order to avoid having to input
your password all the time you log onto {{ page.machine_name }}. You need an SSH
public/private key pair on your local machine. If you do not have one, you can
create one by executing the following command on your local machine (no
passphrase necessary; press Enter at each prompt to accept the defaults):

```sh
your_localhost$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/username/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/username/.ssh/id_rsa.
Your public key has been saved in /Users/username/.ssh/id_rsa.pub.
```
Two files are created:
- your private key `/Users/username/.ssh/id_rsa`, and
- the public key `/Users/username/.ssh/id_rsa.pub`.

The private key must be kept private and never shared — keep its file
permissions restricted (`600`). The contents of the public key need to be
copied to `~/.ssh/authorized_keys` on the remote machine:

```sh
your_localhost$ scp ~/.ssh/id_rsa.pub username@your_remotehost:~
```

Now, log onto *{{ page.machine_name }}* and add the content of `id_rsa.pub` to `~/.ssh/authorized_keys`:
```sh
your_remotehost$ cat ~/id_rsa.pub >> ~/.ssh/authorized_keys
your_remotehost$ rm ~/id_rsa.pub
```
If you get an error message about `/home/username/.ssh/authorized_keys: No such
file or directory`, you may need to create a `.ssh` directory first:

```sh
your_remotehost$ mkdir ~/.ssh
your_remotehost$ chmod 700 ~/.ssh
```
