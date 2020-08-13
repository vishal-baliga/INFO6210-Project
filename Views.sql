USE CloudComputingDatabase_Team01;

/* View describing frequency of activity against each server location. */


CREATE VIEW ServerLocationSaleMaster AS
SELECT
	DISTINCT sl.ServerLocation,
	COUNT(atr.ActivityID) as 'Activity Frequency'
FROM
	ServerLocation sl
LEFT JOIN MachineImage mi ON
	sl.ServerID = mi.ServerID
LEFT JOIN SaleMaster sm ON
	sm.MachineImageID = mi.MachineImageID
LEFT JOIN ActivityTracker atr ON
	sm.MasterID = atr.MasterId
GROUP BY
	sl.ServerLocation;

SELECT
	*
FROM
	ServerLocationSaleMaster;



-- Total amount of Transactions per user

  CREATE VIEW UserInfoTransactions2
  AS  
  SELECT ui.UserID, ui.Firstname, ui.Lastname, sum(t.Amount) AS [TotalSum] 
	FROM SaleMaster sm 
	LEFT JOIN UserInfo ui ON sm.UserID = ui.UserID
	LEFT JOIN BillingInformation bi ON sm.MasterID = bi.MasterID 
	LEFT JOIN Transactions t ON bi.BillingID = t.BillingID
	GROUP BY ui.UserID, ui.Firstname, ui.Lastname  ;

-- Display View 
SELECT * from UserInfoTransactions2;




/* Report showing details of subscribed images for each user. */


SELECT
	DISTINCT sm.UserID, ui.FirstName, ui.LastName,
	STUFF ((
	SELECT
		', ' + RTRIM(CAST(MasterID as char))
	FROM
		SaleMaster
	WHERE
		UserID = sm.UserID
	GROUP BY
		MasterID
	ORDER BY
		sm.MasterID FOR XML PATH ('')), 1, 1, '') AS 'Subscribed Image ID'
FROM
	SaleMaster sm
	LEFT JOIN UserInfo ui ON sm.UserID = ui.UserID 
GROUP BY
	sm.UserID, sm.MasterId, ui.FirstName, ui.LastName
ORDER BY
	sm.UserID;





