# Robot_Arm_Motor_App
This project is a mobile app to control a robot arm using sliders for 4 motors. It is made with Flutter for the front-end and PHP with MySQL for the back-end.

**Features**
- Control 4 motors using sliders
- Save motor positions (poses) to the database
- View saved poses
- Load or delete any saved pose

**Technologies**
- Flutter
- PHP
- MySQL
- XAMPP (for local server)

**How It Works**
1. User changes the sliders to control the motors.
2. When "Save Pose" is pressed, the data is sent to the PHP API and stored in the database.
3. The saved poses are shown in the app.
4. User can load or delete poses from the list.

**Notes**
- App uses http://10.0.2.2/ to connect with the local server from Android Emulator.
- Make sure XAMPP is running and database is created.

**SQL Code**

``
CREATE DATABASE robot_arm_db;

USE robot_arm_db;

CREATE TABLE poses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    motor1 INT NOT NULL,
    motor2 INT NOT NULL,
    motor3 INT NOT NULL,
    motor4 INT NOT NULL
);
``
