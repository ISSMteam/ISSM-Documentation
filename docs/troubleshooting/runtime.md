---
title: Runtime Errors
layout: default
parent: Troubleshooting
nav_order: 3
---

# Runtime Errors
## cannot connect to local mpd
The following message appears in the errlog file when launching a job in parallel:
````
<SERVER>: cannot connect to local mpd (/tmp/mpd2.console_name);
possible causes:
1. no mpd is running on this host
2. an mpd is running but was started without a "console" (-n option)
~
~
````

This message means that the MPI (Message Passing Interface) server, called mpd, is not running. Therefore, no parallel jobs can run on the cluster. To solve this issue, just type, at the command prompt on the server side (if, for example, your cluster has 8 CPU's),
````
mpd --ncpus=8 &
````
This will launch the MPI server to manage 8 CPU's on the cluster.

