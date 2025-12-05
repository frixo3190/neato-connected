# neato-connected

# WARNING - this branch is for work in progress text! please go to the main branch!

### What is this?

Repair your Neato Robot Vacuum to be controlled via home assistant after the shutdown of the Neato servers. The scope of this project is to give your robot at least the same functionallity as when you bought it, however as the project is in a development state, the current functionalities include:
- Viewing status
- Start & stop cleaning
- Editing settings (even some hidden settings!)
- Scheduling via an home assistant automation/script

The ability to create, view and edit floormaps so the robot can get the same functionallity with nogo-lines and zones is in the making.

Main card | Settings View
:-------------------------:|:-------------------------:
![ha-card](./pics/esphome/ha-card.png) |  ![ha-card-settings](./pics/esphome/ha-card-settings.png)


**I would like to support all robots where an debug interface, or other controls, is accessible, but since I only have a D3, I can only test on that one. If you have another robot, please open an discussion so we can verify that it works or add support for it!**

As far as I know, only the D3, D4, D5, D7 and D7 has the firmware `4.5.3` and currenly the config is based on that so the robots that should work with that firmware is as follows:
- Confirmed working: **D3, D5, D7**
- Should work, need confirmation: **D4, D6** 

If you have another Neato robot, please open an issue here on github so we can add support for it, however we might need your help to know what needs to change!

**Trickier robots**
- D8 (probably D9, D10) - These robots use a compleatly different board, chip and firmware, and because the debug interface seams to be behind a password lock, this cannot be controlled directly.

#### How-to connect
Sadly to be able to repair your neato vacuum you **need to access an USB port or debug pins** to be able to connect to the debug interface. The current methods are:

Drill a hole in the bumper to access the debug port | Open the robot and bend pins or solder to debug connector
:-------------------------:|:-------------------------:
![cables-via-bumper](./pics/d3/cables-via-bumper.jpg) ![d3-install-outside](./pics/installs/d3-install-outside.png) |  ![d7-install](./pics/installs/d7-install-serial.png) ![d7-install-esp](./pics/installs/d7-install-esp.png)

I understand these methods are hard or destructive, I am currently investigating the possibility of accessing the debug interface using less extreme methods, however so far I have come up empty handed.

### Getting started!

If you havn't heard of home assisnat yet then this is an awesome time to learn about it! It is an open source home automation tool that puts local control and privacy first. Read more about them on their [website](https://www.home-assistant.io/) and try their [live demo](https://demo.home-assistant.io) if you want! There is a lot of great guides and information about home hassistant on youtube and their forums! They also have some amzing guides on their [site](https://www.home-assistant.io/installation/) to get an home assistant installation going. If you don't feel like setting up hardware 1 If you have any questions or problems, don't hesitate to ask for help here in the "issues" section, on our discord or the home assistant [help](https://www.home-assistant.io/help/) page.

First of all you should start thinking about how you want to keep your robot connected, but if you don't want to commit to opening your robot or drilling an hole in the bumper yet, you can always take the bumper off and connect an esp device to the robot and just run it via Home Assistant. If you don't have an Home Assistant installation you can try to control it via the [web server interface](./ha-images.md#webserver-interface), verify that it will work and then if you want, setup home assistant and use it though that. If you go down this route, please check [here]()

{{

    you can skip step 2 and 3, but this will require you to download an precompiled image for your

}}


Overview of steps:
1. Setup HACS and install required add-ons
2. Import the config to ESPHome
3. Flash the image to your ESP device
4. Connect the ESP device to your robot
5. Setup the Home Assistant card
6. Enjoy your locally connected robot!


## Step 1

We need to install certain plugins and addons to the home assistant installation to use all the features of this project.

### Home assistant plugins
Donwload the "Esphome" plugin from Setting --> Add-ons --> Add-on Store --> install the "ESPHome Device Builder"

### HACS
If you don't already have hacs, follow their guide to set it up: https://www.hacs.xyz/docs/use/. Once you have HACS setup, open it and install the following addons:
- button-card
- browser-mod

After installing, it will ask you to reload the page, please do so.

## Step 2

### ESPHome Secrets
Open the ESPHome Builder and click the "Secrets" in the top right. Make sure your secrets include at the minimum this:
```yaml
# Generate at https://esphome.io/components/api/#api-key
neato_vacuum_api: "<API_KEY>"
# Generate at https://bitwarden.com/password-generator/
neato_vaccum_ota: "<OTA_PASSWORD>"

# Your Wi-Fi SSID and password
wifi_ssid: "<WIFI_SSID>"
wifi_password: "<WIFI_PASSWORD>"
```

Once you have filled this file with your values, save it, and make sure to never share this file if asking for support etc.

If you want to add more devices, best practice is to set the api key and ota password in your secrets file. Your wifi password and ssid should also be kept here. Since the esp device will be strapped to, or inside the robot OTA (Over the air updates) is quite important for this use case.

### Config file
Once back at the ESPHome main page, click the big green button in the bottom left to add a new device. Read the information, but for now, click "Continue" and either import the [`neato_vacuum.yaml`](..) file, or start with an empty configuration.

**The folloing two steps might be hard to do, feel free to ask for help in the discord or discusstions.**

Now, since you may be using a different board then I am, and this might get complicated. You will need to find out what platform to set. Here is the list of [availible platforms](https://esphome.io/components/#supported-microcontrollers). 

Next, you will need to figure out which pins to use, once again this is highly dependent on your board, both based on which ones you can easily connect too, but also what is supported on your platform. In some cases, the pins labeled `TX` and `RX` cannot be used, as these are used to upload the firmware, you will need to find GPIO pins that support using using UART, on the ESP32 many of the GPIO pins can be used.

## Step 3





## Acknowledgements

- @Fabian Ullrich, Jiska Classen, Johannes Eger and Matthias Hollick from Secure Mobile Networking Lab
    - [Security and Privacy for IoT Ecosystems](https://tuprints.ulb.tu-darmstadt.de/handle/tuda/4937)
    - [Vacuums in the Cloud:
Analyzing Security in a Hardened IoT Ecosystem](https://www.usenix.org/system/files/woot19-paper_ullrich.pdf)
    - And all of their work on these robots, including talks etc!
- [@jeroenterheerdt](https://github.com/jeroenterheerdt) for testing, reviewing and the original [neato-serial](https://github.com/jeroenterheerdt/neato-serial)
- [@algaen](https://github.com/algaen) for the info about the D8 (D9, D10?) robots
- [@tomwj](https://github.com/tomwj) for testing and pictures installing it internally in a D7


