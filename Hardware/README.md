# LoRaWAN End Node - README
## Overview
This application is a simple demo of a LoRa modem connecting to a Network server, such as Loriot. It periodically sends sensor data or can send data upon a button press ("User Button 1"), based on the configuration. Traces are displayed via UART.

### Target Board: 
- STM32WLxx Nucleo (NUCLEO-WL55JC1, NUCLEO-WL55JC2)

## License Information
### Copyright (c) 2020-2021 STMicroelectronics. All rights reserved.

This software is licensed under terms that can be found in the LICENSE file in the root directory. If no LICENSE file is available, the software is provided "AS-IS."

## Features
This directory contains the source files for a LoRa application device that sends sensor data to a LoRa Network server. Data is transmitted periodically via timer events or upon button press, depending on the configuration.

## Keywords
- Applications
- SubGHz_Phy
- LoRaWAN
- End Node
- Single Core
- Directory Contents
Here is a breakdown of the important source files:

Core/Inc/adc.h: Function prototypes for adc.c
Core/Inc/adc_if.h: Header for ADC interface configuration
Core/Inc/dma.h: Function prototypes for dma.c
Core/Inc/flash_if.h: Definitions for Flash Interface functionalities
Core/Inc/gpio.h: Function prototypes for gpio.c
Core/Inc/main.h: Header for main.c containing common application definitions
Core/Inc/platform.h: Header for general hardware configuration
Core/Inc/rtc.h: Function prototypes for rtc.c
Core/Inc/stm32wlxx_hal_conf.h: HAL configuration file
Core/Inc/stm32wlxx_it.h: Interrupt handler headers
Core/Inc/sys_app.h: Function prototypes for system application management
Core/Inc/timer_if.h: Timer interface configuration
LoRaWAN/App/lora_app.h: LoRa application header
LoRaWAN/Target/lorawan_conf.h: LoRaWAN middleware configuration
Core/Src/adc.c: Configuration for ADC instances
Core/Src/gpio.c: GPIO configuration code
Core/Src/rtc.c: Configuration for RTC instances
Core/Src/usart.c: Configuration for USART instances
LoRaWAN/App/app_lorawan.c: LoRaWAN middleware application
Hardware and Software Environment
Supported Boards
STM32WLxx Nucleo boards:
NUCLEO-WL55JC1 (High-Band)
NUCLEO-WL55JC2 (Low-Band)
Board Setup
Connect the Nucleo board to your PC using a USB cable (Type-A to Micro-B) via the ST-LINK connector.
Ensure that the ST-LINK connector jumpers are properly fitted.
Software Setup
Modify the following configuration files if needed:
sys_conf.h
radio_conf.h
lorawan_conf.h
lora_app.c, lora_app.h
Commissioning.h, se-identity.h
mw_log_conf.h
main.h
Note: Ensure that the region and class chosen in lora_app.h are compatible with lorawan_conf.h.

How to Use the Example
Open your preferred development toolchain.
Rebuild all the files and load the binary image onto the target board.
Run the application.
Open a terminal with the following UART settings:
Baud Rate: 115200
Data Bits: 8
Stop Bit: 1
No Parity, No Flow Control
Monitor the data sent to the LoRa Network.
Debugging
Enable debugging by setting the flag DEBUGGER_ENABLED to 1 in sys_conf.h.
Optionally, disable low power mode by setting the flag LOW_POWER_DISABLE to 1.
Compile, download, and attach a debugger to the application.
Modifying RF Middleware and Application Settings Using STM32CubeMX
This example is compatible with STM32CubeMX, allowing some middleware and application settings to be modified via the GUI. However, note the following:

The .ioc file is provided for opening the project in STM32CubeMX v6.7.0 or higher.
When regenerating the project using the .ioc file, make sure to uncheck "Use Default Firmware Location" and replace the firmware path with your STM32CubeWL firmware package directory (e.g., C:\myDir\STM32Cube_FW_WL_V1.3.0\).
Combining with Azure ThreadX RTOS
This example can be integrated with Azure ThreadX RTOS using STM32CubeMX. Refer to the video tutorial, "STM32WL - How to port an existing RF application on Azure ThreadX RTOS".

© COPYRIGHT STMicroelectronics

This revised version is organized for clarity and better structure, ensuring that users can follow instructions smoothly and understand the project layout.
