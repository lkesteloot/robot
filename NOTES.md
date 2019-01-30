
# To do

* Read about this beautiful arm:
    * https://hackaday.io/project/19968-walter
* Read this about motor control and PID:
    http://stratifylabs.co/embedded%20design%20tips/2013/10/15/Tips-Motor-Control-using-PWM-and-PID/
    https://www.reddit.com/r/ControlTheory/comments/4j0pyk/help_how_can_i_find_the_transfer_function_of_an/
* Investigate the online course [Robot Mechanics and Control, Part 1](https://www.edx.org/course/robot-mechanics-control-part-i-snux-snu446-345-1x#!)
* Investigate the online course [Underactuated Robotics](https://www.edx.org/course/underactuated-robotics-mitx-6-832x)
* Investigate [CS235](https://www.youtube.com/user/StanfordCS235/videos)
* Re-read everything below. Re-read all resources. See all YouTube videos
  again. Re-read H-bridge secrets, especially, including the last two pages
  that I skipped last time.
* Check [Reddit thread](https://www.reddit.com/r/ControlTheory/comments/3gkfyd/i_need_help_on_controlling_an_arm/)
    * Suggests 2 kHz update rate.
    * Decompose torque into gravity + acceleration. Make the gravity one feedforward
        and use feedback for second.
* Read through all blog posts for the [power supply](https://hackaday.io/project/4154-bench-power-supply).
* Watch control systems YouTube videos.
    * [YouTube](https://www.youtube.com/user/ControlLectures)
    * [Konoz](https://konoz.io/courses/54d3096aef490c2607a7a660/components/YOUTUBE-oBc_BHxw78s)
* Can we find an IC that converts current to something measurable by the Arduino so that
    we can shut things off if the current goes up too much?
    * ACS710
    * Check how the [Arduino Motor Shield](https://www.arduino.cc/en/Main/ArduinoMotorShieldR3) does it.
        * [Schematic](https://www.arduino.cc/en/uploads/Main/arduino_MotorShield_Rev3-schematic.pdf)
        * They use an L298, which has current sensing pins.
            * See breakout board elsewhere in this doc.
    * [Current sensing in power steering](https://www.maximintegrated.com/en/app-notes/index.mvp/id/5073)
* Figure out how I'll control all this.
    * Mac OS to Ubuntu in VirtualBox to Arduino to hardware?
    * i2cproxy?
    * VirtualBox is pretty slow.
    * Arduino Zero might be capable enough.
    * [pcDuino3B](https://www.sparkfun.com/products/13707)
    * [Intel Edison](http://www.intel.com/content/www/us/en/do-it-yourself/edison.html)
    * [MinnowBoard MAX](http://www.minnowboard.org/meet-minnowboard-max/)
    * [Beaglebone Black](http://syrianspock.github.io/embedded-linux/2015/09/13/my-beaglebone-black-setup-for-embedded-and-robotics-development.html)

# Goals

* To learn:
    * Statics
    * Dynamics
    * Control theory
    * Electronics
* To build:
    * Robot arm
    * Control system
    * Vision system

# ROS

* http://www.ros.org/

# Misc notes to remember

* Most things in Actobotics use 6-32 bolts. These require a 7/64 hex key.

# Things learned

## H bridge

* Explanations:
    * [Wikipedia entry](http://en.wikipedia.org/wiki/H_bridge)
    * [H-bridge secrets](http://modularcircuits.tantosonline.com/blog/articles/h-bridge-secrets/)
        * [H-Bridges - the basics](http://www.modularcircuits.com/blog/articles/h-bridge-secrets/h-bridges-the-basics/)
            * Diodes are there to handle current in brief time when transistors are switching.
        * [Sign-magnitude drive](http://modularcircuits.tantosonline.com/blog/articles/h-bridge-secrets/sign-magnitude-drive/)
            * One bit to control direction and the other PWM.
            * When off part of PWM, top half is closed loop (or bottom half) to
              allow current to keep going.
            * Current can reverse itself during ripple, damaging power supply.
              Fix with capacitor across entire bridge.
            * Faster PWM means smaller capacitor. 20kHz. See math.
            * Braking is hard (regenerative or dynamic). Might need braking if
              external torque (weight of arm?) pushes motor.
        * [Lock anti-phase drive](http://modularcircuits.tantosonline.com/blog/articles/h-bridge-secrets/lock-anti-phase-drive/)
            * Always driving one direction or another in PWM. Alternating directions.
            * Many of the same problems as sign-magnitude drives.
        * [Asynchronous sign-magnitude drive](http://modularcircuits.tantosonline.com/blog/articles/h-bridge-secrets/asynchronous-sign-magnitude-drive/)
            * Only close one switch in the off PWM state and go through the diode.
            * Doesn't need regenerative braking.
            * Diodes generate a lot more heat because of their voltage drop.
            * More complex analysis.
        * [MOSFETs and catch diodes](http://modularcircuits.tantosonline.com/blog/articles/h-bridge-secrets/mosfets-and-catch-diodes/)
            * Recommends 20k to 40k PWM frequency.
            * Assumes MOSFETs. Blows off BJTs.
            * Want very low R_dson (internal resistance) in MOSFET to avoid heat.
            * N-channel MOSFETs have much lower R_dson and faster switching speeds.
            * So good for low-side.
            * But for high-side the gate can't always be higher than source.
              Might mean higher than V_bat. Also gate can't be too high or will
              blow MOSFET. So must be variable. (If you use N-channel for high
              side, it will work briefly, then stop working when motor engages,
              then work again, etc., pulsing the motor.)
            * Easier to go with P-channel MOSFET for high side. Source goes to
              V_bat and gate must be 3-12V lower than that. Higher resistance
              but okay for small applications. Not sure if ours counts as
              small.
            * Power dissipation of transistor is hard to figure out, but one
              example for a TO-220 is 1.5W without heat sink and 9W with.
            * Gives FDP55N06 as example (see below).
            * But lower R_dson means larger packages, which means bigger gates,
              which means more gate capacitance, which means longer to drive
              the gate one way or the other, which means lots of power use
              during transition. Not really a problem below 40 kHz PWM.
            * Make sure that Vf of diode is lower than that of MOSFET. In fact
              check whether the MOSFET's diode isn't just good enough to be
              used as-is, replacing the diodes. For STP16NF06L that's 1.3V
              and capable of handling the currents.
            * Diodes can take a little while to turn on (because of the
              capacitive effects of their leads), so there's a tiny duration
              during which the current has nowhere to go and voltages grow too
              high. To fix this, put a capacitor across motor to absorb it. He
              doesn't say what value to use.
            * Prefer Schottky diodes because they have a shorter turn-on delay.
        * [H-bridge drivers](http://modularcircuits.tantosonline.com/blog/articles/h-bridge-secrets/h-bridge_drivers/)
            * How do we drive the gates in the circuit?
            * Can use CMOS (pair of PMOS and NMOS FETs) to drive the output up
              or down. Fast because small capacitance (because small device),
              and high R doesn't matter and actually protects against shoot-through.
              (E.g., 74AHCxxx)
            * Can calculate switching time of power MOSFET by using gate capacitance
              and source current. Want that to be about 1% of switching time, which
              for 20 kHz is about 200ns, which is easily done by AHC components.
            * Could use nothing to drive the FETs. Just hook them up to the
              microcontroller.  But 3v3 is probably not enough -- would want 5V
              to get all the current we need through the motor. Also might not
              have enough current to drive the FETs fast enough. Arduino has 5V
              I/O pins that can provide 40mA. For a sample capacitance of 350pF
              and the formula t = V*C/I, we get 43ns.
            * If that's not enough current (but okay voltage), use a CMOS buffer.
              Can even gang up e.g., six buffers from 74AHC04 together.
            * If voltage is wrong, can use NFET with a pull-up resistor on the
              drain to the high voltage. But since the pull-up must be high,
              that reduces current, which means the switching time will be
              slower, but asymmetrically (because only for on), which makes
              shoot-through more likely. Can fix this by adding another
              CMOS buffer at the output to make current symmetric.
            * To drive high-side, need Vbat and Vbat - 5V. To accomplish this,
              power the drive using the same voltage the bridge is on (Vbat).
              This probably won't work for 12V. Not exactly sure about this.
            * Skipped section on high-side NMOS and bootstrapping.
        * [H-bridge control](http://modularcircuits.tantosonline.com/blog/articles/h-bridge-secrets/h-bridge-control/)
            * Have not read yet.
        * [Safety features](http://modularcircuits.tantosonline.com/blog/articles/h-bridge-secrets/safety-features/)
            * Have not read yet.
    * [Afrotechmods video](https://www.youtube.com/watch?v=iYafyPZ15g8)
        * 6V - 15V, up to 2A.
        * Puts 1000uF across power supply.
        * Uses high-side P-channel MOSFET.
        * Connects gates together on each side, with 1kΩ to ground.
        * Adds 47Ω to power.
        * Doesn't worry about shoot-through while both are on.
        * No external diode, but maybe relies on internal diode in MOSFET.
        * Doesn't explain how to hook up to 5V microcontroller.
    * [Lawrence Tech University](https://www.youtube.com/playlist?list=PL30C02F65B2D5C320&feature=plcp)
        * Controlling robot arm.
        * Explains H-bridge really well, including how to hook up 12V system to 5V controller.
        * Uses SN754410.
        * Uses .1uF across motor. In fact also connects two of them to motor housing.
        * Uses 10kΩ to microcontroller pins, in case something goes wrong with motor system.
        * Adds 100kΩ to ground from enable pin to handle microcontroller boot-up.
    * [PyroElectro](http://www.pyroelectro.com/tutorials/sn754410_dual_motor_control/)
        * Uses SN754410.
        * See [schematic](http://www.pyroelectro.com/tutorials/sn754410_dual_motor_control/img/schematic.png).
        * Puts 10kΩ between chip and drivers.
        * Does not put caps on power (except large one 47uF outside voltage regulator).
* Hardware:
    * [Motor driver chip](https://www.sparkfun.com/products/315) for $2.35.
    * [TIP102 and TIP107](http://www.st.com/web/en/resource/technical/document/datasheet/CD00001234.pdf)
        * Darlington transistors (two in series to amplify more).
        * 15 A on collector.
        * Built-in diode protection.
        * One guy (Fidonet guy) said never to use these -- MOSFETS are better in every way.
* Notes:
    * Four switches to control direction of DC motor.
    * Must make sure you don't get shoot through. Turn off one transistor before turning
      on the other.
    * Can be used with PWM to vary the speed of the motor.
        * PWM doesn't work well below 25%. (That's true of mine, but where did I get this note? Is it always true?)
* Our large motor is 1 Ohm.
* Questions:
    * Some use PNP and NPN and some use only NPN.
        * Looks like NPN uses less power (lower resistance).
        * The PNP model "prevents short circuits" and "optimize current flow", whatever that means.
    * Should we use a Schottky diode?
    * Should we have fuse?
        * Suggested by Afrotechmods if we don't have current-limiting power
          supply. He suggests 3A fuse on positive side of supply.
    * How to hook up PWM of SN754410? Options:
        * Send PWM to enable pin. Then either use two digital pins for control (direction)
          or use an external inverter.
            * Used in [this circuit](http://www.societyofrobots.com/member_tutorials/node/164).
                * Says 5 kHz max.
                * Uses 10k pull-up resistors on control pins.
                * Uses transistor to invert second control pin.
        * Pull enable high, set one direction pin to a digital pin, and the other to a
          PWM pin. If direction = 0, then PWM goes from 0 (off) to 255 (fast). If direction = 1,
          then PWM goes from 255 (off) to 0 (fast). This is called sign magnitude. Not
          sure how smooth we can make the turn-around.
        * Pull enable high, then use external inverter for other pin. When PWM = 128 the
          motor doesn't turn (gets equal of each direction). Go higher or lower to
          move in one or the other direction. This is called locked antiphase. It halves
          the PWM resolution. Does this use a lot of current when idle?
    * Need we turn Enable off in SN754410 when changing directions? One post said yes.

## Voltage regulators.

* LM78xx series can source 1A.
* xx is voltage.
* Max temperature is 125°C. Use heat sink.
* Put .1uF between output and ground. Also maybe .33uF between input and ground.
* See chapter 19 in Encyclopedia of Electronic Components.
* Buck converters are more efficient.

## Heat sinks

* The thermal resistance describes how much resistance there is to heat flow.
* The device itself will specify the internal resistance (from the inside of the chip to the
  metal part).
* Add to that other resistances, like the heat sink one.
* Add also the resistance between the device and the heat sink. Saw 0.25°C/W in the
  [SparkFun tutorial](https://www.sparkfun.com/tutorials/314). Can be higher if just
  screwed together, or zero if there's thermal grease.
* Add 25°C for ambient temperature.
* Then see if this exceeds the max temperature of the device.
* Only use the heat sink's thermal resistance plus ambient temperature to figure out
  temperature of heat sink itself.
* Basically math works outside-in.
* Jameco has a kit of screws. Heat sink itself is sold separately.

# 3D printing

* OpenSCAD
    * [Mounting plates](https://github.com/createthis/DIYServo/tree/master/OpenSCAD)
        * Includes one for AS5045 board.

# Parts

* NPN, PNP BJT:
    * 2N2904, 2N3906: 200mA
    * 2N2222A, 2N2907A: 600mA
    * ZTX1049A, ZTX968: 4A
    * TIP102, TIP107: 15A Darlington
* N-Channel MOSFETs
    * F15N05L: 15A, 50V, 0.14Ω
    * STP16NF06L: 16A, 60V, 0.07Ω
    * FDP55N06: 55A, 60V, 0.022Ω
    * IRL2203: 116A, 30V, 0.007Ω
        * Used in [µModule H-bridge](http://modularcircuits.tantosonline.com/blog/projects/umodules/%C2%B5m-h-bridge/)
* Diode:
    * 1N4004: 400V, 30A peak
* Drivers:
    * LTC1155: Drives high-side N-channel power MOSFETs.
    * [SN754410](http://www.ti.com/lit/ds/symlink/sn754410.pdf): Quad half H driver (1A).
        * Datasheet recommends .1uF between both V and ground.
    * L293D: Commonly used, similar to SN754410.
    * L298N: Full bridge (4A). https://www.sparkfun.com/products/9479
        * Has [breakout board](https://www.sparkfun.com/products/9540).
        * See [sample product](https://www.sparkfun.com/products/9670).
        * Has current sensor pins.
    * LMD18200: 3A, current feedback, datasheet has lots of info.
        * Can get [breakout board](http://www.robotcraft.ca/index.php/main-robot-electronics-catalog/breakout-boards/unpopulated-pcb-boards/breakout-board-for-lmd1820x-h-bridge.html)
* AS5045: 12-bit rotary position sensor.
    * [Explained](https://www.youtube.com/watch?v=6RtJi9XITW0)
    * [Demoed](https://www.youtube.com/watch?v=jbcPydrh0aA)
    * About $10. Looks like SMT.
    * [With breakout board](http://www.digikey.com/product-detail/en/AS5045-EK-AB/AS5045-EK-AB-ND/2339623) ($16)
    * Also AS5043 is 10-bit version.
    * [Guy who used it](http://dangerousprototypes.com/forum/viewtopic.php?f=56&t=3669)
    * [Forum for it](http://www.madscientisthut.com/forum_php/viewforum.php?f=11&sid=04bf2dbaab5299ec3545b01336a225a1)
    * [Library](https://github.com/smellsofbikes/AS5045_arduino_library)
    * Magnet:
        * Typically the magnet should be 6mm in diameter and ≥2.5mm in
          height. Magnetic materials such as rare earth AlNiCo/SmCo5 or
          NdFeB (neodymium) are recommended. Diametrically magnetized.
        * http://ams.com/eng/Products/Position-Sensors/Magnets/AS5000-MD6H-3
* [MD01B motor driver](https://www.pololu.com/product/705)
    * 9A
* Mikronauts:
    * [Raspberry Pi robot board](http://www.mikronauts.com/raspberry-pi/robopi/)
    * [Raspberry Pi proto board](http://www.mikronauts.com/raspberry-pi/ezaspi/)

# Code references

* [Robot arm control using machine vision](https://github.com/apockill/Robot-arm-control-using-machine-vision): Stacks Jenga with camera and robot arm.

# Hardware reference

* Good [motor controller](http://www.atlanta-robotics.com/Dual_Motor_Shield.php) for the 20A motor ($50).
* [Make your own 10A H-bridge](http://www.pyroelectro.com/tutorials/h_bridge_4_transistor/)
    * Doesn't use diodes?
    * Uses BJT instead of MOSFETs. Says that MOSFETs are lower power, but
      doesn't explain why they use BJT. Maybe because they're cheaper?
* [Jameco](http://www.jameco.com/) seems like a good place to get electronic parts. They're in Belmont and have will-call.
* [Power supplies](http://www.jameco.com/Jameco/catalogs/c151/P106.pdf)
    * [12V power supplies](http://www.jameco.com/Jameco/content/12-volt-power.html)
* [Octopart](https://octopart.com/) - Part search engine.
* [Tayda](http://www.taydaelectronics.com/) - From Thailand, good reviews of it.

# Architecture ideas

* Could use an ATTiny2313 to PWM the H bridge, and control the tiny through I2C. [Example from 2012](https://yetanotherhackersblog.wordpress.com/2012/01/03/beaglebot-a-beagleboard-based-robot/).

# To research

* [i2cproxy](https://github.com/beaglebot/BeagleBot/tree/master/beagleboard/i2cproxy): C program that proxies I2C commands in text.

# For later

* [Robotic claw](https://www.sparkfun.com/products/11524) for $12.
* [OpenServo](http://openservo.com/)
* [DIYServo](http://www.diyservo.com/)
* [Saleae](https://www.saleae.com/) -- Software for the logic analyzer.
* Name: Robecca Steam

# Log

* Install ROS.
    * Must do it on Ubuntu. Trusty (14.04) is recommended.
    * Upgraded VirtualBox.
    * Created a new VM with 2 GB RAM and 30 GB disk.
    * Downloaded Ubuntu Desktop 64-bit 14.04 from Ubuntu itself (996 MB).
        * Tried direct download and torrent. Both took about 5 minutes.
    * Installed Ubuntu with default parameters.
        * Enable copy-and-paste:
            * Machine, Settings, General, Advanced, Shared Clipboard, Bidirectional.
        * Screen will be too small (640x480).
            * Devices, Insert Guest Additions.
                * Linux will offer to run CD.
            * Run this in terminal and reboot:
                * `sudo apt-get install virtualbox-guest-dkms`
                * Not sure if this is necessary if you did the CD. This alone won't work.
        * Ctrl-Alt-T opens a terminal.
    * Also:
        * `sudo apt-get install -y git zsh vim`
        * `scp lk@hitch.headcode.com:home/bin/SETUP_NEW_MACHINE . && ./SETUP_NEW_MACHINE`
    * Followed [instructions](http://wiki.ros.org/indigo/Installation/Ubuntu) for installing ROS.
        * Installed "indigo".
        * Didn't have to add restricted, universe, or multiverse, it was already done.
            * Verify by doing global search, running "Ubuntu Software Center", then
                Edit menu, Software Sources.
        * Installed desktop full. Took a while.
        * Replace "setup.bash" with "setup.zsh".
* [Catkin or rosbuild?](http://wiki.ros.org/catkin_or_rosbuild)
    * rosbuilds is older and simpler.
    * catkin seems to be the new hotness and the future. Let's use that.
* Follow [ROS tutorials](http://wiki.ros.org/ROS/Tutorials).
    * Make workspace.
    * rospack find NAME
    * roscd NAME (or "log")
    * rosls NAME
    * `catkin_make` from ws directory to build.
    * roscore: name service, node to write log, parameter server.
    * rosnode list, rosnode info NODE
    * `rosrun turtlesim turtlesim_node`
* July 6, 2014:
    * Hook up Arduino to laptop and motor.
    * Get PWM to work. Chip gets hot. PWM frequency is low and audible (about 500 Hz).
    * Investigate PWM library for higher frequency.

* For copy and paste:
    * Ohm ohm Ω
    * Degree °
