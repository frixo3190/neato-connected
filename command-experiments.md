# Experimentation with commands

If all of these experiments prove successful, the robot would be able to be driven via the serial interface fully, meaning a custom program to drive it via serial and use the lidar data to know where to drive would be possible. 

Conditions needed to make a ROS2, slam_toolbox cleaning possible, and they cannot interfere with each other:
- Rotate LDS
- Get LDS Scan periodically
- Drive
- Stop at any time, one or two wheels
- Change direction etc
- GetDigitalSensors/GetAnalogSensors?
- Get info about other sensors/state


I will need to do more experimatation on this part; but this is a command to drive forward: `SetMotor RWheelDist 3000 LWheelDist 3000 Speed 60`

Stop the wheels: `SetMotor LWheelDisable RWheelDisable`


Also, sometimes the robot says something about that it won't fall for that again (forgot to copy the message...), not exactly sure what causes it, I think it has to do if you try to send multiple commands on the same line or something? but will need to look into that I guess?

