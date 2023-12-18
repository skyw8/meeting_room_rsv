# meeting_room_rsv



## Get Started

```shell
git clone --recursive https://github.com/SkywalkerZoZ/meeting_room_rsv.git
```



## Build

**Qt 6.60**

**MSVC2019-64bit**

QtCreator or VS

**mysql driver**



## Create Database


```sql
CREATE DATABASE meeting_room_rsv;
USE meeting_room_rsv;
CREATE TABLE Users (
    UserID numeric(25) PRIMARY KEY,
    UserName VARCHAR(255) UNIQUE,
    Email VARCHAR(255),
    userPassword VARCHAR(255),
    UserType ENUM('user', 'admin')
);

CREATE TABLE MeetingRooms (
    RoomID VARCHAR(25) PRIMARY KEY,
    RoomName VARCHAR(255),
    Capacity INT,
    RoomArea DECIMAL(10, 2),
    Description VARCHAR(1023),
    Photo LONGBLOB
);

ALTER TABLE MeetingRooms
ADD CONSTRAINT CapacityCheck CHECK (Capacity > 0);

ALTER TABLE MeetingRooms
ADD CONSTRAINT RoomAreaCheck CHECK (RoomArea > 0);


CREATE TABLE Reservations (
    ReservationID VARCHAR(36) PRIMARY KEY,
    UserID numeric(25),
    RoomID VARCHAR(25),
    ReservationDate DATE,
    StartTime TIME,
    EndTime TIME,
    Attendance INT,
    MeetingTheme VARCHAR(255),
    ReservationStatus ENUM('agree', 'reject','unapproved', 'canceled'),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RoomID) REFERENCES MeetingRooms(RoomID) ON DELETE CASCADE
);

ALTER TABLE Reservations
ADD CONSTRAINT AttendanceCheck CHECK (Attendance > 0);

# logs for 'reject' or 'agree' Reservations
CREATE TABLE ApprovalLogs (
    ReservationID VARCHAR(36),
    ApprovalTime DATETIME,
    ApproverID numeric(25),
    RejectionReason VARCHAR(1023),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID) ON DELETE CASCADE,
    FOREIGN KEY (ApproverID) REFERENCES Users(UserID)
);

INSERT INTO Users VALUES(1,"1","1","1","admin");
INSERT INTO Users VALUES(2,"2","2","2","user");
```



## Reference

[FluentUI](https://github.com/zhuzichu520/FluentUI)