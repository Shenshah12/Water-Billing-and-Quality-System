# Transmission Protocol for STM Hardware using The Things Stack, Pipedream, and Firebase
This guide outlines how to connect "STM hardware" to a network using The "Things Stack", route the data through "Pipedream", and store it in a "Firebase Database". The process is split into two key steps, with videos to assist:

- Video 1: Connecting The Things Stack to Pipedream.
- Video 2: Connecting Pipedream to Firebase Database.
## Architecture Overview
The data transmission follows this flow:

1 STM Hardware → LoRaWAN (The Things Stack)
2. The Things Stack → Routes data to Pipedream.
3. Pipedream → Manages workflow automation and transformation.
4. Firebase Database → Stores the data for further use.
## Prerequisites
- STM hardware with LoRaWAN module.
- An account on The Things Stack for LoRaWAN communications.
- A Pipedream account for automating workflows.
- A Firebase project with a Realtime Database.
## Steps
### 1. Setting up STM Hardware and The Things Stack
- Configure the STM hardware to transmit data over LoRaWAN.
- Register the device on The Things Stack and configure a gateway.
- Verify that data is successfully being transmitted to The Things Stack from the STM hardware.
### 2. Connecting The Things Stack to Pipedream
- In The Things Stack, create an integration to forward data to Pipedream.
- Use webhooks in The Things Stack to send data to Pipedream.
- In Pipedream, use the HTTP trigger to capture incoming data.
- Video 1: [Connecting The Things Stack to Pipedream](https://www.youtube.com/watch?v=PaKNoVLCtV4&t=468s)

### 3. Setting up Pipedream Workflow
- In Pipedream, create a workflow to receive and process data from The Things Stack.
- Parse, modify, and format the incoming data to prepare it for Firebase.
- 
### 4. Connecting Pipedream to Firebase
- In Pipedream, use the Firebase Admin SDK or Firebase REST API to send the data to your Firebase Realtime Database.
- Set up Firebase authentication in Pipedream.
- Send the transformed data from the transmission python code to the Firebase database.

Video 2: [Connecting Pipedream to Firebase Database](https://www.youtube.com/watch?v=0cZg77SPE0w)

### 5. Verifying Data Transmission
- Go to the Firebase Console and check your Realtime Database to ensure that the data from the STM hardware is being stored correctly.
## Diagram of Data Flow

## STM Hardware → The Things Stack → Pipedream → Firebase Database
## Troubleshooting
- ### Things Stack Connectivity:
Ensure your LoRaWAN module is correctly configured and the device is registered on The Things Stack.
- ### Pipedream Workflow Issues:
Check the Pipedream logs to identify any errors in data routing or transformation.
- ### Firebase Database Problems:
Verify that your Firebase credentials are correctly set up in Pipedream and that your database rules allow write access.
## Next Steps
After confirming data transmission, you can enhance the workflow in Pipedream to add features such as error handling, data validation, or integrating additional services.
