/* Order in which to create tables:
1) Client
2) Employee
3) Office Employee
4) Site Employee
5) Site Manager Employee
6) Site Laborer Employee
7) Plan
8) Representative
9) Bid
10) Project
11) Labor Utilized
12) Project Manager
13) Approval Stamp
*/

/*Client Table Creation*/
CREATE TABLE Client_T
	(ClientID int not null CHECK (ClientID > 0),
	ClientName nvarchar(35) not null,
	ClientAddress nvarchar(100),
	ClientPhone char(10),
	CONSTRAINT Client_PK PRIMARY KEY (ClientID))

/*Bid Table Creation*/
CREATE TABLE Bid_T
	(BidID int not null CHECK (BidID > 0),
	BidEstAmount decimal(20,2) not null CHECK (BidEstAmount > 0.0),
	BidProjectedFinish datetime,
	BidDatedatetime default GETDATE() not null,
	ClientRequestID int not null CHECK (ClientRequestID > 0),
	ClientApprovalID int,
	OEmployeeID int not null CHECK (OEmployeeID > 0),
	CONSTRAINT Bid_PK PRIMARY KEY (BidID),
	CONSTRAINT Bid_FK1 FOREIGN KEY (ClientRequestID) REFERENCES Client_T (ClientID),
	CONSTRAINT Bid_FK2 FOREIGN KEY (ClientApprovalID) REFERENCES Client_T (ClientID),
	CONSTRAINT Bid_FK3 FOREIGN KEY (OEmployeeID) REFERENCES Office_Employee_T (OEmployeeID))

/*Project Table Creation*/
CREATE TABLE Project_T
	(ProjectID int not null CHECK (ProjectID > 0),
	ProjectName nvarchar(100),
	ProjectAddress nvarchar(100),
	ProjectContractSignDate datetime default GETDATE() not null,
	ProjectStartDate datetime,
	ProjectTotalCost decimal(20,2),
	ProjectEndDate datetime,
	BidID int not null CHECK (BidID > 0),
	ClientID int not null CHECK (ClientID > 0),
	PlanID int not null CHECK (PlanID > 0),
	CONSTRAINT Project_PK PRIMARY KEY (ProjectID),
	CONSTRAINT Project_FK1 FOREIGN KEY (BidID) REFERENCES Bid_T (BidID),
	CONSTRAINT Project_FK2 FOREIGN KEY (ClientID) REFERENCES Client_T (ClientID),
	CONSTRAINT Project_FK3 FOREIGN KEY (PlanID) REFERENCES Plan_T (PlanID))

/*Employee Table Creation*/
CREATE TABLE Employee_T
	(EmployeeID int not null CHECK (EmployeeID > 0),
	EmployeeName nvarchar(50) not null,
	EmployeePhone char(10),
	EmployeeDateHired datetime default GETDATE(),
	EmployeeType char(1) CHECK (EmployeeType IN ('S','O')) not null,
	CONSTRAINT Employee_PK PRIMARY KEY (EmployeeID))

/*Office Employee Table Creation*/
CREATE TABLE Office_Employee_T
	(OEmployeeID int not null CHECK (OEmployeeID > 0),
	OfficeHourlyRate decimal(9,2) CHECK (OfficeHourlyRate > 0.0),
	CONSTRAINT OfficeEmp_PK PRIMARY KEY (OEmployeeID),
	CONSTRAINT OfficeEmp_FK1 FOREIGN KEY (OEmployeeID) REFERENCES Employee_T (EmployeeID))

/*Site Employee Table Creation*/
CREATE TABLE Site_Employee_T
	(SEmployeeID int not null CHECK (SEmployeeID > 0),
	SEmployeeType char(1) CHECK (SEmployeeType IN ('M','L')) not null,
	CONSTRAINT SEmployee_PK PRIMARY KEY (SEmployeeID),
	CONSTRAINT SEmployee_FK FOREIGN KEY (SEmployeeID) REFERENCES Employee_T (EmployeeID))

/*Site Manager Employee Table Creation*/
CREATE TABLE Manager_Site_Employee_T
	(MSEmployeeID int not null CHECK (MSEmployeeID > 0),
	ManagerSalary decimal(9,2) CHECK (ManagerSalary > 0.0),
	CONSTRAINT MSEmployee_PK PRIMARY KEY (MSEmployeeID),
	CONSTRAINT MSEmployee_FK FOREIGN KEY (MSEmployeeID) REFERENCES Site_Employee_T (SEmployeeID))

/*Site Laborer Table Creation*/
CREATE TABLE Laborer_Site_Employee_T
	(LSEmployeeID int not null CHECK (LSEmployeeID > 0),
	LaborerHourlyRate decimal(9,2) CHECK (LaborerHourlyRate > 0.0)
	CONSTRAINT LSEmployee_PK PRIMARY KEY (LSEmployeeID),
	CONSTRAINT LSEmployee_FK FOREIGN KEY (LSEmployeeID) REFERENCES Site_Employee_T (SEmployeeID))

/*Labor Utilized Table Creation*/
CREATE TABLE Labor_Utilized_T
	(LaborUtilizedID int not null CHECK (LaborUtilizedID > 0),
	LSEmployeeID int not null CHECK (LSEmployeeID > 0),
	ProjectID int not null CHECK (ProjectID > 0),
	ShiftStartDate datetime,
	ShiftEndDate datetime,
	ShiftStartTime datetime,
	ShiftEndTime datetime,
	CONSTRAINT LaborUtilized_PK PRIMARY KEY (LaborUtilizedID),
	CONSTRAINT LaborUtilized_FK1 FOREIGN KEY (LSEmployeeID) REFERENCES Laborer_Site_Employee_T (LSEmployeeID),
	CONSTRAINT LaborUtilized_FK2 FOREIGN KEY (ProjectID) REFERENCES Project_T (ProjectID))

/*Project Manager Table Creation*/
CREATE TABLE Project_Manager_T
	(ProjectManagerID int not null CHECK (ProjectManagerID > 0),
	MSEmployeeID int not null CHECK (MSEmployeeID > 0),
	ProjectID int not null CHECK (ProjectID > 0),
	CONSTRAINT ProjectManager_PK PRIMARY KEY (ProjectManagerID),
	CONSTRAINT ProjectManager_FK1 FOREIGN KEY (MSEmployeeID) REFERENCES Manager_Site_Employee_T (MSEmployeeID),
	CONSTRAINT ProjectManager_FK2 FOREIGN KEY (ProjectID) REFERENCES Project_T (ProjectID))

/*Representative Table Creation*/
CREATE TABLE Representative_T
	(RepresentativeID int not null CHECK (RepresentativeID > 0),
	RepresentativeName nvarchar(50) not null,
	ClientID int not null CHECK (ClientID > 0),
	CONSTRAINT Representative_PK PRIMARY KEY (RepresentativeID),
	CONSTRAINT Representative_FK FOREIGN KEY (ClientID) REFERENCES Client_T (ClientID))

/*Approval Stamp Table Creation*/
CREATE TABLE Approval_Stamp_T
	(ApprovalStampID int not null CHECK (ApprovalStampID > 0),
	RepresentativeID int not null CHECK (RepresentativeID > 0),
	PlanID int not null CHECK (PlanID > 0),
	ApprovalStampDate datetime not null default GETDATE(),
	CONSTRAINT ApprovalStamp_PK PRIMARY KEY (ApprovalStampID),
	CONSTRAINT ApprovalStamp_FK FOREIGN KEY (RepresentativeID) REFERENCES Representative_T (RepresentativeID),
	CONSTRAINT ApprovalStamp_FK2 FOREIGN KEY (PlanID) REFERENCES Plan_T (PlanID))

/*Plan Table Creation*/
CREATE TABLE Plan_T
	(PlanID int not null CHECK (PlanID > 0),
	PlanDesigner nvarchar(50) not null,
	PlanDateCreated datetime,
	CONSTRAINT Plan_PK PRIMARY KEY (PlanID))
