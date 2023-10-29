# knockd_auto_wrapper
A shell script wrapper which automates port knocking via knockd . 

Pls note to enable ufw firewall to block all packets. We then use knockd to add rules to iptables. 

In Server: 
chmod +x knockd.sh
./knockd.sh

## Inputs
Just enter the values as asked. 

Sequence: 7000,8000,9000
Port: 22
cmd_timeout: 20
interface: ens1


In client/ from where you are trying to connect, install knockd too, ( I used brew isntall knock for mac )
Before port knocking
nmap -Pn -p 22 ip 

 PORT   STATE    SERVICE
 22/tcp filtered ssh

 | PORT    | STATE | SERVICE |
| -------- | ------| ------|
|  22/tcp  | filtered |ssh|


knock -v ip 7000 8000 9000

After port knocking enabled:
nmap -Pn -p 22 ip 



 | PORT    | STATE | SERVICE |
| -------- | ------| ------|
|  22/tcp  | open |ssh|


Note: This happens after cmd_timeout is over


