/*External Views (Dynamic)*/

/*Manager Productivity*/
create view ManagerProductivity as
select managerDaysComplete.MSEmployeeID, Employee_T.EmployeeName , count(*) as NumberOfProjects, avg(managerDaysComplete.DaystoCompletion) as AvgDaysCompletion
from employee_t,
	(select DaysComplete.ProjectID, Project_Manager_T.MSEmployeeID,  DaysComplete.DaystoCompletion
	from project_manager_t,
		(select projectid, DATEDIFF(day, projectstartdate,projectenddate) as DaystoCompletion
		from Project_T
		where DATEDIFF(day, projectstartdate,projectenddate) > 0) as DaysComplete
	where Project_Manager_T.ProjectID = DaysComplete.ProjectID) as managerDaysComplete
where managerDaysComplete.MSEmployeeID = Employee_T.EmployeeID
group by managerDaysComplete.MSEmployeeID, Employee_T.EmployeeName

/*Bid Estimate vs. Final Total*/
create view BidEstvsFinalTot as
select Client_T.ClientID, client_t.ClientName, ProjTotal, sumBidEstimate, ProjTotal/sumBidEstimate *100  as PercentDiff
from bid_t, project_t, client_t,
	(select client_t.Clientid, Client_T.ClientName, sum(bidestamount) as sumBidEstimate, sum(projecttotalcost) as ProjTotal
	from Bid_T, Client_T, Project_T
	where Bid_T.ClientRequestID = Client_T.ClientID
	group by Client_T.ClientID, Client_T.ClientName) as avgBids
where avgBids.ClientID = Client_T.ClientID
	and Project_T.ClientID = avgBids.ClientID
	and Bid_T.ClientRequestID = avgBids.ClientID
	and ProjectTotalCost > 0
group by Client_T.ClientID, client_t.ClientName, ProjTotal, sumBidEstimate

/*Amount Paid to Laborers*/
create view AmountPaidToLaborers as 
select derivedtable.LSEmployeeID, hoursWorked, avghoursworked, cast(SUM(hoursWorked * LaborerHourlyRate)as decimal (10,2)) as PaidAmount
from Labor_Utilized_T, Laborer_Site_Employee_T,
	(select Laborer_Site_Employee_T.LSEmployeeID, cast(sum(DATEDIFF(minute, shiftstarttime,shiftendtime)/60.0) as decimal (10,2)) as hoursWorked, 
		cast(AVG(datediff(minute,shiftstarttime,shiftendtime)/60.0) as decimal (10,2)) as avghoursworked
	from Labor_Utilized_T, Laborer_Site_Employee_T
	where Labor_Utilized_T.LSEmployeeID = Laborer_Site_Employee_T.LSEmployeeID
	group by Laborer_Site_Employee_T.LSEmployeeID) as derivedtable
where Labor_Utilized_T.LSEmployeeID = derivedtable.LSEmployeeID
	and Laborer_Site_Employee_T.LSEmployeeID = Labor_Utilized_T.LSEmployeeID
group by derivedtable.LSEmployeeID, hoursWorked, avghoursworked
