**Database meeting_room_rsv** 


```sql
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

CREATE TABLE MeetingRoomSchedules (
    ScheduleID VARCHAR(25) PRIMARY KEY,
    RoomID VARCHAR(25),
    ScheduleDate DATE,
    StartTime TIME,
    LastTime TIME,
    Reserved BOOLEAN DEFAULT TRUE,
    FOREIGN KEY(RoomID) REFERENCES MeetingRooms(RoomID)
);


CREATE TABLE Reservations (
    ReservationID VARCHAR(25) PRIMARY KEY,
    UserID numeric(25),
    RoomID VARCHAR(25),
    ReservationDate DATE,
    StartTime TIME,
    EndTime TIME,
    Attendance INT,
    MeetingTheme VARCHAR(255),
    ReservationStatus ENUM('agree', 'reject','unapproved', 'canceled'),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RoomID) REFERENCES MeetingRooms(RoomID)
);


CREATE TABLE ApprovalLogs (
    ReservationID VARCHAR(25),
    ApprovalTime DATETIME,
    ApproverID numeric(25),
    RejectionReason VARCHAR(1023),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (ApproverID) REFERENCES Users(UserID)
);
```