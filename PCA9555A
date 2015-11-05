--@description Shows control of 16 GPIO pins/LEDs via I2C with the PCA9555A I/O --expander AND circuit Connect 16 LEDs withs resistors to the GPIO pins of the --PCA9555A AND Connect GPIO0 of the ESP8266-01 module to the SCL pin of the --PCA9555A. 
--AND Connect GPIO2 of the ESP8266-01 module to the SDA pin of the --PCA9555A AND Connect two 4.7k pull-up resistors on SDA and SCL
 -- Use 3.3V for --VCC.

require ("PCA9555A")

-- ESP-01 GPIO Mapping as per GPIO Table in https://github.com/nodemcu/nodemcu-firmware
gpio0, gpio2 = 3, 4

-- Setup PCA9555A
PCA9555A=require("PCA9555A")
PCA9555A.begin(0x20,gpio2,gpio0,i2c.SLOW)
PCA9555A.write_config0(0) -- make all GPIO pins IN PORT0 as outputs
PCA9555A.write_config1(0xFF) -- make all GPIO pins IN PORT1 as input
PCA9555A.write_port0(0x00) -- make all GIPO pins IN PORT0 off/low



-- @name count()
-- @description Reads the value from the GPIO register, increases the read value by 1 
--  and writes it back so the LEDs will display a binary count up to 255 or 0xFF in hex.
local function count()

    local kk1 =0x00
 local kk2 =0x00
    kk1 = PCA9555A.read_port1()
   
    kk2 = PCA9555A.read_port0()
    PCA9555A.write_port0(kk1) 
  print("kk1=",kk1)
  print("kk2=",kk2)
end
-- Run count() every 100ms
tmr.alarm(0,1000,1,count);

