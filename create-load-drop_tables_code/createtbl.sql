-- Include your create table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the create table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been created.

-- This is only an example of how you add create table ddls to this file.
--   You may remove it.
CREATE TABLE Facility
(
    facemail VARCHAR(30) NOT NULL
    ,facname VARCHAR (30)
    ,facaddr VARCHAR (50)
    ,facphonenum VARCHAR (15)
    ,web VARCHAR (50)
    ,PRIMARY KEY(facemail)
);

CREATE TABLE Midwife
(
    parcid VARCHAR (15) NOT NULL,
    wname VARCHAR (50) NOT NULL,
    wemail VARCHAR (30) UNIQUE NOT NULL,
    wphonenum VARCHAR (15),
    facemail VARCHAR (30) NOT NULL,
    FOREIGN KEY(facemail) REFERENCES Facility,
    PRIMARY KEY(parcid)
);


CREATE TABLE CommunityClinic
(
    comemail VARCHAR (30) NOT NULL,
    FOREIGN KEY (comemail) REFERENCES Facility,
    PRIMARY KEY(comemail)
);

CREATE TABLE BirthingCenter
(
    bcemail VARCHAR (30) NOT NULL,
    FOREIGN KEY (bcemail) REFERENCES Facility,
    PRIMARY KEY(bcemail)
);


CREATE TABLE Mother
(
    mhealthid INTEGER NOT NULL,
    mprofession VARCHAR (15) NOT NULL,
    mphonenum VARCHAR (15) NOT NULL,
    maddr VARCHAR (30) NOT NULL,
    memail VARCHAR (30) NOT NULL UNIQUE,
    mdob DATE NOT NULL,
    mname VARCHAR (50) NOT NULL,
    mbloodtype VARCHAR (5),
    PRIMARY KEY(mhealthid)
);


CREATE TABLE Father
(
    fatherid VARCHAR(15) NOT NULL,
    fhealthid INTEGER,
    fprofession VARCHAR (15) NOT NULL,
    fphonenum VARCHAR (15) NOT NULL,
    faddr VARCHAR (30),
    femail VARCHAR (30),
    fdob DATE NOT NULL,
    fname VARCHAR (50) NOT NULL,
    fbloodtype VARCHAR(5),
    PRIMARY KEY(fatherid)
);

CREATE TABLE Couple
(
    coupleid VARCHAR(15) NOT NULL,
    mhealthid INTEGER NOT NULL, -- a mother must present in one Couple
    fatherid VARCHAR(15),
    FOREIGN KEY(mhealthid) REFERENCES Mother,
    FOREIGN KEY(fatherid) REFERENCES Father,
    PRIMARY KEY (coupleid)
);

CREATE TABLE Pregnancy
(
    coupleid VARCHAR(15) NOT NULL,
    numofpreg INTEGER NOT NULL,

    exptfym DATE NOT NULL, -- expected time frame for birth (year-month)
    mensduedate DATE,
    ultraduedate DATE,

    finalduedate DATE,
    bcbirthaddr VARCHAR(30),
    homebirthaddr VARCHAR(30),
    primarymwid VARCHAR (15),
    backupmwid VARCHAR (15),
    bcemail VARCHAR (30),
    FOREIGN KEY(bcemail) REFERENCES BirthingCenter,
    FOREIGN KEY (coupleid) REFERENCES Couple,
    FOREIGN KEY (primarymwid) REFERENCES Midwife,
    FOREIGN KEY (backupmwid) REFERENCES Midwife,
    PRIMARY KEY (coupleid,numofpreg)
);

CREATE TABLE Baby
(
    babyid VARCHAR (15) NOT NULL,
    babyname VARCHAR (20),
    babydobtime TIMESTAMP,
    babybt VARCHAR (5),
    gender VARCHAR (8),
    coupleid VARCHAR (15) NOT NULL,
    numofpreg INTEGER NOT NULL,
    FOREIGN KEY (coupleid,numofpreg) REFERENCES Pregnancy,
    PRIMARY KEY (babyid)
);

CREATE TABLE InfoSession
(
    sessionid INTEGER NOT NULL,
    sessiondate DATE,
    sessiontime TIME,
    infolanguage VARCHAR (10),
    parcid VARCHAR (15),
    FOREIGN KEY (parcid) REFERENCES Midwife,
    PRIMARY KEY (sessionid)
);

CREATE TABLE Invite
(
    sessionid INTEGER NOT NULL,
    coupleid VARCHAR(15) NOT NULL,
    numofpreg INTEGER NOT NULL,
    attended VARCHAR (5),
    FOREIGN KEY (sessionid) REFERENCES InfoSession,
    FOREIGN KEY (coupleid,numofpreg) REFERENCES Pregnancy,
    PRIMARY KEY (sessionid,coupleid,numofpreg)
);


CREATE TABLE Appointment
(
    appointid INTEGER NOT NULL,
    appointdate DATE,
    appointtime TIME,
    parcid VARCHAR (15) NOT NULL,
    coupleid VARCHAR (15) NOT NULL,
    numofpreg INTEGER NOT NULL,
    FOREIGN KEY (parcid) REFERENCES Midwife,
    FOREIGN KEY (coupleid,numofpreg) REFERENCES Pregnancy,
    PRIMARY KEY (appointid)
);

CREATE TABLE Note
(
    noteid INTEGER NOT NULL,
    notetimestamp TIMESTAMP NOT NULL,
    content VARCHAR (100),
    appointid INTEGER NOT NULL, -- a note has to associate with an appointment
    FOREIGN KEY (appointid) REFERENCES Appointment,
    PRIMARY KEY (noteid)

);
CREATE Table LabTechnician
(
    techid VARCHAR (15) NOT NULL,
    techname VARCHAR (50) NOT NULL,
    techphonenum VARCHAR (15),
    PRIMARY KEY (techid)
);


CREATE TABLE MedicalTest
(
    testid INTEGER NOT NULL,
    prescdate DATE NOT NULL, -- must be prescribed by mw
    sampledate DATE,
    donedate DATE, -- the lab date illustrated in P2

    testresult VARCHAR (20),
    testtype VARCHAR (15) NOT NULL,

    -- parcid and (coupleid,numofpreg) are needed to identify one relationship
    parcid VARCHAR (15) NOT NULL,
    coupleid VARCHAR (15) NOT NULL,
    numofpreg INTEGER NOT NULL,
    babyid VARCHAR (15),
    techid VARCHAR (15),
    FOREIGN KEY (parcid) REFERENCES Midwife,
    FOREIGN KEY (coupleid,numofpreg) REFERENCES Pregnancy,
    FOREIGN KEY (babyid) REFERENCES Baby,
    FOREIGN KEY (techid) REFERENCES LabTechnician,
    PRIMARY KEY(testid)
);



