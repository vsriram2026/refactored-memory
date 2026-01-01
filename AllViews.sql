USE WebsiteData
GO

SELECT * FROM website_data
GO

--Visitor Type Summary (New vs Returning)

CREATE VIEW Visitor_Type_Summary AS
SELECT
CASE	
	WHEN Previous_Visits = 0 THEN 'New'
	ELSE 'Returning'
END AS Visitor_Type,
Traffic_Source,
COUNT(*) AS Sessions,
ROUND(AVG(Page_Views), 0) AS Avg_Page_Views,
ROUND(AVG(Session_Duration), 2) AS Avg_Session_Duration,
ROUND(AVG(Time_on_Page), 2) AS Avg_Time_on_Page,
ROUND(AVG(Conversion_Rate), 2) AS Avg_Conversion_Rate,
ROUND(AVG(Bounce_Rate), 2) AS Avg_Bounce_Rate
FROM website_data
GROUP BY CASE	
	WHEN Previous_Visits = 0 THEN 'New'
	ELSE 'Returning'
END,
Traffic_Source
GO

SELECT * FROM Visitor_Type_Summary

--Engagement Level Summary (Low/Medium/High)

GO

CREATE VIEW Engagement_Level_Summary AS
SELECT TOP 2000
Traffic_Source,
CASE
WHEN Page_Views <= 2 THEN 'Low Engagement'
WHEN Page_Views <= 5 THEN 'Medium Engagement'
ELSE 'High Engagement'
END AS Engagement_Level,
ROUND(AVG(Session_Duration), 2) AS Avg_Session_Duration,
ROUND(AVG(Bounce_Rate), 2) AS Avg_Bounce_Rate,
ROUND(AVG(Conversion_Rate), 2) AS Avg_Conversion_Rate
FROM website_data
GROUP BY
CASE
WHEN Page_Views <= 2 THEN 'Low Engagement'
WHEN Page_Views <= 5 THEN 'Medium Engagement'
ELSE 'High Engagement'
END, Traffic_Source
ORDER BY Traffic_Source
GO

SELECT * FROM Engagement_Level_Summary

--Traffic source visitor matrix

GO

CREATE VIEW Traffic_Source_Visitor_Matrix AS
SELECT
Traffic_Source,
CASE
	WHEN Previous_Visits = 0 THEN 'New'
	ELSE 'Returning'
END AS Visitor_Type,
COUNT (*) AS Sessions,
ROUND(AVG(Conversion_Rate), 2) AS Avg_Conversion_Rate,
ROUND(AVG(Bounce_Rate), 2) AS Avg_Bounce_Rate
FROM website_data
GROUP BY
Traffic_Source,
CASE
	WHEN Previous_Visits = 0 THEN 'New'
	ELSE 'Returning'
END;
GO

SELECT * FROM Traffic_Source_Visitor_Matrix

--High Value Session Summary
GO

CREATE VIEW High_Value_Session_Summary AS
SELECT
Traffic_Source,
COUNT(*) AS High_Value_Sessions,
ROUND(AVG(Conversion_Rate), 2) AS Avg_Conversion_Rate,
ROUND(MIN(Conversion_Rate), 2) AS Min_Conversion_Rate,
ROUND(MAX(Conversion_Rate), 2) AS Max_Conversion_Rate
FROM website_data
WHERE Conversion_Rate >= 0.5
GROUP BY Traffic_Source;
GO

--Join High Value Session Summary and Traffic Source Visitor Matrix (incomplete)

SELECT * FROM Traffic_Source_Visitor_Matrix
SELECT * FROM High_Value_Session_Summary

--Bounce Risk Summary
GO

CREATE VIEW Bounce_Risk_Summary AS
SELECT
Traffic_Source,
COUNT(*) AS Sessions,
ROUND(AVG(Time_on_Page), 2) AS Avg_Time_on_Page,
ROUND(AVG(Bounce_Rate), 2) AS Avg_Bounce_Rate
FROM website_data
GROUP BY Traffic_Source
HAVING AVG(Bounce_Rate) > 0.28;	 /* Average Bounce Rate across sources is 0.28 */
GO

SELECT * FROM Bounce_Risk_Summary

--Executive traffic summary
GO

CREATE VIEW Executive_Traffic_Summary AS
SELECT
Traffic_Source,
COUNT(*) AS Sessions,
ROUND(AVG(Page_Views), 2) AS Avg_Page_Views,
ROUND(AVG(Session_Duration), 2) AS Avg_Session_Duration,
ROUND(AVG(Bounce_Rate), 2) AS Avg_Bounce_Rate,
ROUND(AVG(Conversion_Rate), 2) AS Avg_Conversion_Rate
FROM website_data
GROUP BY Traffic_Source;

GO

SELECT * FROM Executive_Traffic_Summary



