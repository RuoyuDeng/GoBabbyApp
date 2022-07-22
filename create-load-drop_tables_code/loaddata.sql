-- Include your INSERT SQL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the INSERT statements for the tables with foreign key references
--    ONLY AFTER the parent tables!

-- This is only an example of how you add INSERT statements to this file.
--   You may remove it.


INSERT INTO Facility(facemail,facname,facaddr,facphonenum,web) VALUES
('lsl@gmail.com','Lac-Saint-Louis','fac addr 1', '514-000-2222', NULL),
('fac2@gmail.com','fac2','fac addr 2', '514-000-2232', NULL),
('fac3@gmail.com','fac3','fac addr 3', '514-000-2422', NULL),
('fac4@gmail.com','fac4','fac addr 4', '514-010-2222', NULL),
('fac5@gmail.com','fac5','fac addr 5', '514-002-1232', NULL),
('fac6@gmail.com','fac6','fac addr 6', '514-000-3932', NULL),
('fac7@gmail.com','fac7','fac addr 7', '514-230-2765', NULL),
('fac8@gmail.com','fac8','fac addr 8', '514-440-8882', NULL),
('fac9@gmail.com','fac9','fac addr 9', '514-098-1515', NULL),
('fac10@gmail.com','fac10','fac addr 10', '514-022-1432', NULL)
;

INSERT INTO Midwife(parcid,wname,wemail,wphonenum,facemail) VALUES
('mw1','Marion Girard','mw1@gmail.com','514-001-2123','lsl@gmail.com'),
('mw2','Mary','mw2@gmail.com','514-123-6161','fac4@gmail.com'),
('mw3','Kimmy','mw3@gmail.com','514-321-2515','fac2@gmail.com'),
('mw4','Kellen','mw4@gmail.com','514-111-6151','fac5@gmail.com'),
('mw5','Bobby','mw5@gmail.com','514-412-2231','lsl@gmail.com')
;

INSERT INTO CommunityClinic(comemail) VALUES
('lsl@gmail.com'),
('fac3@gmail.com'),
('fac8@gmail.com'),
('fac9@gmail.com'),
('fac10@gmail.com')
;

INSERT INTO BirthingCenter(bcemail) VALUES
('fac2@gmail.com'),
('fac4@gmail.com'),
('fac5@gmail.com'),
('fac6@gmail.com'),
('fac7@gmail.com')
;

INSERT INTO Mother(mhealthid,mprofession,mphonenum,maddr,memail,mdob,mname,mbloodtype) VALUES
(1000,'doctor','514-123-1616','addr1','mother1@gmail.com','1987-01-23','Victoria Gutierrez','A'),
(1001,'teacher','514-109-1234','addr2','mother2@gmail.com','1981-10-12','Luzzy','AB'),
(1002,'business','514-141-6131','addr3','mother3@gmail.com','1987-09-21','Lilly',NULL),
(1003,'professor','514-615-1237','addr4','mother4@gmail.com','1987-08-16','Nicky','A'),
(1004,'firefighter','514-132-7865','addr5','mother5@gmail.com','1987-06-21','Lux','B')
;

INSERT INTO Father(fatherid,fhealthid,fprofession,fphonenum,faddr,femail,fdob,fname,fbloodtype) VALUES
('father1',2000,'doctor','514-123-5678',NULL,NULL,'1991-01-23','Bob','A'),
('father2',2001,'student','514-423-1562',NULL,NULL,'1991-02-23','Tim','B'),
('father3',2002,'streamer','514-513-1324',NULL,NULL,'1989-08-23','Uzi',NULL),
('father4',2003,'pro gamer','514-233-5152',NULL,NULL,'1981-12-23','Karsa','O'),
('father5',2004,'teacher','514-231-5161',NULL,NULL,'1987-11-23','Huhu',NULL)
;

INSERT INTO Couple(coupleid,mhealthid,fatherid) VALUES
('couple1',1000,'father1'),
('couple2',1001,'father2'),
('couple3',1002,'father1'),
('couple4',1003,'father3'),
('couple5',1004,'father4')
;

INSERT INTO Pregnancy(coupleid,numofpreg, exptfym, mensduedate, ultraduedate,
                      finalduedate,bcbirthaddr,homebirthaddr ,primarymwid,backupmwid,bcemail) VALUES
--           expect tf ym  mensduedate  ultraduedate finalduedate
('couple1',1,DATE'2010-08-01',DATE'2010-09-01',DATE'2010-09-10',DATE'2010-09-10',NULL,'addr1','mw1','mw2',NULL),
('couple1',2,DATE'2012-08-01',DATE'2012-10-01',DATE'2012-10-10',DATE'2012-10-10',NULL,'addr1','mw1','mw4',NULL),
('couple2',1,DATE'2022-05-01',DATE'2022-05-01',DATE'2022-07-10',DATE'2022-07-10',NULL,NULL,'mw3',NULL,NULL),
('couple3',1,DATE'2022-07-01',DATE'2022-07-01',DATE'2022-06-10',NULL,NULL,'addr3','mw4','mw1',NULL),
('couple3',2,DATE'2023-12-01',NULL,NULL,NULL,NULL,NULL,'mw5','mw2',NULL),
('couple4',1,DATE'2022-10-01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('couple5',1,DATE'2023-09-01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO Baby(babyid,babyname,babydobtime,babybt,gender,coupleid,numofpreg) VALUES
('baby1','Jax',TIMESTAMP'2010-09-10 13:10:53','B','Male','couple1',1),
('baby2','Bub',TIMESTAMP'2012-10-10 20:10:53','A','Female','couple1',2),
('baby3',NULL,TIMESTAMP'2022-07-10 11:10:53','AB','Male','couple2',1),
('baby4','Fetch',TIMESTAMP'2022-07-01 12:10:53','O',NULL,'couple3',1),
-- if the dob time is NULL, we say the baby is not born yet
('baby5','Hub',NULL,NULL,NULL,'couple3',2),
('baby6','Hub2',NULL,NULL,NULL,'couple3',2)
;

INSERT INTO InfoSession(sessionid,sessiondate,sessiontime,infolanguage,parcid) VALUES
(3000,DATE'2010-01-10',TIME'14:30','English','mw1'),
(3001,DATE'2012-01-15',TIME'13:30','Chinese','mw2'),
(3002,DATE'2022-01-10',TIME'11:30','English','mw3'),
(3003,DATE'2022-01-10',TIME'17:10','French','mw1'),
(3004,DATE'2022-02-10',TIME'12:20','English','mw4')
;

INSERT INTO Invite(sessionid,coupleid,numofpreg,attended) VALUES
(3000,'couple1',1,'Yes'),
(3001,'couple1',2,'Yes'),
(3004,'couple2',1,'Yes'),
(3004,'couple3',1,'Yes'),
(3002,'couple3',2,'Yes')
;

INSERT INTO Appointment(appointid,appointtime,appointdate,parcid,coupleid,numofpreg) VALUES
(4000,TIME'11:30',DATE'2022-03-22','mw3','couple2',1),
(4001,TIME'11:30',DATE'2022-03-25','mw4','couple3',1),
(4002,TIME'11:30',DATE'2022-12-11','mw5','couple3',2),
(4003,TIME'11:30',DATE'2010-03-22','mw1','couple1',1),
(4004,TIME'11:30',DATE'2012-03-25','mw1','couple1',2),
(4005,TIME'11:30',DATE'2022-04-22','mw4','couple3',1)
;

INSERT INTO Note(noteid,notetimestamp,appointid,content) VALUES
(5000,'2022-03-22 12:12:15',4000,'Test Note'),
(5001,'2022-03-22 12:12:15',4000,NULL),
(5002,'2022-03-25 11:45:53',4001,'Doing well so far'),
(5003,'2012-03-25 12:01:53',4004,NULL),
(5004,'2022-04-22 11:59:53',4005,NULL)
;

INSERT INTO LabTechnician(techid,techname,techphonenum) VALUES
('tech1','Strcmp',NULL),
('tech2','Strcat',NULL),
('tech3','Memset',NULL),
('tech4','Blabla',NULL),
('tech5','Garen',NULL)
;

INSERT INTO MedicalTest(testid,prescdate,sampledate,donedate,testresult,testtype,parcid,coupleid,
                        numofpreg,babyid,techid) VALUES
-- 5 tests for mothers
(6000,DATE'2012-05-03',NULL,DATE'2012-05-18','good','blood iron test','mw1','couple1',2,NULL,'tech5'),
(6001,DATE'2010-06-03',NULL,DATE'2010-06-18','fine','blood iron test','mw1','couple1',1,NULL,'tech5'),
(6002,DATE'2022-03-03',NULL,NULL,NULL,'ultrasound test','mw3','couple2',1,NULL,'tech1'),
(6003,DATE'2022-02-03',NULL,NULL,NULL,'blood iron test','mw3','couple2',1,NULL,'tech3'),
(6004,DATE'2022-04-03',NULL,NULL,NULL,'ultrasound test','mw3','couple2',1,NULL,'tech4'),
-- 5 tests for babies
(6005,DATE'2012-05-03',NULL,DATE'2012-05-18','good','blood iron test','mw1','couple1',2,'baby2','tech5'),
(6006,DATE'2010-06-03',NULL,DATE'2010-06-18','fine','blood iron test','mw1','couple1',1,'baby1','tech5'),
(6007,DATE'2022-03-03',NULL,NULL,NULL,'ultrasound test','mw3','couple2',1,'baby3','tech1'),
(6008,DATE'2022-02-03',NULL,NULL,NULL,'blood iron test','mw3','couple2',1,'baby3','tech3'),
(6009,DATE'2022-04-03',NULL,NULL,NULL,'ultrasound test','mw3','couple2',1,'baby3','tech4')
;





