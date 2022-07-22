-- Include your drop table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the drop table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been dropped (reverse of the creation order).

-- This is only an example of how you add drop table ddls to this file.
--   You may remove it.

-- First remove the tables that must depend on other tables
DROP TABLE MedicalTest;
DROP TABLE Note;
DROP TABLE Appointment;
DROP TABLE Baby;
DROP TABLE Midwife;


DROP TABLE Facility;
DROP TABLE CommunityClinic;
DROP TABLE BirthingCenter;

DROP TABLE Pregnancy;
DROP TABLE Couple;
DROP TABLE InfoSession;

DROP TABLE Mother;
DROP TABLE Father;
DROP TABLE Invite;


DROP TABLE LabTechnician;

