

## Serial interface
There seams to be two different serial interfaces on the robot. On you can connect via the usb port where the dustbin resides, and blocks. The other is as a JST connector? that you can connect to via a TTY adapter. 

On the Neato D3, looking at the robot from the front, there is 4 pins, they are from left to right;
1. RX
2. Not sure, think 3.3V (it has 3.3V on it)
3. TX
4. GND

Connecting to a USB TTY Adapter you only need to connect ground and RX to the robot TX to the output, to be able to send commands, you connect the TX to the robot RX. My hope is that the 2nd pin is 3.3V allowing us to power an esp32 or similar to send commands via the serial interface.

Connecting to the serial interface with screen:
`screen /dev/ttyUSB0 115200`

Shows some logs of the robot starting up, including a boot menu if the robot was fully shut down and you press enter twice.

The serial interface on the `3.2.0` version: (the `4.5.3` version I will add later)
```
ARCHES Board (04.0x90c973a5)
Press enter twice within the next 2 seconds for boot menu
Enter Key Detected!
Enter Key Detected!
**Commands:

Press 'M' to load IFS from main image flash partition
Press 'F' to load IFS from factory image flash partition
Press 'X' for serial download, using XModem-1k
Press '1' for XModem-1k download at 1Mb/s
Press '3' for XModem-1k download at 3Mb/s
Press 'S' to scan existing memory without download
-- Compressed Image Mode ('c' to toggle)--
initialize_sdmmc finished. sdmmc.sdmmc_pbase=481D8000



Booting Main Image
```

If it just was sleeping or not fullt shut down.
```
ARCHES Board (04.0x90c973a5)

Not factory boot...
initialize_sdmmc finished. sdmmc.sdmmc_pbase=481D8000



Booting Main Image
```

Then it starts up, you can now enter commands! The commands listed by the `Help` command are as follows:
```
Help - Without any argument, this prints a list of all possible cmds.
With a command name, it prints the help for that particular command
Clean - Starts a cleaning by simulating press of start button.
ClearFiles - Erases Black Box, and other Logs
DiagTest - Executes different test modes. Once set, press Start button to engage. (Test modes are mutually exclusive.)
GenerateRobotLinkCode - Generate and send robot linking code to server.
GetConfiguredWifiNetworks - Get the list of configured wifi networks.
GetRobotLinkCode - Get the robot linking code
CancelRobotLink - Cancel link request.
SetNTPTime - Set system time using the NTP servers (WIFI must be up for this to work)
GetAccel - Get the Accelerometer readings.
GetAnalogSensors - Get the A2D readings for the analog sensors.
GetButtons - Get the state of the UI Buttons.
GetCalInfo - Prints out the cal info from the System Control Block.
GetCharger - Get the diagnostic data for the charging system.
GetDigitalSensors - Get the state of the digital sensors.
GetErr - Get Error Message.
GetLDSScan - Get scan packet from LDS.
GetMotors - Get the diagnostic data for the motors.
GetSensor - Gets the sensors status ON/OFF (Wall Follower and Ultra Sound Only)
GetTime - Get Current Scheduler Time.
GetVersion - Get the version information for the system software and hardware.
GetWarranty - Get the warranty data.
GetWifiInfo - Get a list of available wifi networks.
GetWifiStatus - Get the current status of the wifi.
GetUserSettings - Get the user settings.
GetUsage - Get usage settings
PlaySound - Play the specified sound in the robot.
SetBatteryTest - Sets California Energy Commission 10-CFR-430 Battery Charging System Test mode.
SetButton - Simulates a button press.
SetFuelGauge - Set Fuel Gauge Level.
SetIEC - Sets the IEC Cleaning Test parameters
SetLCD - Sets the LCD to the specified display. (TestMode Only)
SetLED - Sets the specified LED to on,off,blink, or dim. (TestMode Only)
SetLDSRotation - Sets LDS rotation on or off. Can only be run in TestMode.
SetMotor - Sets the specified motor to run in a direction at a requested speed. (TestMode Only)
SetSystemMode - Set the operation mode of the robot. (TestMode Only)
SetTime - Sets the current day, hour, and minute for the scheduler clock.
SetUserSettings - Sets user settings
SetUsage - Sets usage settings
SetWifi - SetWifi variables
TestMode - Sets TestMode on or off. Some commands can only be run in TestMode.
Upload - Uploads new program to the robot.
```

Now the commandline is not case-sensetive and it also checks if the string you written is part of a command or parameter for a command. If it is an only match it will "autocompleage" the command for you, if multiple matches then it will list what it could be. Thanks to this functionality I have discovered some commands that is not documented in the `Help` command:
```
GetActiveServices
GetLoggingType
GetState
```

#### Differences I found in 3.2.0 and 4.5.3

3.2.0 has more options for `SetSystemMode`:
```
SetSystemMode - Set the operation mode of the robot. (TestMode Only)
    Shutdown - Shut down the robot. (mutually exclusive of other options)
    Hibernate - Start hibernate operation.(mutually exclusive of other options)
    Standby - Start standby operation. (mutually exclusive of other options)
    PowerCycle - Power cycles the entire system. (mutually exclusive of other options)
```


#### Shutdown the robot fully
```
TestMode on
SetSystemMode Shutdown
```

(This could be written as `t on` and `setsy sh`)

