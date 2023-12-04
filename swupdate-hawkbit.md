## Steps to Configure Hawkbit

Step 1 :-

- Open the terminal and run the command given below. This command will start a hawkbit server for you at the port 8080.

```
sudo docker run -p 8080:8080 hawkbit/hawkbit-update-server:latest
```

Step 2 :-

- Now go your favorite browser. Run the following command in your browser,
  Your_ip:8080 (like 192.168.xxx.xxx:8080).
- If you don’t know your IP, simply run “ifconfig” command in your terminal and it will show you network configurations

![1](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/a16d73e9-2161-4eb9-bea1-502bee8c6ea5)


Step 3 :-
- Now, you will see the below screen in your browser. Simply use admin as username and password.

- You are officially inside the Hawkbit server. You can now configure Hawkbit to send updates to your remote embedded devices.


![2](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/41b97f14-f97b-4ab8-86a5-3fd8eed847f4)


Step 4 :-

- First of all, you need to define authentication configuration for receiving updates from Hawkbit.

- Go to System Config tab in the left pane of the server. It will show you 4 types of authentications
  for target devices to receive updates.The most common authentications used are gateway authentication
  and target authentications.

- Copy gateway token by  selecting
  'Allow a gateway to authenticate and manage multiple targets through a gateway security token'
  this token helps to connect the device to hawkbit server.

![3](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/0b2730dd-9827-45f8-bced-39136ea305ca)

- Enable 'Allow targets to authenticate directly with their target security token'

- Select your desired 'Polling Configuration',to make board polling time to Hawkbit server.

- Don’t forget to press save button at the bottom .

command run from Board to connect the hawkbit server with help of swupdate command which
uses gateway token :-

```
root@neu6b-v1-5: swupdate -H neu6b-v1:1.0  -f /etc/swupdate.cfg -l 5 -u '-t DEFAULT -u http://192.168.0.105:8080 -i neu6b-v1 -g 883726480bf128a0f8985344b021464c'

```

## Register Board to Hawkbit Server

We can add the Board details to the Hawkbit Server in the Targets section in two ways :-

1. Before Build
       (or)
2. After  Boot

1) Before build :-

- Add the required configurations of swupdate in meta-openaia and the build the yocto setup  .
- These helps to connect the board to hawkbit server and poll for the update after first boot itself.

Required changes to be done in meta-openai layer :-

In recipes-support/swupdate/swupdate/neu6b-v1-5.10-swu/swupdate.cfg :-

- Modify the local host  url , update the local host ip address of your local host.

In recipes-support/swupdate/swupdate/neu6b-v1-5.10-swu/01-swupdate-args :-

- To SWUPDATE_SURICATTA_ARGS , add the required board details and update the gateway token which you got in ' Steps to Configure Hawkbit '

Eg:- SWUPDATE_SURICATTA_ARGS="-i neu6b-v1-${DEVICE_ID} -g 44f7e0fc67919b3144f3f07c404139d9"

- To SWUPDATE_ARGS , for -H field , add the board hardware configuration details and version ,as per sw-description file
  which is present in recipes-extended/images/update-image/neu6b-v1-5.10-swu/sw-description


2) After Boot :-

Add the required configurations of swupdate after the boot , save the changes and reboot the board to update and connect

Required changes to be done after boot :-

- Update the local host url in /etc/swupdate.cfg in suricatta  section.

- Update the required board details and  gateway token to SWUPDATE_SURICATTA_ARGS field in 01-swupdate-args
  file which is present in /etc/swupdate/conf.d/

- Update the board hardware configuration details and version to SWUPDATE_SURICATTA_ARGS field in 01-swupdate-args
  file which is present in /etc/swupdate/conf.d/

After following the above steps,Now boot the Board,we can see a target device will be created on the Hawkbit server, as shown below.

![4](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/716b88ae-d8a2-4fdf-8bbc-aafc0a71fbc9)


## Upload the Swupdate Image (.swu)

When we push the latest change , meta-openaia layer , automatically yml builds the yocto setup and upload the latest
update-image(.swu) file of board to Hawkbit server .

Note :- Prior to push the latest change to meta-layer , we should run  hawkbit server as per  steps followed by 'Steps to Configure Hawkbit '
and github runner setup in our local host , before pushing our latest change.

To run Github runner setup with self hosted follow the below link:-

https://github.com/manojams/meta-openaia/blob/kirkstone/runner-self-host-setup-README.md

After running the Github runner setup and hawkbit server , push the latest change to meta layer , yml file builds the yocto 
setup in our host  and uploads swu file to Hawkbit server.

After push latest commit on meta-openaia , we can see latest swu file in software module section of Hawkbit panel by yml file.

![5](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/376ae491-bf2e-4058-b115-c5a5f006c965)


##  Update the Board

* Distribution Management :-

- Go to the Distributions Management tab from the left selector
- Create a Distribution of type "OS with app(s)", named DISTRO of version 1.0
- Drag and drop the software module on the right pane onto the DISTRO distribution on the left pane

Create Distro :-

![6](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/3afd2ff9-4c6f-439e-9088-eb43565ecece)


Assigned swu file to Distro:-

![7](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/d5bc502a-7e97-464d-a8c9-ebe06a1a0160)

* Target Filters :-
- Go to the Target Filters tab from the left selector
- Create a new filter named "Default filter" and use a generic filter such as "name==*"

![8](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/5c6ad04e-4032-4471-b0be-b8d23e267826)

* Rollout :-
- Go to the Rollout tab from the left selector
- Create a new rollout campaign named "Neu6b-v1". Select the  distribution set, the default filter and enter 1 in the "Number of groups" field.
  You should see stats of deployment appearing.

create new Rollout :

![9](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/c94f9791-5d71-4961-b1a2-08ebdc231415)


Rollout Management :-

![10](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/52fc49d2-031e-4566-ac1f-a768924bf98b)


* Applying the update :-

- Press the "Play" icon on the right side of your rollout campaign to activate the deployment.

At this point, you can either wait for a while, so that SWUpdate polls for updates and finds the new deployment campaign or kill and restart SWUpdate.
You should find detailed information on the installation process in the standard output of SWUpdate.

![11](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/0f8d467b-b59e-4a55-a4b9-846f1b182518)


* check update is running in Board :-

* sample swupdate log of swupdate running in Board :-

```shell
* Mark bundle as not supporting multiuse
[TRACE] : SWUPDATE running :  [extract_file_to_tmp] : Found file
* HTTP 1.1 or later with persistent connection
[TRACE] : SWUPDATE running :  [extract_file_to_tmp] :   filename sw-description
< HTTP/1.1 200 
< X-Content-Type-Options: nosniff
< X-XSS-Protection: 1; mode=block
[TRACE] : SWUPDATE running :  [extract_file_to_tmp] :   size 1812
< Cache-Control: no-cache, no-store, max-age=0, must-revalidate
< Pragma: no-cache
[DEBUG] : SWUPDATE running :  [parse_cfg] : Parsing config file /tmp/sw-description
< Expires: 0
< X-Frame-Options: DENY
< Content-Length: 0
< Date: Mon, 25 Sep 2023 06:44:10 GMT
< 
* STATE: PERFORMING => DONE handle 0x7f8c001250; line 2464 (connection #0)
[TRACE] : SWUPDATE running :  [get_common_fields] : Version 0.1.0
* multi_done: status: 0 prem: 0 done: 0
* Connection #0 to host 192.168.0.105 left intact
* Expire cleared (transfer 0x7f8c001250)
[TRACE] : SWUPDATE running :  [channel_log_effective_url] : Channel's effective URL resolved to http://192.168.0.105:8080/DEFAULT/controller/v1/neu6b-v1-ce:60:71:de:f1:e7/deploymentBase/1/feedback
[TRACE] : SWUPDATE running :  [parse_hw_compatibility] : Accepted Hw Revision : 1.0
[TRACE] : SWUPDATE running :  [channel_log_reply] : Channel operation returned HTTP status code 200.
[TRACE] : SWUPDATE running :  [parse_reply] : Got channel reply: 
[TRACE] : SWUPDATE running :  [_parse_images] : Found compressed Image: core-image-full-cmdline-neu6b-v1-5.10-swu.ext4.gz in device : /dev/mmcblk1p9 for handler raw
[TRACE] : SWUPDATE running :  [_parse_scripts] : Found Script: emmcsetup.lua
[TRACE] : SWUPDATE running :  [_parse_bootloader] : Bootloader var: bootcount = 3
[TRACE] : SWUPDATE running :  [_parse_bootloader] : Bootloader var: upgrade_available = 1
[TRACE] : SWUPDATE running :  [parse] : Number of found artifacts: 1
[TRACE] : SWUPDATE running :  [parse] : Number of scripts: 1
[TRACE] : SWUPDATE running :  [parse] : Number of steps to be run: 3
[TRACE] : SWUPDATE running :  [check_hw_compatibility] : Hardware neu6b-v1 Revision: 1.0
[TRACE] : SWUPDATE running :  [check_hw_compatibility] : Hardware compatibility verified
[DEBUG] : SWUPDATE running :  [preupdatecmd] : Running Pre-update command
[TRACE] : SWUPDATE running :  [extract_files] : Found file
[TRACE] : SWUPDATE running :  [extract_files] :         filename emmcsetup.lua
[TRACE] : SWUPDATE running :  [extract_files] :         size 174 required
[TRACE] : SWUPDATE running :  [extract_files] : Found file
[TRACE] : SWUPDATE running :  [extract_files] :         filename core-image-full-cmdline-neu6b-v1-5.10-swu.ext4.gz
[TRACE] : SWUPDATE running :  [extract_files] :         size 57071162 required
[DEBUG] : SWUPDATE running :  [channel_callback_xferinfo] : Downloaded 1% (557 of 55736 kB).
[DEBUG] : SWUPDATE running :  [channel_callback_xferinfo] : Downloaded 2% (1116 of 55736 kB).
[DEBUG] : SWUPDATE running :  [channel_callback_xferinfo] : Downloaded 3% (1674 of 55736 kB).
[DEBUG] : SWUPDATE running :  [channel_callback_xferinfo] : Downloaded 4% (2230 of 55736 kB).
[DEBUG] : SWUPDATE running :  [channel_callback_xferinfo] : Downloaded 5% (2787 of 55736 kB).
[DEBUG] : SWUPDATE running :  [channel_callback_xferinfo] : Downloaded 6% (3344 of 55736 kB).
```


- After applying swupdate , Board will get booted with altbootcmd

```shell
U-Boot 2023.07 (Sep 05 2023 - 16:00:14 +0000)

Model: Edgeble Neu6B IO Board
DRAM:  4 GiB (effective 3.7 GiB)
Core:  288 devices, 21 uclasses, devicetree: separate
MMC:   mmc@fe2c0000: 1, mmc@fe2e0000: 0
Loading Environment from MMC... OK
In:    serial@feb50000
Out:   serial@feb50000
Err:   serial@feb50000
Model: Edgeble Neu6B IO Board
Net:   No ethernet found.
Saving Environment to MMC... Writing to MMC(1)... OK
Warning: Bootlimit (3) exceeded. Using altbootcmd.
Hit any key to stop autoboot:  0 
```

* Pause and cancel swupdate in Hawkbit server :-

![12](https://github.com/manojams/meta-fleet-readthedocs/assets/97679353/02982a2e-65db-4f49-9b98-60c7cbdf27dc)


cancel the running action of swupdate in action history in Deployment section.


```
## Maintainers

* Jagan Teki `<jagan@edgeble.ai>`
