SELECT 
    f.name AS feedback_name,
    fi.name AS question,
    fi.typ AS question_type,
    fv.value AS answer,
    COUNT(*) AS response_count
FROM mdlvu_feedback_value fv
JOIN mdlvu_feedback_item fi ON fi.id = fv.item
JOIN mdlvu_feedback f ON f.id = fi.feedback
WHERE f.course = 30                          -- Your course ID
  AND f.name LIKE '%Week%'                   -- Only feedbacks with 'Week' in name
GROUP BY f.name, fi.name, fi.typ, fv.value
ORDER BY f.name, fi.name, fv.value;
