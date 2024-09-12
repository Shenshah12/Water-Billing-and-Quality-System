# Water Billing Mobile App
## Overview
The Water Billing Mobile App allows customers to monitor their water consumption and receive billing details. This app displays both daily and monthly water usage, as well as the current monthly bill. It fetches the data from a native database that is populated with information from IoT devices installed at the customers' premises.

For a deeper understanding of the project, refer to the system details outlined in the thesis PDF.

## Features
- ### Daily Usage:
Displays the total water usage for the current day.

- ### Monthly Usage:
Shows the cumulative water consumption for the ongoing month.

- ### Billing:
Automatically calculates and displays the customer's water bill based on usage.

- ### User Authentication:
Secure login functionality for customers to access their data.

## Technologies Used
- Android (Java/Kotlin): Main programming language for developing the mobile app.

- ### Native Database: 
For storing and retrieving water usage and billing data locally on the device.

- ### Firebase Authentication:
Used for secure user login.

- ### REST API:
To fetch real-time data from the Firebase database.

## Data Flow
1. The STM32 IoT devices installed at the customer's premises send water usage and quality data to The Things Stack.
2. This data is routed through Pipedream, which pushes it to the native database on the mobile device.
3. The mobile app retrieves data from the local database and displays it to the user, including:
- Daily water consumption.
- Monthly water consumption.
- Automatically generated water bills.

## App Screens
### Login Screen:
Customers can log in using their registered email and password.

![Login](https://github.com/user-attachments/assets/a61bc85e-c95c-45e9-9c6e-d400935e962d)

### Dashboard:
Shows Monthly Water Usage and the Current Bill based on consumption.

![Dashboard](https://github.com/user-attachments/assets/900d87ab-4084-48a8-a434-ef742a821908)
### Profile:
Shows Profile of the  respective Customer.

![Profile](https://github.com/user-attachments/assets/4634a558-1943-41ca-af36-4c73fe5dde35)
### Usage History:
Allows customers to view their past water consumption information.
- #### Daily Consumption:
![Daily](https://github.com/user-attachments/assets/7cc53892-017a-4295-948d-8493cce2d071)
- #### Monthly Consumption:
![Monthly](https://github.com/user-attachments/assets/7d2963b9-a609-4d33-af15-7f02dc4816a1)
### Billing  History:
Allows customers to view their billing information for the respective months.
![Billing](https://github.com/user-attachments/assets/fefac6bf-b07f-4f5b-a6cd-ce363254945e)

## Future Enhancements
- ### Usage Alerts:
Implement push notifications to alert users when their daily or monthly usage exceeds a certain threshold.

- ### Graphical Data Representation:
Add charts to represent water usage trends over time.

- ### Offline Mode:
Cache water usage data to allow users to view their last recorded data even when offline.
