WITH weekend_hours AS (
	SELECT
		emp_id,
        TIME(timestamp) AS hour,
        TIME(LAG(timestamp) OVER (PARTITION BY CAST(timestamp AS date), emp_id ORDER BY timestamp)) AS lag_hour,
        TIMEDIFF(TIME(timestamp), TIME(LAG(timestamp) OVER (PARTITION BY CAST(timestamp AS date), emp_id ORDER BY timestamp))) AS hours_work,
        HOUR(TIMEDIFF(TIME(timestamp), TIME(LAG(timestamp) OVER (PARTITION BY CAST(timestamp AS date), emp_id ORDER BY timestamp)))) AS log_hours
	FROM attendance
    WHERE DAYOFWEEK(timestamp) IN (7, 1)
)
    
SELECT
	emp_id, 
    SUM(log_hours) AS work_hours
FROM weekend_hours
GROUP BY emp_id
ORDER BY work_hours DESC;