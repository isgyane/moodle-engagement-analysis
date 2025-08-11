SELECT 
    u.id AS user_id,
    u.firstname,
    u.lastname,
    COUNT(cmc.id) AS modules_completed,
    total_modules.total AS total_relevant_modules,
    ROUND(
        (COUNT(cmc.id) / total_modules.total) * 100,
        2
    ) AS completion_rate_percent
FROM mdlvu_course_modules_completion cmc
JOIN mdlvu_course_modules cm 
    ON cm.id = cmc.coursemoduleid
JOIN mdlvu_modules m
    ON m.id = cm.module
JOIN mdlvu_user u 
    ON u.id = cmc.userid
JOIN mdlvu_role_assignments ra 
    ON ra.userid = u.id
JOIN mdlvu_context ctx 
    ON ctx.id = ra.contextid
-- Subquery: total interactive modules in course 30
JOIN (
    SELECT COUNT(*) AS total
    FROM mdlvu_course_modules cm
    JOIN mdlvu_modules m ON m.id = cm.module
    WHERE cm.course = 30
      AND m.name IN ('assign', 'quiz', 'forum', 'lesson', 'scorm', 'h5pactivity')
) AS total_modules
WHERE cm.course = 30
  AND m.name IN ('assign', 'quiz', 'forum', 'lesson', 'scorm', 'h5pactivity')
  AND cmc.completionstate = 1      -- completed
  AND ra.roleid = 5                -- Learner role
  AND ctx.contextlevel = 50        -- course level
  AND ctx.instanceid = 30          -- course ID
GROUP BY u.id, u.firstname, u.lastname, total_modules.total
ORDER BY completion_rate_percent DESC;
