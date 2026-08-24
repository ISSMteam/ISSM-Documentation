---
title: Epica
layout: default
parent: HPC
---

# Epica (hosted by EAPS)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----


## Getting an account
Send an email to Ed and request an account (make sure to ask him to add you to the `issm` group).

Epica has several drives. Your home directory is on a small drive, and `/data1` is for backups only. Make sure to install ISSM in `/data2`:

```sh
cd /data2/issm/
mkdir YOURUSERNAME
```
and replace YOURUSERNAME by your username. This is where you should checkout ISSM and do your work.

## ssh configuration
You can add the following lines to `~/.ssh/config` on your local machine:

```sh
Host epica epica.dartmouth.edu
   HostName epica.dartmouth.edu
   User YOURUSERNAME
```
and replace `USERNAME` by your Epica username. Once this is done, you can ssh epica by simply doing:

```sh
ssh epica
```

## Password-less ssh
Once you have the account, you can setup a public key authentication in order
to avoid having to input your password for each run. You need to have a SSH
public/private key pair. If you do not, you can create a SSH public/private key
pair by typing the following command on your local machine and following the
prompts (no passphrase necessary):

```sh
your_localhost$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/username/.ssh/id_rsa):RETURN
Enter passphrase (empty for no passphrase):RETURN
Enter same passphrase again:RETURN
Your identification has been saved in /Users/username/.ssh/id_rsa.
Your public key has been saved in /Users/username/.ssh/id_rsa.pub.
```
Two files were created: your private key `/Users/username/.ssh/id_rsa`, and the public key `/Users/username/.ssh/id_rsa.pub`.
The private key is read-only and only for you, it is used to decrypt all correspondence encrypted with the public key.
The contents of the public key need to be copied to `~/.ssh/authorized_keys` on your epica account:

```sh
your_localhost$ scp ~/.ssh/id_rsa.pub username@your_remotehost:~
```

Now on *epica*, copy the content of `id_rsa.pub`:
```sh
your_remotehost$ cat ~/id_rsa.pub >> ~/.ssh/authorized_keys
your_remotehost$ rm ~/id_rsa.pub
```
If Epica complains that about `/home/mmorligh/.ssh/authorized_keys: No such file or directory`, you may need to create an `.ssh` directory first.

## Environment
On Epica, add the following lines to ```~/.bashrc```:

```sh
export ISSM_DIR=PATHTODIR
source $ISSM_DIR/etc/environment.sh

#MATLAB alias
export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libstdc++.so.6"
alias ma='matlab -nodesktop -nosplash -r "addpath $ISSM_DIR/src/m/dev; devpath;"'
```

Use:
```sh
source ~/.bashrc
```
or Log out and log back in to apply this change.

## Installing ISSM on Epica
You can clone ISSM and install the following packages:
- autotools
- PETSc 3.25 or later
- triangle

Use the following configuration script (adapt to your needs):

```sh
./configure \
    --prefix=$ISSM_DIR \
    --with-matlab-dir="/usr/local/MATLAB/R2026a" \
    --with-triangle-dir="$ISSM_DIR/externalpackages/triangle/install" \
    --with-metis-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-petsc-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-mpi-include="$ISSM_DIR/externalpackages/petsc/install/include"  \
    --with-mpi-libflags="-L$ISSM_DIR/externalpackages/petsc/install/lib -lmpi -lmpicxx -lmpifort"\
    --with-blas-lapack-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-scalapack-dir="$ISSM_DIR/externalpackages/petsc/install/" \
    --with-mumps-dir="$ISSM_DIR/externalpackages/petsc/install/" \
    --with-numthreads=10 \
    --enable-development \
    --enable-debugging
```

## Installing ISSM with CoDiPack (AD)
You will need to install the following additional packages in the below order:

- codipack
- medipack
- adjointpetsc (use the generic script, `install.sh`)

Use the following configuration script:

```sh
TBD
```
