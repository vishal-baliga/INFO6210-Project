-- Creating a new Database for Team 01

CREATE DATABASE CloudComputingDatabase_Team01;

USE CloudComputingDatabase_Team01;


-- Table 1 - UserInfo

------THIS FILE INCLUDES UserInfo, Encryption and Table Level Constrain function updated----------------------------


----------Created a Userdatabase-----------
CREATE TABLE dbo.UserInfo (
  UserID int IDENTITY (1001,1) NOT NULL PRIMARY KEY,
  FirstName varchar(100)NOT NULL,
  LastName varchar(100) NOT NULL,
  Email varchar(50) NOT NULL,
  Password varchar(100) NOT NULL,
  PhoneNumber varchar(12) NOT NULL, 
  CONSTRAINT chk_phone CHECK (PhoneNumber like '[+][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  CONSTRAINT chk_email CHECK (Email like '%[@]%'),
  Street varchar(50),
  City varchar(50),
  State varchar(50),
  Zipcode varchar(6),
);

DROP TABLE dbo.UserInfo 
--------------------------------------------------------

INSERT INTO dbo.UserInfo
VALUES('William','Johnson','willj12@gmail.com','wj123@wj','+19452365688','Sounth End','Newark','NJ','07125'),
('Samantha','Huges','smdh34@gmail.com','hugme12#kg','+18693652144','Tremont St.','Boston','MA','02112'),
('Johnson','Terry','jett23@yahoo.com','myjohn@986','+17127539535','Rodeo Drive','Los Angeles','CA','90006'),
('Rajiv','Mehta','mehtaji23@gmail.com','anjali17#j_54','+18576964124','Cambridge St','Lowell','MA','02856'),
('Xin','Chao','xinchao43@gmail.com','hoan12#soul','+17446361225','King Road','Phoenix','AZ','85002'),
('Antonio','Harerra','antonychrist23@hotmail.com','@hareA12_rt','+16694123265','Saint St','Sana Clara','CA','95023'),
('Arturo','Lopez','lopeza91@gmail.com','mom@familytop1','+16694714551','Leland Ave','San Jose','CA','95085'),
('Ruso','Zlaton','rus12345@gmail.com','kingzlantan@top1','+16552327456','Billboard St','San Jose','CA','95001'),
('Martin','Patrik','mart_p12@gmail.com','yohime#gono','+17843269891','Hyde St','San Fransico','CA','94016'),
('Sandro','Rick','sandro1989@yahoo.com','my12desks@R','+17556397843','Clemont Ave','Boston','MA','02458'),
('Nikita','Sharma','nicks_s989@acb.edu','jaiganesha_12@gh','+19864714521','Queen Rd','New York','NY','10056'),
('Emma','Beckham','emma_342@gmail.com','Heisnot@mybest98','+16641789645','Homes Ave','Charlotte','NC','20004'),
('Tanmay','Gandhi','tanmaygandhi@neu.edu','ahinsa@salty878','+18856939671','Sun Rd','New York','NY','10019'),
('Edward','Kenway','eddymadkenway@gamil.com','pirate_for@life','+15514789654','Bombay St','Dallas','TX','75014'),
('Frank','Robertson','frankthegreat@rediffmail.com','godspeed@99','+16110204756','North End Rd','Seattle','WA','98124')

INSERT INTO dbo.UserInfo 
VALUES ('Arjen','Gentos','argentos445t@gmail.com','y@gentosar@909','+15118204766','Franklin Rd','San Diego','CA','91924',
EncryptByKey(Key_GUID(N'SymKey'), convert(varchar, 'y@gentosar@909')));
INSERT INTO dbo.UserInfo 
VALUES ('Wanye','Rashford','rashfordfamily12t@gmail.com','myrashford#32','+15118456877','BurgVille St','Phonenix','AZ','85033',
EncryptByKey(Key_GUID(N'SymKey'), convert(varchar, 'myrashford#32')));
INSERT INTO dbo.UserInfo 
VALUES ('Karen','Wilson','karenhere25@outlook.com','loveandhate3451','+18123564711','Emerald Ave','Chicago','IL','60095',
EncryptByKey(Key_GUID(N'SymKey'), convert(varchar,'loveandhate3451')));
INSERT INTO dbo.UserInfo 
VALUES ('Yee','Min','yeeminpark21@gmail.com','namchamin_72','+15811475785','Chestnut St','Newark','NJ','07106',
EncryptByKey(Key_GUID(N'SymKey'), convert(varchar, 'namchamin_72')));
INSERT INTO dbo.UserInfo 
VALUES ('Olivia','Davidson','emmheadin-12@outlook.com','grandmamartha@343','+18693564711','Columbus Ave','New York','NY','10095',
EncryptByKey(Key_GUID(N'SymKey'), convert(varchar,'grandmamartha@343')));
INSERT INTO dbo.UserInfo 
VALUES ('Ajinkya','Dixit','adixit784@gmail.com','12adiraj_77','+18572584568','Gallod St','Arlington','TX','02474',
EncryptByKey(Key_GUID(N'SymKey'), convert(varchar, '12adiraj_77')));
INSERT INTO dbo.UserInfo 
VALUES ('Chenguang','Wan','chengwan@yahoo.com','cheng3321','+18123568312','Huntington Ave','Chicago','IL','60095',
EncryptByKey(Key_GUID(N'SymKey'), convert(varchar,'cheng3321')));
INSERT INTO dbo.UserInfo 
VALUES ('Tom','Riddle','slytherrin@gmail.com','avdakadabra@all','+15118456143','Topical St','Los Angeles','CA','90033',
EncryptByKey(Key_GUID(N'SymKey'), convert(varchar, 'avdakadabra@all')));


--------------Encrypting the Passowrd---------------------


CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'Pass@123';

CREATE CERTIFICATE OurCerti
WITH SUBJECT = 'ProtectCloud';

CREATE SYMMETRIC KEY SymKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE OurCerti;

OPEN SYMMETRIC KEY SymKey
DECRYPTION BY CERTIFICATE Ourcerti;

UPDATE UserInfo
SET dbo.UserInfo Password_Encrypt = EncryptByKey(KEY_GUID('SymKey'),Password)
FROM dbo.UserInfo ui ;

CLOSE SYMMETRIC KEY SymKey;


------------Decryption-------------------------------

OPEN SYMMETRIC KEY SymKey
        DECRYPTION BY CERTIFICATE OurCerti;

SELECT Password_Encrypt AS 'Encrypted data',
            CONVERT(varchar, DecryptByKey(Password_Encrypt)) AS 'Decrypted Password'
            FROM dbo.UserInfo;

CLOSE SYMMETRIC KEY SymKey;

--------Remove Password Column----------------------

ALTER TABLE dbo.UserInfo DROP COLUMN Password;





-- Table 2 Card Details

CREATE  TABLE CardDetails (CardID INT IDENTITY NOT NULL PRIMARY KEY,
UserID int references UserInfo(UserID),
CardNumber VARBINARY(500),
CardFirstName VARCHAR(30),
ValidThroughMonth TINYINT check(ValidThroughMonth>=1 and ValidThroughMonth<=12),
ValidThroughYear nvarchar(4) check(ValidThroughYear>=year(CURRENT_TIMESTAMP )),
CardZipCode varchar(7),
SecurityCode int,
);


	 ---Creating a certificate for Encryption
   CREATE CERTIFICATE CardEncryptCertificate   
   ENCRYPTION BY PASSWORD = '0123456789'  
   WITH SUBJECT = 'Encrypting Sensitive Card Info',   
   EXPIRY_DATE = '20211031';  
  
  	---Creating a SymmetricKey
   CREATE SYMMETRIC KEY CCEncrypt  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE CardEncryptCertificate ;
   
   ---Opening a SymmetricKey
   OPEN SYMMETRIC KEY CCEncrypt  
   DECRYPTION BY CERTIFICATE CardEncryptCertificate
   WITH PASSWORD='0123456789';

  INSERT into CardDetails values(1001,EncryptByKey(Key_GUID(N'CCEncrypt'), convert(varbinary, '1234-2345-3456-4567')),'William',
   06,'2025','07125',982);
  INSERT into CardDetails values(1002,EncryptByKey(Key_GUID(N'CCEncrypt'),'1234-2346-3456-4567'),'Samantha',
   12,'2023','02112',892);
  INSERT into CardDetails values(1003,EncryptByKey(Key_GUID(N'CCEncrypt'),'1834-2346-3456-4587'),'Johnson',
   06,'2023','90006',099);
  INSERT into CardDetails values(1004,EncryptByKey(Key_GUID(N'CCEncrypt'),'9234-2946-3496-9567'),'Mehta',
   12,'2024','02856',996);
  INSERT into CardDetails values(1008,EncryptByKey(Key_GUID(N'CCEncrypt'),'8834-2346-3456-4567'),'Ruso',
   06,'2025','95001',998);
  INSERT into CardDetails values(1005,EncryptByKey(Key_GUID(N'CCEncrypt'),'7234-2306-0056-4567'),'Xin',
   07,'2026','85002',779);
  INSERT into CardDetails values(1006,EncryptByKey(Key_GUID(N'CCEncrypt'),'4444-2346-3456-4567'),'Antonio',
   09,'2028','95023',696);
  INSERT into CardDetails values(1007,EncryptByKey(Key_GUID(N'CCEncrypt'),'3334-2346-3456-4567'),'Aruturo',
   10,'2024','95085',999);
  INSERT into CardDetails values(1009,EncryptByKey(Key_GUID(N'CCEncrypt'),'3334-2776-3456-4567'),'Martin',
   11,'2021','94016',999);
  INSERT into CardDetails values(1010,EncryptByKey(Key_GUID(N'CCEncrypt'),'8734-2346-3406-4507'),'Sandro',
   05,'2022','02458',799);
  INSERT into CardDetails values(1011,EncryptByKey(Key_GUID(N'CCEncrypt'),'7234-2396-0056-4567'),'Nikita',
   06,'2022','10056',987);
  INSERT into CardDetails values(1012,EncryptByKey(Key_GUID(N'CCEncrypt'),'5555-2346-3456-4567'),'Emma',
   07,'2023','20004',345);
  INSERT into CardDetails values(1013,EncryptByKey(Key_GUID(N'CCEncrypt'),'3334-6666-3456-4567'),'Tanmay',
   08,'2024','10019',867);
  INSERT into CardDetails values(1014,EncryptByKey(Key_GUID(N'CCEncrypt'),'3334-2776-7777-4567'),'Edward',
   09,'2026','75014',990);
  INSERT into CardDetails values(1015,EncryptByKey(Key_GUID(N'CCEncrypt'),'2334-2346-3456-8888'),'Frank',
   02,'2022','98124',995);
  INSERT into CardDetails values(1016,EncryptByKey(Key_GUID(N'CCEncrypt'),'3334-2346-3456-4567'),'Arjen',
   10,'2024','91924',699);
  INSERT into CardDetails values(1017,EncryptByKey(Key_GUID(N'CCEncrypt'),'3334-2776-3456-4567'),'Wanye',
   11,'2021','85033',949);
  INSERT into CardDetails values(1018,EncryptByKey(Key_GUID(N'CCEncrypt'),'8734-2346-3406-4507'),'Karen',
   04,'2022','60095',499);
  INSERT into CardDetails values(1019,EncryptByKey(Key_GUID(N'CCEncrypt'),'7234-2396-0056-4567'),'Yee',
   03,'2022','07106',984);
  INSERT into CardDetails values(1020,EncryptByKey(Key_GUID(N'CCEncrypt'),'5555-2346-3456-4567'),'Olivia',
   02,'2023','10095',344);
  INSERT into CardDetails values(1021,EncryptByKey(Key_GUID(N'CCEncrypt'),'3334-6666-3456-4567'),'Ajinkya',
   01,'2024','02474',847);
  INSERT into CardDetails values(1022,EncryptByKey(Key_GUID(N'CCEncrypt'),'3334-2776-7777-4567'),'Chenguang',
   09,'2026','60095',490);
  INSERT into CardDetails values(1023,EncryptByKey(Key_GUID(N'CCEncrypt'),'2314-1146-1456-8888'),'Tom',
   02,'2022','90033',995);
  
  ---Displaying Data from CardDetails Entity
 select *from CardDetails;
 
---Decrypting the encrypted CardNumbers
 select convert(varchar, DecryptByKey(CardNumber))
from CardDetails;

---Cleanup Functions
DROP TABLE CardDetails;
CLOSE SYMMETRIC KEY CCEncrypt; 








-- Table 3 - Server Location

CREATE TABLE dbo.ServerLocation (
ServerID VARCHAR(4) NOT NULL PRIMARY KEY,
ServerLocation VARCHAR(50)
);

CREATE PROCEDURE InsertServerData
@ServerNumber int, @ServerLocation VARCHAR(50) AS BEGIN
DECLARE @ServerID VARCHAR(4);

SELECT @ServerID = 'S' + RIGHT('00' + CAST (@ServerNumber AS VARCHAR(3)), 3)

INSERT INTO ServerLocation VALUES (@ServerID, @ServerLocation);

END

EXEC InsertServerData 1, 'US-East (N. Virginia)';
EXEC InsertServerData 2, 'US-East (Ohio)';
EXEC InsertServerData 3, 'US-West (N. California)';
EXEC InsertServerData 4, 'US-West (Oregon)';
EXEC InsertServerData 5, 'Asia Pacific (Mumbai)';
EXEC InsertServerData 6, 'Europe (Stockholm)';
EXEC InsertServerData 7, 'Europe (Milan)';
EXEC InsertServerData 8, 'Europe (Frankfurt)';
EXEC InsertServerData 9, 'Europe (Ireland)';
EXEC InsertServerData 10, 'Europe (Paris)';


-- Clean up functions

DROP PROC InsertServerData;
DROP TABLE ServerLocation;





-- TABLE 4 Machine Image

CREATE TABLE MachineImage(MachineImageID varchar(6) NOT NULL PRIMARY KEY,
OperatingSystem varchar(100),
ServerID varchar(4) references ServerLocation(ServerID));

drop table MachineImage;
SELECT *from MachineImage order by ServerID ;

CREATE PROCEDURE InsertMachineImageData
@MachineImageNumber int, @OperatingSystem VARCHAR(80), @ServerID varchar(4)
AS BEGIN
DECLARE @MachineImageID VARCHAR(6);

SELECT @MachineImageID = 'MI' + RIGHT('00' + CAST (@MachineImageNumber AS VARCHAR(5)), 5)

INSERT INTO MachineImage VALUES (@MachineImageID, @OperatingSystem, @ServerID);

END

drop proc InsertMachineImageData;

EXEC InsertMachineImageData 1,'Red Hat Enterprise Linux 8 (HVM), SSD Volume Type' ,'S001';
EXEC InsertMachineImageData 2,'SUSE Linux Enterprise Server 12 SP5 (HVM), SSD Volume Type' ,'S001';
EXEC InsertMachineImageData 3,'Deep Learning Base AMI (Amazon Linux) Version 25.0 ' ,'S001';
EXEC InsertMachineImageData 4,'Deep Learning Base AMI (Ubuntu 16.04) Version 25.0' ,'S001';
EXEC InsertMachineImageData 5,'Microsoft Windows Server 2019 Base' ,'S001';
EXEC InsertMachineImageData 6,'Amazon Linux 2 AMI (HVM), SSD Volume Type ' ,'S002';
EXEC InsertMachineImageData 7,'Red Hat Enterprise Linux 8 (HVM), SSD Volume Type' ,'S002';
EXEC InsertMachineImageData 8,'SUSE Linux Enterprise Server 15 SP1 (HVM), SSD Volume Type ' ,'S002';
EXEC InsertMachineImageData 9,'Ubuntu Server 18.04 LTS (HVM), SSD Volume Type ' ,'S002';
EXEC InsertMachineImageData 10,'Microsoft Windows Server 2019 Base' ,'S002';
EXEC InsertMachineImageData 11,'Red Hat Enterprise Linux 8 (HVM), SSD Volume Type ' ,'S003';
EXEC InsertMachineImageData 12,'SUSE Linux Enterprise Server 12 SP5 (HVM), SSD Volume Type' ,'S003';
EXEC InsertMachineImageData 13,'Deep Learning Base AMI (Amazon Linux) Version 25.0 ' ,'S003';
EXEC InsertMachineImageData 14,'Ubuntu Server 16.04 LTS (HVM), SSD Volume Type ' ,'S003';
EXEC InsertMachineImageData 15,'Microsoft Windows Server 2019 Base' ,'S003';
EXEC InsertMachineImageData 16,'Red Hat Enterprise Linux 8 (HVM), SSD Volume Type ' ,'S004';
EXEC InsertMachineImageData 17,'SUSE Linux Enterprise Server 12 SP5 (HVM), SSD Volume Type' ,'S004';
EXEC InsertMachineImageData 18,'Deep Learning Base AMI (Amazon Linux) Version 25.0 ' ,'S004';
EXEC InsertMachineImageData 19,'Ubuntu Server 16.04 LTS (HVM), SSD Volume Type ' ,'S004';
EXEC InsertMachineImageData 20,'Microsoft Windows Server 2019 Base' ,'S004';
EXEC InsertMachineImageData 21,'Red Hat Enterprise Linux 8 (HVM), SSD Volume Type ' ,'S005';
EXEC InsertMachineImageData 22,'SUSE Linux Enterprise Server 12 SP5 (HVM), SSD Volume Type' ,'S005';
EXEC InsertMachineImageData 23,'Deep Learning Base AMI (Amazon Linux) Version 25.0 ' ,'S005';
EXEC InsertMachineImageData 24,'Ubuntu Server 16.04 LTS (HVM), SSD Volume Type ' ,'S005';
EXEC InsertMachineImageData 25,'Microsoft Windows Server 2019 Base' ,'S005';
EXEC InsertMachineImageData 26,'Red Hat Enterprise Linux 8 (HVM), SSD Volume Type ' ,'S006';
EXEC InsertMachineImageData 27,'SUSE Linux Enterprise Server 12 SP5 (HVM), SSD Volume Type' ,'S006';
EXEC InsertMachineImageData 28,'Deep Learning Base AMI (Amazon Linux) Version 25.0 ' ,'S006';
EXEC InsertMachineImageData 29,'Ubuntu Server 16.04 LTS (HVM), SSD Volume Type ' ,'S006';
EXEC InsertMachineImageData 30,'Microsoft Windows Server 2019 Base' ,'S006';
EXEC InsertMachineImageData 31,'Red Hat Enterprise Linux 8 (HVM), SSD Volume Type ' ,'S007';
EXEC InsertMachineImageData 32,'SUSE Linux Enterprise Server 12 SP5 (HVM), SSD Volume Type' ,'S007';
EXEC InsertMachineImageData 33,'Deep Learning Base AMI (Amazon Linux) Version 25.0 ' ,'S007';
EXEC InsertMachineImageData 34,'Ubuntu Server 16.04 LTS (HVM), SSD Volume Type ' ,'S007';
EXEC InsertMachineImageData 35,'Microsoft Windows Server 2019 Base' ,'S007';
EXEC InsertMachineImageData 36,'Red Hat Enterprise Linux 8 (HVM), SSD Volume Type ' ,'S008';
EXEC InsertMachineImageData 37,'SUSE Linux Enterprise Server 12 SP5 (HVM), SSD Volume Type' ,'S008';
EXEC InsertMachineImageData 38,'Deep Learning Base AMI (Amazon Linux) Version 25.0 ' ,'S008';
EXEC InsertMachineImageData 39,'Ubuntu Server 16.04 LTS (HVM), SSD Volume Type ' ,'S008';
EXEC InsertMachineImageData 40,'Microsoft Windows Server 2019 Base' ,'S008';
EXEC InsertMachineImageData 41,'Red Hat Enterprise Linux 8 (HVM), SSD Volume Type ' ,'S009';
EXEC InsertMachineImageData 42,'SUSE Linux Enterprise Server 12 SP5 (HVM), SSD Volume Type' ,'S009';
EXEC InsertMachineImageData 43,'Deep Learning Base AMI (Amazon Linux) Version 25.0 ' ,'S009';
EXEC InsertMachineImageData 44,'Ubuntu Server 16.04 LTS (HVM), SSD Volume Type ' ,'S009';
EXEC InsertMachineImageData 45,'Microsoft Windows Server 2019 Base' ,'S009';
EXEC InsertMachineImageData 46,'Red Hat Enterprise Linux 8 (HVM), SSD Volume Type ' ,'S010';
EXEC InsertMachineImageData 47,'SUSE Linux Enterprise Server 12 SP5 (HVM), SSD Volume Type' ,'S010';
EXEC InsertMachineImageData 48,'Deep Learning Base AMI (Amazon Linux) Version 25.0 ' ,'S010';
EXEC InsertMachineImageData 49,'Ubuntu Server 16.04 LTS (HVM), SSD Volume Type ' ,'S010';
EXEC InsertMachineImageData 50,'Microsoft Windows Server 2019 Base' ,'S010';





-- Table 5 Instances

---Creating the table Instances
CREATE TABLE Instances(InstanceID INT NOT NULL PRIMARY KEY,
InstanceType nvarchar(30),
InstanceFamily varchar(20),
ServerID varchar(4),
vCPUs int,
Architecture varchar(10),
Cores int,
Memory int,
Storage int,
StorageType varchar(10),
OnDemandInstancePricing float); 

---Inserted the data using sql import wizard

---Displaying all the Instances Data
select *from Instances;

---CleanUp Functions
DROP table Instances;





-- Table 6 InstanceConfig

CREATE TABLE InstanceConfig(
ConfigurationID INT IDENTITY(1000,1) NOT NULL PRIMARY KEY,
Network varchar(50),
Subnet varchar(50),
InstanceID int not null references Instances(InstanceID)
);

insert into InstanceConfig values('vpc-ec37cb8a(default)','Subnet-5a38973c|Default in us-west 1b',50);
insert into InstanceConfig values('vpc-739b4318(default)','Subnet-a20f31d8|Default in us-east 2b',50);
insert into InstanceConfig values('vpc-4b77d721(default)','Subnet-d8be78a4|Default in eu-central 1b',71);
insert into InstanceConfig values('vpc-4b77d721(default)','Subnet-77de551d|Default in eu-central 1a',75);
insert into InstanceConfig values('vpc-4b77d721(default)','Subnet-bfc316f3|Default in eu-central 1a',59);
insert into InstanceConfig values('vpc-8205fefb(default)','Subnet-13196849|Default in eu-west 1b',83);
insert into InstanceConfig values('vpc-4b77d721(default)','Subnet-a20f31d8|Default in eu-central 1b',85);
insert into InstanceConfig values('vpc-4b77d721(default)','Subnet-a20f31d8|Default in eu-central 1c',89);
insert into InstanceConfig values('vpc-bfb255d7(default)','Subnet-a20f31d8|Default in eu-west 3b',93);
insert into InstanceConfig values('vpc-bfb255d7(default)','Subnet-a20f31d8|Default in eu-west 3a',97);
INSERT INTO InstanceConfig VALUES ('vpc-05877078(default)','Subnet-27a57e41|Default in us-east-1a', 2);
INSERT INTO InstanceConfig VALUES ('vpc-05877078(default)','Subnet-113e9830|Default in us-east-1b', 6);
INSERT INTO InstanceConfig VALUES ('vpc-05877078(default)','Subnet-1391fa5e|Default in us-east-1c', 9);
INSERT INTO InstanceConfig VALUES ('vpc-9e75a9f5(default)','Subnet-26300d5c|Default in us-east-2b', 11);
INSERT INTO InstanceConfig VALUES ('vpc-9e75a9f5(default)','Subnet-f9854292|Default in us-east-2a', 15);
INSERT INTO InstanceConfig VALUES ('vpc-9e75a9f5(default)','Subnet-33bbde7f|Default in us-east-2c', 18);
INSERT INTO InstanceConfig VALUES ('vpc-ec35c98a(default)','Subnet-471be01d|Default in us-west-1c', 23);
INSERT INTO InstanceConfig VALUES ('vpc-ec35c98a(default)','Subnet-5a3a953c|Default in us-west-1a', 27);
INSERT INTO InstanceConfig VALUES ('vpc-03dcc66b(default)','Subnet-c028588c|Default in ap-south-1b', 42);
INSERT INTO InstanceConfig VALUES ('vpc-03dcc66b(default)','Subnet-863388fd|Default in ap-south-1c', 48);







-- Table 7 Additional Storage

USE CloudComputingDatabase_Team01;


CREATE TABLE dbo.AdditionalStorage (
StorageID int IDENTITY Primary KEY, 
VolumeType Char(25),
VolumeSizeinGB int,
ProvisionedIOPS int,
AdditionalStoragePrice float);

DROP TABLE dbo.AdditionalStorage;

SET IDENTITY_INSERT dbo.AdditionalStorage OFF;

--IOPS is considered only for ProvisionedIOPSSSD
-- AdditionalStoragePrice is a one-time Cost

INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',10000,NULL, 210.63);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',5000,NULL, 105.63);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',2500,NULL, 53.13);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',500,NULL, 11.13);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',250,NULL, 5.88);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',100,NULL, 2.73);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',10000,NULL, 210.63);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',5000,NULL, 105.63);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',2500,NULL, 53.13);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',500,NULL, 11.13);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',250,NULL, 5.88);
INSERT INTO dbo.additionalStorage VALUES ('GeneralPurposeSSD',100,NULL, 2.73);
INSERT INTO dbo.additionalStorage VALUES ('ProvisionedIOPsSSD',10000,100000, 1155.63);
INSERT INTO dbo.AdditionalStorage VALUES ('ProvisionedIOPsSSD',5000,10000,254.13);
INSERT INTO dbo.AdditionalStorage VALUES ('ProvisionedIOPsSSD', 2500,5000,107.98)
INSERT INTO dbo.AdditionalStorage VALUES ('ProvisionedIOPsSSD', 500,2500,35.63);
INSERT INTO dbo.AdditionalStorage VALUES ('ProvisionedIOPsSSD', 250,1000,15.98);
INSERT INTO dbo.AdditionalStorage VALUES ('ProvisionedIOPsSSD', 100,1000,12.18);
INSERT INTO dbo.additionalStorage VALUES ('ProvisionedIOPsSSD',10000,100000, 1155.63);
INSERT INTO dbo.AdditionalStorage VALUES ('ProvisionedIOPsSSD',5000,10000,254.13);
INSERT INTO dbo.AdditionalStorage VALUES ('ProvisionedIOPsSSD', 2500,5000,107.98)
INSERT INTO dbo.AdditionalStorage VALUES ('ProvisionedIOPsSSD', 500,2500,35.63);
INSERT INTO dbo.AdditionalStorage VALUES ('ProvisionedIOPsSSD', 250,1000,15.98);
INSERT INTO dbo.AdditionalStorage VALUES ('ProvisionedIOPsSSD', 100,1000,12.18);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',10000,NULL, 133.63);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',5000,NULL, 67.13);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',2500,NULL, 33.88);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',500,NULL, 7.28);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',250,NULL, 3.95);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',100,NULL, 1.96);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',10000,NULL, 133.63);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',5000,NULL, 67.13);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',2500,NULL, 33.88);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',500,NULL, 7.28);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',250,NULL, 3.95);
INSERT INTO dbo.additionalStorage VALUES ('ThroughputOptimizedHDD',100,NULL, 1.96);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',10000,NULL, 105.63);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',5000,NULL, 53.13);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',2500,NULL, 26.88);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',500,NULL, 5.88);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',250,NULL, 3.26);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',100,NULL, 1.68);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',10000,NULL, 105.63);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',5000,NULL, 53.13);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',2500,NULL, 26.88);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',500,NULL, 5.88);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',250,NULL, 3.26);
INSERT INTO dbo.additionalStorage VALUES ('ColdHDD',100,NULL, 1.68);





-- Table 8 SaleMaster

-- Creating SaleMaster Table

CREATE TABLE dbo.SaleMaster (
MasterID int IDENTITY(200, 1) NOT NULL,
UserID int REFERENCES dbo.UserInfo(UserID),
MachineImageID VARCHAR(6) REFERENCES dbo.MachineImage(MachineImageID),
InstanceID int REFERENCES dbo.Instances(InstanceID),
StorageID int REFERENCES dbo.AdditionalStorage(StorageID)
PRIMARY KEY (MasterID)
);


-- Inserting values

INSERT INTO dbo.SaleMaster VALUES (1001, 'MI004', 3, NULL);
INSERT INTO dbo.SaleMaster VALUES (1002, 'MI013', 5, 1);
INSERT INTO dbo.SaleMaster VALUES (1003, 'MI038', 71, 3);
INSERT INTO dbo.SaleMaster VALUES (1004, 'MI010', 10, 5);
INSERT INTO dbo.SaleMaster VALUES (1005, 'MI012', 23, NULL);
INSERT INTO dbo.SaleMaster VALUES (1006, 'MI008', 18, 6);
INSERT INTO dbo.SaleMaster VALUES (1007, 'MI016', 32, 11);
INSERT INTO dbo.SaleMaster VALUES (1008, 'MI017', 31, 15);
INSERT INTO dbo.SaleMaster VALUES (1009, 'MI017', 31, 15);
INSERT INTO dbo.SaleMaster VALUES (1010, 'MI020', 39, 37);
INSERT INTO dbo.SaleMaster VALUES (1001, 'MI034', 69, 19);
INSERT INTO dbo.SaleMaster VALUES (1002, 'MI036', 75, 19);
INSERT INTO dbo.SaleMaster VALUES (1003, 'MI028', 57, 38);
INSERT INTO dbo.SaleMaster VALUES (1004, 'MI025', 44, 24);
INSERT INTO dbo.SaleMaster VALUES (1005, 'MI030', 59, NULL);
INSERT INTO dbo.SaleMaster VALUES (1015, 'MI036', 75, 15);
INSERT INTO dbo.SaleMaster VALUES (1007, 'MI008', 18, 11);
INSERT INTO dbo.SaleMaster VALUES (1008, 'MI020', 39, 15);
INSERT INTO dbo.SaleMaster VALUES (1011, 'MI017', 31, 15);
INSERT INTO dbo.SaleMaster VALUES (1012, 'MI020', 39, 37);
INSERT INTO dbo.SaleMaster VALUES (1023, 'MI021', 4, 34);
INSERT INTO dbo.SaleMaster VALUES (1021, 'MI017', 54, 12);
INSERT INTO dbo.SaleMaster VALUES (1018, 'MI005', 23, 02);
INSERT INTO dbo.SaleMaster VALUES (1012, 'MI007', 75, 09);
INSERT INTO dbo.SaleMaster VALUES (1019, 'MI021', 23, 10);
INSERT INTO dbo.SaleMaster VALUES (1001, 'MI039', 56, NULL);
INSERT INTO dbo.SaleMaster VALUES (1011, 'MI012', 21, 27);
INSERT INTO dbo.SaleMaster VALUES (1005, 'MI009', 54, 40);
INSERT INTO dbo.SaleMaster VALUES (1002, 'MI034', 21, 23);
INSERT INTO dbo.SaleMaster VALUES (1010, 'MI023', 12, 06);
INSERT INTO dbo.SaleMaster VALUES (1021, 'MI024', 42, 10);
INSERT INTO dbo.SaleMaster VALUES (1020, 'MI012', 15, 05);
INSERT INTO dbo.SaleMaster VALUES (1021, 'MI023', 76, 48);
INSERT INTO dbo.SaleMaster VALUES (1012, 'MI043', 85, NULL);
INSERT INTO dbo.SaleMaster VALUES (1001, 'MI050', 94, 37);
INSERT INTO dbo.SaleMaster VALUES (1005, 'MI032', 47, 29);
INSERT INTO dbo.SaleMaster VALUES (1023, 'MI025', 57, NULL);
INSERT INTO dbo.SaleMaster VALUES (1017, 'MI035', 84, 44);
INSERT INTO dbo.SaleMaster VALUES (1018, 'MI049', 31, 48);
INSERT INTO dbo.SaleMaster VALUES (1012, 'MI017', 32, 12);
INSERT INTO dbo.SaleMaster VALUES (1007, 'MI047', 45, 46);
INSERT INTO dbo.SaleMaster VALUES (1001, 'MI039', 35, 30);
INSERT INTO dbo.SaleMaster VALUES (1012, 'MI013', 89, 29);



-- Clean up functions

DROP TABLE dbo.SaleMaster;

SELECT * FROM userinfo;







-- Table 9 SecurityGroups

DROP TABLE dbo.SecurityGroups;
--Creating Table
CREATE TABLE dbo.SecurityGroups (
SecurityGroupID varchar(20) PRIMARY KEY, MasterID int REFERENCES dbo.SaleMaster(MasterID), SecurityGroupName varchar(20), VPCID varchar(12), InboundRulesCount int, OutboundRulesCount int );

-- Procedure

CREATE PROCEDURE InsertSecurityGroup
@groupid int, @MasterID int, @SecurityGroupName varchar(20), @idvpc varchar(5), @InboundRulesCount int, @OutboundRulesCount int
AS BEGIN
DECLARE @SecurityGroupID varchar(20);
DECLARE @VPCID varchar(12);

SELECT @SecurityGroupID = 'sg-cab' + RIGHT('00' + CAST(@groupid AS Varchar),2)+ 'eb2'
SELECT @VPCID = 'vpc-c' + CAST(@idvpc AS Varchar) + 'ee2ad'

INSERT INTO dbo.SecurityGroups VALUES (@SecurityGroupID, @MasterID,@SecurityGroupName, @VPCID, @InboundRulesCount, @OutboundRulesCount);

END


--DROP PROC InsertSecurityGroup;

--Running Stored Procedure and populatingtable
EXEC InsertSecurityGroup 01,200, 'Default',63,3,4;
EXEC InsertSecurityGroup 02,201, 'Default',64,5,2;
EXEC InsertSecurityGroup 03,202, 'JohnsonsVPC',12,4,6;
EXEC InsertSecurityGroup 04,203, 'Default',65,1,2;
EXEC InsertSecurityGroup 05,204, 'Xins VPC',99,6,4;
EXEC InsertSecurityGroup 06,205, 'Default',66,6,8;
EXEC InsertSecurityGroup 07,206, 'Default',67,1,3;
EXEC InsertSecurityGroup 08,207, 'Arturos',12,13,14;
EXEC InsertSecurityGroup 09,208, 'Default',68,4,8;
EXEC InsertSecurityGroup 10,209, 'MartinsInst',12,6,4;
EXEC InsertSecurityGroup 11,210, 'Default',69,1,4;
EXEC InsertSecurityGroup 12,211, 'Default',70,8,3;
EXEC InsertSecurityGroup 13,212, 'Default',71,2,9;
EXEC InsertSecurityGroup 14,213, 'Default',72,8,10;
EXEC InsertSecurityGroup 15,214, 'ChaosVPC',14,17,14;
EXEC InsertSecurityGroup 16,215, 'FranksVPC',11,13,19;
EXEC InsertSecurityGroup 17,216, 'Default',73,8,2;
EXEC InsertSecurityGroup 18,217, 'Default',74,3,4;
EXEC InsertSecurityGroup 19,218, 'NikitasVPC',15,0,3;
EXEC InsertSecurityGroup 20,219, 'Default',75,5,7;







--- Table 10 - Tags


-- Creating table for Tags

CREATE TABLE dbo.Tags
(TagKey int IDENTITY(501, 1) NOT NULL PRIMARY KEY,
TagValue varchar(256) CONSTRAINT lengthCheck CHECK (DATALENGTH(TagValue) <= 256),
MasterID int NOT NULL REFERENCES SaleMaster(MasterID)
);

INSERT INTO dbo.Tags VALUES ('JohnsonConfig1', 210);
INSERT INTO dbo.Tags VALUES ('ZlatonConfiguration', 207);
INSERT INTO dbo.Tags VALUES ('Terry_Conf', 202);
INSERT INTO dbo.Tags VALUES ('LopezConfig', 216);
INSERT INTO dbo.Tags VALUES ('MehtaConf', 213);
INSERT INTO dbo.Tags VALUES ('JohnsonConfig2', 200);
INSERT INTO dbo.Tags VALUES ('ChaoConfiguration', 204);
INSERT INTO dbo.Tags VALUES ('HarerraConf', 205);
INSERT INTO dbo.Tags VALUES ('BeckhamConfig', 219);
INSERT INTO dbo.Tags VALUES ('ChaoConf', 214);


-- Clean up functions
DROP TABLE dbo.Tags;





-- Table 11 Activity Tracker

CREATE TABLE dbo.ActivityTracker (ActivityID int IDENTITY(1001,1) PRIMARY KEY, MasterId int REFERENCES dbo.SaleMaster(MasterID), LaunchDTTM DateTime, EndDTTM Datetime, TotalActiveTime AS DATEDIFF(minute,LaunchDTTM,EndDTTM));


--- An activityID is created only when the Instance is launched by the user.
--- Accordingly, the launch and end time is stored for that paticular ActivityID and the TotalActiveTime is  calculated

INSERT INTO dbo.ActivityTracker VALUES (216,'01-15-2020 12:12:00', '01-15-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (207,'01-15-2020 16:05:00', '01-15-2020 23:24:02');
INSERT INTO dbo.ActivityTracker VALUES (212,'01-16-2020 01:17:06', '01-16-2020 11:47:04');
INSERT INTO dbo.ActivityTracker VALUES (219,'01-16-2020 12:32:42', '01-16-2020 19:36:12');
INSERT INTO dbo.ActivityTracker VALUES (202,'01-16-2020 20:16:02', '01-17-2020 09:15:57');
INSERT INTO dbo.ActivityTracker VALUES (209,'01-16-2020 22:44:50', '01-18-2020 01:24:52');
INSERT INTO dbo.ActivityTracker VALUES (213,'01-17-2020 03:52:30', '01-17-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (219,'01-18-2020 05:32:00', '01-18-2020 23:31:35');
INSERT INTO dbo.ActivityTracker VALUES (218,'01-19-2020 03:17:55', '01-19-2020 12:19:38');
INSERT INTO dbo.ActivityTracker VALUES (202,'01-20-2020 12:12:32', '01-20-2020 13:11:22');
INSERT INTO dbo.ActivityTracker VALUES (207,'01-20-2020 04:12:47', '01-20-2020 18:19:51');
INSERT INTO dbo.ActivityTracker VALUES (216,'01-20-2020 12:12:00', '01-21-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (219,'01-21-2020 12:14:05', '01-21-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (201,'01-22-2020 04:56:00', '01-22-2020 09:24:12');
INSERT INTO dbo.ActivityTracker VALUES (208,'01-22-2020 09:45:10', '01-23-2020 12:56:32');
INSERT INTO dbo.ActivityTracker VALUES (209,'01-22-2020 15:10:00', '01-22-2020 18:33:02');
INSERT INTO dbo.ActivityTracker VALUES (215,'01-23-2020 14:22:00', '01-23-2020 17:21:15');
INSERT INTO dbo.ActivityTracker VALUES (212,'01-23-2020 16:33:54', '01-23-2020 21:55:43');
INSERT INTO dbo.ActivityTracker VALUES (207,'01-24-2020 05:22:35', '01-24-2020 12:18:22');
INSERT INTO dbo.ActivityTracker VALUES (208,'01-24-2020 09:43:23', '01-24-2020 14:14:52');
INSERT INTO dbo.ActivityTracker VALUES (210,'01-25-2020 00:15:00', '01-25-2020 02:12:02');
INSERT INTO dbo.ActivityTracker VALUES (212,'01-25-2020 06:00:00', '01-25-2020 12:15:09');
INSERT INTO dbo.ActivityTracker VALUES (265,'01-26-2020 12:14:05', '01-27-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (201,'01-27-2020 04:56:00', '01-27-2020 09:24:12');
INSERT INTO dbo.ActivityTracker VALUES (208,'01-28-2020 09:45:10', '01-28-2020 12:56:32');
INSERT INTO dbo.ActivityTracker VALUES (209,'01-28-2020 15:10:00', '01-28-2020 18:33:02');
INSERT INTO dbo.ActivityTracker VALUES (215,'01-29-2020 14:22:00', '01-29-2020 17:21:15');
INSERT INTO dbo.ActivityTracker VALUES (212,'01-29-2020 16:33:54', '01-29-2020 21:55:43');
INSERT INTO dbo.ActivityTracker VALUES (207,'01-30-2020 05:22:35', '01-30-2020 12:18:22');
INSERT INTO dbo.ActivityTracker VALUES (208,'01-30-2020 09:43:23', '01-30-2020 14:14:52');
INSERT INTO dbo.ActivityTracker VALUES (210,'01-31-2020 00:15:00', '02-01-2020 02:12:02');
INSERT INTO dbo.ActivityTracker VALUES (212,'01-31-2020 06:00:00', '02-02-2020 12:15:09');
INSERT INTO dbo.ActivityTracker VALUES (219,'02-01-2020 12:14:05', '02-02-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (201,'02-01-2020 04:56:00', '02-01-2020 09:24:12');
INSERT INTO dbo.ActivityTracker VALUES (208,'02-02-2020 09:45:10', '02-02-2020 12:56:32');
INSERT INTO dbo.ActivityTracker VALUES (209,'02-03-2020 15:10:00', '02-04-2020 18:33:02');
INSERT INTO dbo.ActivityTracker VALUES (215,'02-04-2020 14:22:00', '02-05-2020 17:21:15');
INSERT INTO dbo.ActivityTracker VALUES (212,'02-05-2020 16:33:54', '02-05-2020 21:55:43');
INSERT INTO dbo.ActivityTracker VALUES (207,'02-06-2020 05:22:35', '02-06-2020 12:18:22');
INSERT INTO dbo.ActivityTracker VALUES (208,'02-06-2020 09:43:23', '02-07-2020 14:14:52');
INSERT INTO dbo.ActivityTracker VALUES (210,'02-07-2020 00:15:00', '02-08-2020 02:12:02');
INSERT INTO dbo.ActivityTracker VALUES (212,'02-08-2020 06:00:00', '02-08-2020 12:15:09');
INSERT INTO dbo.ActivityTracker VALUES (216,'02-08-2020 12:12:00', '02-09-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (207,'02-09-2020 16:05:00', '02-10-2020 23:24:02');
INSERT INTO dbo.ActivityTracker VALUES (212,'02-10-2020 01:17:06', '02-12-2020 11:47:04');
INSERT INTO dbo.ActivityTracker VALUES (219,'02-11-2020 12:32:42', '02-11-2020 19:36:12');
INSERT INTO dbo.ActivityTracker VALUES (202,'02-12-2020 20:16:02', '02-13-2020 09:15:57');
INSERT INTO dbo.ActivityTracker VALUES (209,'02-13-2020 22:44:50', '02-14-2020 01:24:52');
INSERT INTO dbo.ActivityTracker VALUES (213,'02-14-2020 03:52:30', '02-16-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (219,'02-14-2020 05:32:00', '02-14-2020 23:31:35');
INSERT INTO dbo.ActivityTracker VALUES (218,'02-16-2020 03:17:55', '02-17-2020 12:19:38');
INSERT INTO dbo.ActivityTracker VALUES (202,'02-17-2020 12:12:32', '02-17-2020 13:11:22');
INSERT INTO dbo.ActivityTracker VALUES (207,'02-19-2020 04:12:47', '02-20-2020 18:19:51');
INSERT INTO dbo.ActivityTracker VALUES (216,'02-20-2020 12:12:00', '02-21-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (216,'02-21-2020 12:12:00', '02-22-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (207,'02-22-2020 16:05:00', '02-23-2020 23:24:02');
INSERT INTO dbo.ActivityTracker VALUES (212,'02-23-2020 01:17:06', '02-23-2020 11:47:04');
INSERT INTO dbo.ActivityTracker VALUES (219,'02-24-2020 12:32:42', '02-24-2020 19:36:12');
INSERT INTO dbo.ActivityTracker VALUES (202,'02-24-2020 20:16:02', '02-25-2020 09:15:57');
INSERT INTO dbo.ActivityTracker VALUES (209,'02-25-2020 22:44:50', '02-26-2020 01:24:52');
INSERT INTO dbo.ActivityTracker VALUES (213,'02-26-2020 03:52:30', '02-26-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (219,'02-26-2020 05:32:00', '02-27-2020 23:31:35');
INSERT INTO dbo.ActivityTracker VALUES (218,'02-27-2020 03:17:55', '02-27-2020 12:19:38');
INSERT INTO dbo.ActivityTracker VALUES (202,'02-27-2020 12:12:32', '02-27-2020 13:11:22');
INSERT INTO dbo.ActivityTracker VALUES (207,'02-28-2020 04:12:47', '02-28-2020 18:19:51');
INSERT INTO dbo.ActivityTracker VALUES (216,'02-28-2020 12:12:00', '02-28-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (259,'02-28-2020 12:12:00', '02-28-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (243,'02-28-2020 12:12:00', '02-28-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (260,'03-01-2020 05:32:00', '03-03-2020 23:31:35');
INSERT INTO dbo.ActivityTracker VALUES (261,'03-02-2020 03:17:55', '03-03-2020 12:19:38');
INSERT INTO dbo.ActivityTracker VALUES (202,'03-03-2020 12:12:32', '03-04-2020 13:11:22');
INSERT INTO dbo.ActivityTracker VALUES (247,'03-04-2020 04:12:47', '03-04-2020 18:19:51');
INSERT INTO dbo.ActivityTracker VALUES (260,'03-05-2020 12:12:00', '03-06-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (261,'03-06-2020 16:05:00', '03-07-2020 23:24:02');
INSERT INTO dbo.ActivityTracker VALUES (261,'03-07-2020 01:17:06', '03-08-2020 11:47:04');
INSERT INTO dbo.ActivityTracker VALUES (254,'03-08-2020 16:33:54', '03-09-2020 21:55:43');
INSERT INTO dbo.ActivityTracker VALUES (207,'03-08-2020 05:22:35', '03-09-2020 12:18:22');
INSERT INTO dbo.ActivityTracker VALUES (260,'03-09-2020 09:43:23', '03-10-2020 14:14:52');
INSERT INTO dbo.ActivityTracker VALUES (254,'03-09-2020 00:15:00', '03-10-2020 02:12:02');
INSERT INTO dbo.ActivityTracker VALUES (259,'03-10-2020 06:00:00', '03-11-2020 12:15:09');
INSERT INTO dbo.ActivityTracker VALUES (254,'03-10-2020 12:14:05', '03-12-2020 14:14:02');
INSERT INTO dbo.ActivityTracker VALUES (259,'03-11-2020 04:56:00', '03-13-2020 09:24:12');
INSERT INTO dbo.ActivityTracker VALUES (254,'03-12-2020 09:45:10', '03-13-2020 12:56:32');






-- TABLE 12 Billing Info

--- CREATE TABLE BillingInformation
CREATE TABLE BillingInformation (BillingID INT IDENTITY(3000,1) NOT NULL PRIMARY KEY,
MasterID INT NOT NULL REFERENCES SaleMaster(MasterID),
ActivityID INT NOT NULL REFERENCES ActivityTracker(ActivityID),
FinalPrice FLOAT);

---CREATE TRIGGER TO POPULATE BillingInformation AFTER ActivityTracker IS POPULATED
CREATE TRIGGER FinalPrice ON
ActivityTracker 
AFTER
INSERT AS 
BEGIN 
	SET
		NOCOUNT ON;	
		DECLARE @finalPrice Float;
		DECLARE @TotatlActivityTime Float;
		DECLARE @InstancePrice FLOAT;
		DECLARE @ActivityID INT;
		DECLARE @MasterID INT;
		DECLARE @AdditionalStorage float;

SELECT
	@TotatlActivityTime = at2.TotalActiveTime ,
	@InstancePrice = i.OnDemandInstancePricing,
	@AdditionalStorage =ad.AdditionalStoragePrice 

FROM ActivityTracker at2
LEFT JOIN SaleMaster sm On
at2.MasterId = sm.MasterID
LEFT JOIN AdditionalStorage ad On
sm.StorageID = ad.StorageID
LEFT JOIN Instances i On
sm.InstanceID = i.InstanceID ;

SELECT
	@MasterId = ActivityTracker.MasterId
	@ActivityID = ActivityTracker.ActivityID
FROM ActivityTracker;

INSERT INTO BillingInformation ( MasterID, ActivityID, FinalPrice )
VALUES ( @MasterId , @ActivityID , (((@TotatlActivityTime / 60) * @InstancePrice )+@AdditionalStorage));
END 
---Display Table
SELECT *FROM BillingInformation ;

---Cleanup Functions
DROP TRIGGER FinalPrice;
DROP TABLE BillingInformation;





-- Table 13 Transactions

---CREATING Transactions TABLE
CREATE TABLE Transactions(TransactionsID int not null primary key identity(9876,1),
BillingID int references BillingInformation(BillingID),
CardID int references CardDetails(CardID),
[Date] date,
Amount float );

--- CREATING A FUNCTION TO CALCULATE BILLING PRICE(FINAL PRICE+TAX)
CREATE FUNCTION dbo.calculateBillingPrice(
@FinalPrice float
)
returns float 
as begin
	DECLARE @Taxes float;
	set @Taxes=0.08;
	return @FinalPrice+@FinalPrice*@Taxes
end;

---TRIGGER TO POPULATE Transactions
CREATE TRIGGER PopulateTransaction
on BillingInformation
AFTER 
INSERT AS 
BEGIN 
	SET
		NOCOUNT ON;	
		DECLARE @TransactionID INT;
		DECLARE @BillingID INT;
		DECLARE @CardID INT;
		DECLARE @Date1 DATE;
		DECLARE @FinalPrice FLOAT

SELECT @CardID = cd.CardID 
FROM BillingInformation bi 
LEFT JOIN SaleMaster sm ON bi.MasterId = sm.MasterID
LEFT JOIN UserInfo ui ON sm.UserID =ui.UserID 
LEFT JOIN CardDetails cd ON ui.UserID = cd.UserID ;

SELECT @Date1 = Actr.EndDTTM
FROM BillingInformation bi 
LEFT JOIN ActivityTracker Actr 
ON bi.MasterID = Actr.MasterID 
AND bi.ActivityID  = Actr.ActivityID ;

SELECT
	@BillingID = bi.BillingID,
	@FinalPrice = bi.FinalPrice 
FROM
	BillingInformation bi
;

INSERT INTO Transactions ( BillingID, CardID, [Date], Amount )
VALUES ( @BillingID , @CardID , @Date1, dbo.calculateBillingPrice(@FinalPrice));

END

---Displaying data from Transactions Entity
SELECT *FROM Transactions;

---Cleanup functions 
DROP TABLE Transactions;
DROP FUNCTION dbo.calculateBillingPrice;
DROP TRIGGER PopulateTransaction;






