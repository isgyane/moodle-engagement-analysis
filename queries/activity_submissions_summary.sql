SELECT 
    activity_name,
    SUM(CASE WHEN has_submission = 'Yes' THEN 1 ELSE 0 END) AS submissions_yes,
    SUM(CASE WHEN has_submission = 'No' THEN 1 ELSE 0 END) AS submissions_no,
    COUNT(*) AS total_students,
    ROUND(SUM(CASE WHEN has_submission = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS submission_rate_percent
FROM (
    SELECT 
        c.id AS course_id,
        c.fullname AS course_name,
        cm.id AS cmid,
        m.name AS module_type,
        COALESCE(a.name, q.name) AS activity_name,
        u.id AS student_id,
        CONCAT(u.firstname, ' ', u.lastname) AS student_name,
        COUNT(sub.attempt_id) AS submission_count,
        CASE 
            WHEN COUNT(sub.attempt_id) > 0 THEN 'Yes' 
            ELSE 'No' 
        END AS has_submission
    FROM mdlvu_course c
    JOIN mdlvu_enrol e 
        ON e.courseid = c.id
    JOIN mdlvu_user_enrolments ue 
        ON ue.enrolid = e.id
    JOIN mdlvu_user u
        ON u.id = ue.userid
    JOIN mdlvu_role_assignments ra 
        ON ra.userid = u.id
    JOIN mdlvu_context ctx 
        ON ctx.id = ra.contextid
    JOIN mdlvu_course_modules cm 
        ON cm.course = c.id
    JOIN mdlvu_modules m 
        ON m.id = cm.module
    LEFT JOIN mdlvu_assign a 
        ON a.id = cm.instance AND m.name = 'assign'
    LEFT JOIN mdlvu_quiz q 
        ON q.id = cm.instance AND m.name = 'quiz'
    LEFT JOIN (
        SELECT id AS attempt_id, userid, assignment AS instance_id
        FROM mdlvu_assign_submission
        WHERE status = 'submitted'
        UNION ALL
        SELECT id AS attempt_id, userid, quiz AS instance_id
        FROM mdlvu_quiz_attempts
        WHERE state = 'finished'
    ) sub
        ON sub.instance_id = cm.instance
        AND sub.userid = u.id
    WHERE m.name IN ('assign', 'quiz')
      AND c.id = 30
      AND ra.roleid = 5
      AND ctx.contextlevel = 50
      AND ctx.instanceid = c.id
    GROUP BY c.id, c.fullname, cm.id, m.name, activity_name, u.id, student_name
) AS subquery
GROUP BY activity_name
ORDER BY activity_name;

