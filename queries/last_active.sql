-- Last access time for each user
SELECT 
    u.id AS user_id,
    u.firstname,
    u.lastname,
    COUNT(l.id) AS total_activities,
    FROM_UNIXTIME(MAX(l.timecreated)) AS last_access,
    DATEDIFF(NOW(), FROM_UNIXTIME(MAX(l.timecreated))) AS days_since_last_active
FROM mdlvu_logstore_standard_log l
JOIN mdlvu_user u 
    ON u.id = l.userid
JOIN mdlvu_role_assignments ra 
    ON ra.userid = u.id
JOIN mdlvu_context ctx 
    ON ctx.id = ra.contextid
WHERE l.courseid = 30
  AND ra.roleid = 5            -- Learner role
  AND ctx.contextlevel = 50    -- course level
  AND ctx.instanceid = 30      -- course ID
GROUP BY u.id, u.firstname, u.lastname
ORDER BY last_access DESC;