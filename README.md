# neato-connected

[I will add pictures later... there is probably also some stuff i spelled wrong, will go about to fix that later]

My findings about the Neato D3 Connected, however should be same/very similar for any Neato connected robot.

I found an old Neato D3 that was broken, the left wheel didn't spin so I opened it up and realized the black cable for the left motor was not connected, it had ripped out of the JST connector. I ordered some new JST connectors since I didn't have any and because I didn't have the correct crimp I soldered an already crimped cable that I got with the set to the cable and connected it to a new JST connector. One connected back to the board it worked perfectly, ran a couple of cleanings in my apartment and it works very well, the left wheels gears is starting to wear off so I am thinking of 3d printing some new ones.

When I got the robot I had firmware `4.5.3_189`, while playing around with it I reset it to factory, so I will need to upgrade it later on, however at the time of writing I don't have an USB OTG cable. Since you always can upgrade to `4.5.3_189` I will be basing this project of that version, and that is that all commands etc will be using unless otherwise noted. The factory firmware on my robot is version `3.2.0_305` and would the other other version I will mention from time to time.

Here is the different firmware images availible:
https://github.com/RobertSundling/neato-botvac

I will be trying to upgrade using the self-signed certificate with a custom date, but I will probably also make a fake ntp server into this project so that you can install using the original certificate.

Lets clearify a quick thing, I think this is obvious to many, but since I myself got confused lets write it down. The front of the robot is where the bumper is, back is where the charger and excuaset is. If we look at the robot from a top down view seeing in the way that the robot is going to drive forward, the right side is where the button and blinky lights are. Left is the other side.

Once the bot was working, my journey began. I have split up the different parts into different documents, find them below:
- [Setup network](./setup-network.md)
- [Serial interface](./serial.md)

## Serial connection via ESPHOME
The suspected 3.3v pin is 3.3v and I have been able to keep an esp32cam connected and running the configuration at [esphome.yaml](./esphome.yaml)

Currently this is mainly a POC but I am working on making it an fully working controller for the robot. Currently the lamdba function is probably still very inefficient and needs cleanup after the LLM changed it. 