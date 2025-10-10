+++
categories = ["security", "Project", "technical notes", "technical", "Import 2023-12-01 02:15"]
date = 2019-03-26T00:51:53Z
description = ""
draft = false
slug = "port-knocking-http"
summary = "Port knocking is cool. I personally believe it's among one of the best methods of securing a server. But what if you configured this for HTTP? "
tags = ["security", "Project", "technical notes", "technical", "Import 2023-12-01 02:15"]
title = "Port knocking HTTP"

+++


Port knocking is cool. I personally believe it's among one of the best methods of securing a server. But what if you configured this for HTTP? This is an idea I've had for a while. Of course it's not really practical. But maybe if you had some sort of dead drop or needed to hide a webpage or other service, adding an additional layer of authentication might make sense.




![A GIF of Jack Torrance from The Shining knocking on a door](/images/jackknocking.gif)


Port knocking works by (before a connection is even established) sending a sequence of ports[1] which is a series of connection attempts ("knocks") to closed ports on a remote host.


This allows the client/sender (wherever the sequence is being sent from) to open those ports on the remote host/receiver that is configured for port knocking. Thus, granting you access. It is the job of the server's firewall to open these ports but must be configured with a service such as knockd [2] which watches firewall logs or interfaces for connection attempts. The service will then modify the firewall rules to open the ports allowing you to connect to the host.


With this configuration you can keep services hidden until you are ready to access them. If you were to scan the remote host via Nmap the closed ports would not appear. Something we will take a look at later. One would have to check between each attempt to see if the port was actually opened. Some people would give up by that point.



iptables


Before we begin let's configure a basic firewall using iptables.


Append a rule to the INPUT (incoming connections) chain accepting all traffic on the loopback (localhost) interface:

```bash
iptables -A INPUT -i lo -j ACCEPT
```

Traffic that is generated and sent from the server to itself will be accepted.


Now allow all established connections and traffic so we're not disconnected when we begin blocking connections:

```bash
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```


Since we are port knocking HTTP we should create an iptables rule to allow access to SSH:

```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```


This will accept connnections on the default SSH port of 22.


I highly recommend you configure SSH to not use the default port!


You can also choose to ignore the basis of this post and port knock SSH instead.


Now that we've added the rules for the connections we want to accept, let's drop everything else:

```bash
iptables -A INPUT -j DROP
```


You can view the current iptables rules by running: iptables -S


It should be similar to this:

```bash
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
-A INPUT -j DROP
```


Once this is done let's install the iptables-persistent package to ensure our rules are preserved on reboot:

```bash
apt-get install iptables-persistent
```

Then start the service:

```bash
service netfilter-persistent start
```



knockd


Great, now that our intial firewall rules have been written, let's install and configure knockd which will be the port knocking service we will be using to facilitate the modification of the firewall rules and open connections to our specified ports.


```bash
apt-get install knockd
```


To configure knockd we must edit the configuration file located at * /etc/knockd.conf* But before we make any changes let's take a look at what it has to offer.


The default configuration will look like:




![A screenshot of the default knockd configuration](/images/Screenshot-from-2019-03-25-13-45-25.png)


The first section, [options] contains the instruction to UseSyslog which allows knockd to log output to /var/log/messages


Next, we have the [openSSH] section which is where we will set the knocking sequence.


sequence = 7000,8000,9000


I recommend you change the default sequence!


Below it we have a line for defining how long the sequence should be completed by before giving up. By default this is set for 5 seconds:


seq_timeout = 5


Note that the timeout is defined in seconds only.


We are then presented with a command = definition which by default uses iptables:


command = /sbin/iptables -A INPUT -s %IP% -p tcp --dport 22 -j ACCEPT


When the correct sequence is sent, this line defines what action to take which in this case will open up port 22.


Because of the append -A option in the rule, it will be added to the end of our IPTables configuration which if you view via iptables -S will be after the rule we created to drop all connections.


This will prevent us from accessing the host so we want to add a version of this before that last rule and not after.


The command should be modified to insert (-I) the rule at the top as follows:


command = /sbin/iptables -I INPUT 1 -s %IP% -p tcp --dport 80 -j ACCEPT


For our purposes we are port knocking HTTP so specify 80 as the port to open and not SSH port 22.


The next line, tcpflags sets the flag that must exist in the TCP packets in order to validate the connection.[3]


By default it is set as syn and we will keep it as such.


SYN is part of the TCP 3-way handshake.[4] This is used to create a connection.


![ezgif-2-79fa08b06794.png](/images/ezgif-2-79fa08b06794.png)
    *A diagram of the 3-way handshake*



To negotiate and start a TCP connection, three messages are sent: SYN, SYN-ACK and ACK. This allows two computers to negotiate and open separate virtual ports. The source port, which will be where the connection is being requested from (client) will be random (ephemeral) and destination will be fixed such as port 80 which is the default port for all HTTP traffic on the Internet. This allows for multiplexing which combines multiple data streams into a single physical connection via source and destination port numbers as mentioned.[5]



Actually configuring knockd


The last section [closeSSH] is similar to the first but uses a different sequence and removes the rule from iptables to close the connection.


This is annoying so we will confgiure the knockd service to do this automatically.


To make this possible we will edit the configuration file /etc/knockd.conf, removing everything and creating a new section called HTTP:

```ini
[options]
UseSyslog

[HTTP]
sequence = 6000,7000,8000,9000
tcpflags = syn
seq_timeout = 45
start_command = /sbin/iptables -I INPUT 1 -s %IP% -p tcp --dport 80 -j ACCEPT
cmd_timeout = 59
stop_command = /sbin/iptables -D INPUT -s %IP% -p tcp --dport 80 -j ACCEPT
```


The cmd_timeout option tells knockd to wait 59 seconds before executing our stop_command line which will remove our start_command iptables rule.


You can also add as many ports as you need but be sure that the connection attempt can be made in the amount of time (in seconds) specified via seq_timeout


Remember to choose a unique sequence!


Now that we have configured knockd, before we restart the service to apply the changes let's install Nginx Web server:


```bash
apt-get install nginx
```


To (optionally) start Nginx on boot you can also run the following:

```bash
systemctl enable nginx
```


Now, restart the knockd service:


```bash
service knockd restart
```



Port knocking


If you visit the FQDN or IP of your host you will be presented with nothing. That's because we haven't opened the HTTP port.


There are many ways to do this such as using the knock client which is available with the knockd package we installed previously. But we won't be using that.


Instead, we will be using a for loop and the application Nmap:

```bash
for x in 6000 7000 8000 9000; do nmap -Pn --host_timeout 201 --max-retries 0 -p $x 178.128.156.225; done
```


Let's take a look at the options passed to the nmap command:


-Pn treats all hosts as active so prevents host discovery scanning which is inefficient for our purpose.[6]


--host_timeout 201 stops trying to connect after 201 seconds.


--max-retries is the number of times to retry the port scan. We don't want nmap to rescan so it is set to 0.


-p is the port option which follows our sequence then the IP of the server who's HTTP port we want to open.


You should see a similar output to the following:




![Screenshot of port knocking with nmap](/images/Screenshot-from-2019-03-25-16-38-10.png)


Now if you connect the FQDN or IP of your web server you should see the default Welcome to nginx! template page:




![Screenshot of default Nginx template](/images/Screenshot-from-2019-03-25-15-44-25.png)


You can now access the site but remember you only have 59 seconds until the connection closes as defined in our cmd_timeout option. Then the webpage will be inaccessible on reload.


If we were to use nmap to scan our host for ports, we would only see that our specified SSH port is open.




![Screenshot of nmap scan results](/images/Screenshot-from-2019-03-25-16-29-48.png)



Summary


So yes this is kind fo silly. But there are many examples for why someone would want this configuration. If you want to keep an application private by requiring an extra step this is a method to use. One could marry this with VPN and other tools to create a very secure infrastructure. There are so many creative options. What will you do?


Postscript:

The host used in this post was created for this post only. I no longer own it.


I also want to provide attribution to this Digital Ocean document for the setup.






 1. Emphasis on emphasis of sequence ↩︎
    

 2. https://linux.die.net/man/1/knockd ↩︎
    

 3. TCPFlags = fin|syn|rst|psh|ack|urg
    
    Only pay attention to packets that have this flag set. When using TCP flags, knockd will IGNORE tcp packets that don't match the flags. This is different than the normal behavior, where an incorrect packet would invalidate the entire knock, forcing the client to start over. Using "TCPFlags = syn" is useful if you are testing over an SSH connection, as the SSH traffic will usually interfere with (and thus invalidate) the knock.
    
    Separate multiple flags with commas (eg, TCPFlags = syn,ack,urg). Flags can be explicitly excluded by a "!" (eg, TCPFlags = syn,!ack).
    
    https://linux.die.net/man/1/knockd ↩︎
    

 4. https://www.keycdn.com/support/tcp-flags ↩︎
    

 5. https://tools.ietf.org/html/rfc793#page-5 ↩︎
    

 6. https://nmap.org/book/man-host-discovery.html ↩︎
    

