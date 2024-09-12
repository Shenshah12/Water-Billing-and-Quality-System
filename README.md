# Water Billing and Quality System
## Overview
This project implements an IoT-based water billing and quality assessment system that collects water usage and quality data using STM32 microcontrollers and LoRaWAN technology. The collected data is sent to The Things Stack, triggered to Pipedream, and then stored in a Firebase database. The system includes:

- A Mobile App (for customers) to view daily/monthly water usage and bill.
- A Web App (for admins and customers) to track the total consumption and water quality.
## Technologies Used
- ### STM32 Microcontrollers:
Used for capturing sensor data and controlling the IoT device.
- ### LoRaWAN Technology:
For transmitting data wirelessly from IoT devices to the network.
- ### The Things Stack:
For receiving data from the LoRaWAN devices.
- ### Pipedream:
 Used as a serverless trigger to process and push data to the Firebase database.
- ### Firebase:
A real-time database that stores water usage and quality data for customers and admins.
- ### Mobile App (Android):
To show water usage and billing information to the customers.
- ### Web App (Admin & Customer):
To provide admins with a total overview of customer consumption, water quality, and billing. (Web app logic can be derived from the mobile app functionality.)

## System Components
### 1. IoT Device (STM32 Microcontroller)

- Equipped with sensors to monitor water flow, usage, and quality.
- Transmits data via LoRaWAN to The Things Stack.
### 2. The Things Stack

- Manages LoRaWAN devices and gateways.
- Receives data from IoT devices and forwards it to the next stage of the pipeline.
### 3. Pipedream

- Acts as a middleware to receive water usage and quality data from The Things Stack and trigger events that send the data to Firebase.

### 4. Firebase Database

- Stores daily/monthly water usage, quality parameters, and billing information.
- Powers the mobile app's user interface for customers and the web app for admin reports.
### 5. Mobile App (Customer)

- Displays detailed water consumption data for the user.
- Shows the current water bill (daily/monthly) based on usage.
### 6. Web App (Admin/Customer)

- #### Admin Side:
Displays total water usage, quality metrics, and billing for all customers.
- #### Customer Side:
Allows customers to view water usage and billing history, similar to the mobile app.
## Data Flow Diagram

 1. ### Sensors (STM32 IoT Device):
Collect water usage & quality data.

 2. ### LoRaWAN Module:
Transmits the data to The Things Stack.

 3. ### The Things Stack:
Receives the data and passes it to Pipedream.

 5. ### Pipedream:
Pushes data to the Firebase database.

 6. ### Firebase: Stores
data for both the mobile and web applications.

  6. ### Mobile/Web Apps:
Fetch and display data to customers and admins.
## Setup Instructions
1. ### IoT Device Setup (STM32 and LoRaWAN):

- Install the necessary STM32CubeIDE or equivalent toolchain.
- Connect sensors for water usage and quality monitoring to the STM32 microcontroller.
- Configure the LoRaWAN module to transmit data to The Things Stack.
- Upload the code to the STM32 microcontroller to handle sensor data collection and transmission.

2. ### The Things Stack:

- Sign up for The Things Stack account.
- Register your IoT device and configure the LoRaWAN gateway.
- Set up data routing to Pipedream using HTTP integration or webhook triggers.

3. ### Pipedream:

- Set up a Pipedream workflow to receive the data from The Things Stack.
- Create a trigger to send the data to the Firebase database when new data is received from IoT devices.

4. ### Firebase Setup:

- Create a Firebase project and real-time database.
- Set up the structure to store water usage, quality data, and billing information.
- Integrate Firebase with your mobile and web apps.

5. ### Mobile App:

- Use Android Studio to develop the customer-facing mobile app.
- Retrieve and display data from Firebase (for daily/monthly water usage and billing).
- Authenticate users using Firebase Authentication (optional).

6. ### Web App:

- Develop a basic web interface (Flutter/Dart framework) to allow admins to view total water usage, billing, and quality.
- Implement user roles (admin/customer) and data retrieval from Firebase.
- You can refer to the mobile app logic for customer data representation in the web app.
## Future Improvements
- ### Web App Development:
Currently, the web app logic is derived from the mobile app. The web app should be expanded to provide a comprehensive interface for both admin and customer views.

- ### Integration with More Sensors:
Additional sensors can be added to monitor more quality parameters (e.g., pH levels, contaminants).

- ### Alert System:
Set up alerts (via SMS or push notifications) when water quality drops below acceptable levels.
