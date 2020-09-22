# **CentOS 7 Setup Guide for VPS with DigitalOcean** 

This will be a setup guide from Starting with **DigitalOcean** to **Phantombot** running fully. 
I’ve double check if they still have that promo for new users on their main site but it’s been removed. Usually you can get $100 for 60 days that will give you enough time to play around with the droplets. 

**Referal link**: https://m.do.co/c/9d3a8c0a51da
***
# **Step 1:   Creating a droplet**

Top right you will see a green button named “Create” click on it. 

Click on Droplets **“Create cloud Servers”** 
![Image](https://i.imgur.com/mootoRA.png)

Choose the **OS** named **CentOS 7.6 x64**
![Image](https://i.imgur.com/rsfeGF2.png)

Choose a plan, keep this on standard. And choose the $5 a month.
![Image](https://i.imgur.com/GjKVjCO.png)
Next option is purely up to you if you wish that DigitalOcean makes backups of your VPS every week. 
![Image](https://i.imgur.com/Qv5p9sB.png)
Next what you need to choose is the server location, I’d suggest to choose the one closest to you. 
![Image](https://i.imgur.com/6PBHHqU.png)
Additional option would be monitoring. 
![Image](https://i.imgur.com/4O3X4hw.png)
At host name you can leave it or change it to what you prefer. 

And final click the create button on the bottom!

Now you are done creating your **VPS CentOS** server. 

***
# **Step 2. Acquiring the tools**

Tools we need in order to continue:
* WinSCP  	https://winscp.net/eng/download.php
This tool you can use to upload files or download files via **SFTP**.

* Putty 		https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
This tool is used to communicate with your server via **SSH**.

* Coffee


 
***
# **Step 3. Setting up the CentOS server**

Check your email you should have received an email from DigitalOcean with IP and login details.
Example 
![Image](https://i.imgur.com/H2PXEN9.png) 
Open your putty app and fill in your ip that you have received and give it a name so that you can save the address for later use if needed. 
![Image](https://i.imgur.com/PoKYPfC.png) 
Once you connected to the server via ssh you will be greeted with a message saying do you wish to accept this connection, click yes. 
Your default username is root ( admin) and temporary password is the one given to you via email.
Copy your password and go back to putty. Type in root and hit enter, after you can enter your password by right clicking on your mouse this will paste the password you copied. (this counts for any text you copied) The temporary password you received needs to be changed, retype in the old password and change it to something you prefer having. 
## Step 3.1 Updating your CentOS server. 
Type in

> yum update

After it collected all the files type y for yes to download. The system prompt you with the question to install this. Type in y for yes to continue. Wait for it to finish. 

## Step 3.2 Installing the necessary programs
### 3.2.1 Installing the firewall
Type in 
> sudo yum install firewalld 

To start the firewall service type in:

> sudo systemctl start firewalld

 We also need to enable the firewall services by typing in:
> sudo systemctl enable firewalld

 You can check if the service is running by typing in:
> sudo systemctl status firewalld

 Now you can add the rule to open the ports for phantombot by typing:
> sudo firewall-cmd --zone=public --add-port=25000-25004/tcp –permanent
 
Now we need to reload the changes by typing:
> sudo firewall-cmd –reload

### 3.2.2 Installing the Text Editor
Now we need to install **Nano** software. (Text editor)
To install it type in yum install nano and then type in y and enter to install it.
And you are done with installing Nano.

### 3.2.3 Installing java. 
Type in 
> yum install java-1.8.0-openjdk-headless.x86_64 wget unzip bzip2 

**(Optional)** You can check your java version by typing:
> java -version

### 3.2.4 Installing Fail2Ban.
This service helps to stop people/bots from trying to connect to your server. (just a precaution)
We need to start with installing a required package named Extra Packages for Enterprise Linux EPEL for short. 
Type in: 
> sudo yum install epel-release

Now we can install Fail2Ban 
> sudo yum install fail2ban

Once the installation has finished, we can enable the service. 
> sudo systemctl enable fail2ban

Now we can create the simple config for fail2ban
Type in: 
> sudo nano /etc/fail2ban/jail.local

Press INSERT button so that you can paste the following (Remember you can right click with your mouse to paste in SSH):
```
[DEFAULT]
# Ban hosts permanently :
bantime = -1
# Change 0.0.0.0 to your IP address. You can add more by adding a comma. 
ignoreip = 127.0.0.1/8, 0.0.0.0
Override /etc/fail2ban/jail.d/00-firewalld.conf:
banaction = iptables-multiport

[sshd]
enabled = true
```
After you paste the config you can press **ctrl+x** to exit, press **y** to save, and then press **Enter** to confirm the filename. 
Now  we can restart the service:
> sudo systemctl restart fail2ban

You can check the logs if needed via WinSCP, login as root and go to directory
```
-> root
  -> var
    -> log
         "fail2ban.log."
```

# Step 4 Installing & Setting up Phantom bot. 
###### Source: https://community.phantom.bot/t/centos-7-setup-guide/62 by Zackery.  I've adjusted his source with more details. 
***
##  4.1 Creating a user for phantombot.
**NEVER** run this type of applications as root or root-user! Provide only necessary privileges to keep your server secure!

To create a new user and the corresponding home directory you have to type the following:

> useradd botuser

> passwd botuser

Now you can type in a password you wish to have. Please keep in mind to have a secure password. And nothing simple and easy. 
Now we have created the user and the home directory for him.

## 4.2 Installing Phantombot. 

First, add the bot to the  `wheel`  group
>usermod -G wheel botuser

Then switch to your botuser:

> su  botuser

Switch to the home directory:

> cd /home/botuser

Now we need to download the latest PhantomBot release.
Replace the x.x.x with the latest stable version of phantombot. (In this case it's 3.0.0)
> wget https://github.com/PhantomBot/PhantomBot/releases/download/vX.X.X/PhantomBot-X.X.X.zip

After the download has finished, we have to unzip the files.

> unzip PhantomBot-X.X.X.zip

To make future updates a bit easier, we have to rename the PhantomBot folder.
> mv PhantomBot-X.X.X phantombot

The last thing we need to do is to assign the right privileges to make the launch.sh and launch-service.sh files executable.

> cd phantombot

> chmod u+x launch-service.sh launch.sh

> sudo chown -R botuser:botuser *


Now we are ready to launch PhantomBot. You can run the bot with:
> ./launch.sh

Now PhantomBot should start and you can begin to use it. At this point you can enter the information it asks you for. As a reference, you can check the [Windows guide for the bot account configuration](https://community.phantombot.tv/t/windows-setup-guide/60/1).

After the bot is configured you can press the following keys and follow the rest of the guide.

> Ctrl + C

## 4.3 Setting up a systemd Unit


We need to switch back to root user. 
> su root

Enter password for root and continue. 

We need to create a new file called phantombot.service.
> vi /etc/systemd/system/phantombot.service

Press **INSERT** button to paste the following into the file:

```
[Unit]
Description=PhantomBot
After=network.target remote-fs.target nss-lookup.target

[Service]
User=botuser
Group=botuser
Restart=on-failure
RestartSec=30
ExecStart=/home/botuser/phantombot/launch-service.sh
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
```
Then press **ESC** to stop adding anything else.

Now we can press shift + ; and type in: 
> wq! 

And hit **ENTER** now you have saved the service. 

After this, we have to reload the systemctl and  enable the created file to run at boot as a service.

> systemctl daemon-reload

> systemctl enable phantombot

Now one last thing we need to do, is to make the commands work to start|stop|restart|status PhantomBot.
We have to open the sudoers file to grant our botuser the rights to run these commands.

> visudo

Press **INSERT** so that you can edit the file.

On the end of the file add this (just press **arrow down** till the end):

> botuser ALL=NOPASSWD: /bin/systemctl start phantombot, /bin/systemctl stop phantombot, /bin/systemctl restart phantombot, /bin/systemctl status phantombot

Then press **ESC** to stop adding anything else.

Now we can press shift + ; and type in: 
> wq! 

And hit **ENTER** now you have saved the file you edited. 


Now the user “botuser” should have the rights to run the specific commands to start|stop|restart|status PhantomBot.
Let’s try it!

Switch to our botuser:
> su  botuser

Once you switched to botuser you can run the following commands.

To start the bot: 
> sudo systemctl start phantombot


To stop the bot: 
> sudo systemctl stop phantombot

To restart the bot: 
> sudo systemctl restart phantombot


To check if the bot is running or not. 
> sudo systemctl status phantombot

If you have set up all correct it will start|stop|restart|status PhantomBot.

After PhantomBot is started, you can find your Control Panel under “YOUR-SERVER-IP:25000/panel”.
Make sure you open the following ports on your server:  `25000-25004` See **" 3.2.1 Installing the firewall"** .

# 4.4 Setting up the Backup for every 24 hours.

Switch to botuser 

> su  botuser

Go to the directory of the user. 
> cd /home/botuser

Now you can make a backup folder.
> mkdir -p backup/phantombot

To edit the the schedule for the crontab type in the following:
> crontab -e

And now you can add the following:
> 1 4 * * * umask 0007;/bin/tar --exclude=/home/botuser/phantombot/lib --exclude=/home/botuser/phantombot/web -cjf /home/botuser/backup/phantombot/$(/bin/date +\%Y-\%m-\%d-\%H_\%M_\%S_\%3N).tar.bz2 /home/botuser/phantombot/ >>/home/botuser/backup/backup_phantombot.log 2>&1


Use this to check your crontab afterwards:

> crontab -l

Thats it for to setup the bot via a **VPS** 

# 5 Optionals

### 5.1 Mobile App for the iPhone.
I personally use PiHelper app on the App Store for the iPhone. It's free and you can add simple commands to it. This app is build for Raspberry PI and any linux based system. 

Add your bot info so you can login. You can also test the connection to see if you properly added the information. 
![Image](https://i.imgur.com/opzilkD.png)

Once you have added the server it will look like this.
![Image](https://i.imgur.com/289wNNm.png)

Now you can tap on the server to get to the more detailed section and on the top right there's a drop down menu. 
![Image](https://i.imgur.com/E71ewGm.png)

Now you can add your custom commands like start, restart, stop, status.

![Image](https://i.imgur.com/DeSesAN.png)

Hit save and now you can go back and tap the dropdown menu.
![Image](https://i.imgur.com/arg07o4.png
)

And you are done! Now you can press any command and it will let you know if its started, restarted, stopped or ran the status command. 

I dont own an Android. But if you guys know any decent app or similar to this one let me know and I'll add it to the list. 

### 5.2 Hide your server IP
To hide your ip for free use https://www.noip.com/ , register an account with them and choose your free domain so you can add the server ip to it. It can take some time for the domain to register the IP but mostly happens within 15min. 

Hope this helps anyone interested in creating their own VPS server for phantombot. If there's anything that needs to be added let me know. 

