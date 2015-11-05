-- @description Expands the ESP8266's GPIO to 8 more I/O pins via I2C with the PCA9555A I/O Expander
-- PCA9555A Datasheet: 
--http://www.nxp.com/documents/data_sheet/PCA9555A.pdf

-------------------------------------------------------------------------------

  local moduleName = ... 
  local M = {}
 _G[moduleName] = M 
 

-- Constant device address.
local PCA9555A_ADDRESS 
-- Registers' address as defined in the PCA9555A's datashseet
local PCA9555A_wr_port0 = 0x02
local PCA9555A_rd_port0 = 0
local PCA9555A_wr_port1 = 0x03
local PCA9555A_rd_port1 = 0x01
local PCA9555A_config_port0 = 0x06
local PCA9555A_config_port1 = 0x07

-- Default value for i2c communication
local id = 0

  --pin modes for I/O direction
   M.INPUT = 0
   M.OUTPUT = 1

 --pin states for I/O i.e. on/off
   M.HIGH = 1
   M.LOW = 0

---
-- @name write
-- @description Writes one byte to a register
-- @param registerAddress The register where we'll write data
-- @param data The data to write to the register
-- @return void
----------------------------------------------------------
local function write(registerAddress, data)
    i2c.start(id);
    i2c.address(id,PCA9555A_ADDRESS,i2c.TRANSMITTER); -- send MCP's address and write bit
    i2c.write(id,registerAddress);
    i2c.write(id,data);
    i2c.stop(id);
end

---
-- @name read
-- @description Reads the value of a regsiter
-- @param registerAddress The reigster address from which to read
-- @return The byte stored in the register
----------------------------------------------------------
local function read(registerAddress)
    -- Tell the PCA9555A which register you want to read from
    i2c.start(id);
    i2c.address(id,PCA9555A_ADDRESS,i2c.TRANSMITTER); -- send PCA9555A's address and write bit
    i2c.write(id,registerAddress);
    i2c.stop(id);
    i2c.start(id);
    -- Read the data form the register
    i2c.address(id,PCA9555A_ADDRESS,i2c.RECEIVER); -- send the PCA9555A's address and read bit
    local data = 0x00;
    data = i2c.read(id,1); -- we expect only one byte of data
    i2c.stop(id);

    
    return string.byte(data) ;-- i2c.read returns a string so we convert to it's int value
end


-- @param pinSDA The pin to use for SDA
-- @param pinSCL The pin to use for SCL
-- @param speed The speed of the I2C signal
-- @return void
---------------------------------------------------------------------------
 function M.begin(address,pinSDA,pinSCL,speed)
 i2c.setup(id,pinSDA,pinSCL,speed);
 PCA9555A_ADDRESS=address; 
 end
---
-- @name write to port0
-- @description Writes a byte of data to the port0 register
-- @param dataByte The byte of data to write
-- @return void
----------------------------------------------------------
function M.write_port0(dataByte)
    write(PCA9555A_wr_port0,dataByte);
end

---
-- @name read from port0
-- @description reads a byte of data from the port0 register
-- @return One byte of data
----------------------------------------------------------
function M.read_port0()
 
    return read(PCA9555A_rd_port0);
end

---
-- @name write port1
-- @description Writes one byte of data to the IODIR register
-- @param dataByte The byte of data to write
-- @return void
----------------------------------------------------------
function M.write_port1(dataByte)
    write(PCA9555A_wr_port1);
end

---
-- @name read from port1
-- @description Reads a byte from the port1 register
-- @return The byte of data in port1
----------------------------------------------------------
function M.read_port1()

    return read(PCA9555A_rd_port1);
    
end
---
-- @name write config The byte to write to the port0
-- @description Writes a byte of data to the port0 
-- and mean 1 for input and 0 for output
----------------------------------------------------------------
function M.write_config0(dataByte)
    write(PCA9555A_config_port0,dataByte);
end


-- -- @name write config The byte to write to the port1
-- @description Writes a byte of data to the port1 
-- and mean 1 for input and 0 for output
-------------------------------------------------------------------
function M.write_config1(dataByte)
    write(PCA9555A_config_port1,dataByte);
end

return M
