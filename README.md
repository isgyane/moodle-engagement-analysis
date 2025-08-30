# 📊 Moodle Student Engagement Analysis

A SQL-based project to analyze **student activity and course engagement** in a Moodle LMS instance.  
This project was born out of my own need as an instructor running an online Excel class, where the default Moodle analytics were not enough to track meaningful engagement.  

<br/>

## 🚀 Project Overview
The goal of this project is to go beyond Moodle’s built-in analytics by building **custom SQL queries** that provide deeper insights into:
- Module completions  
- Student activity patterns  
- Completion rates and progress tracking  
- Early identification of disengaged students  

The queries were built and tested in **VS Code** with **SQLTools**, using a **MySQL/MariaDB backend**.

<br/>

## 🔑 Key Features
- **Completion Tracking:** Identify which modules students have completed (and which they are stuck on).  
- **Engagement Insights:** Compare login frequency and activity submissions across cohorts.  
- **Performance Monitoring:** Generate completion rates for individual students and groups.  
- **Instructor Support:** Help course managers detect struggling learners early.  

<br/>

## 🛠️ Tech Stack
- **SQL** (MySQL / MariaDB)  
- **VS Code + SQLTools** for development  
- **Moodle LMS database schema**  

<br/>

## 📂 Project Structure
```

moodle-engagement-analysis/
│
├── queries/
│   ├── module\_completion.sql
│   ├── student\_activity.sql
│   ├── completion\_rate.sql
│   └── disengaged\_students.sql
│
├── reports/
│   └── sample\_output.csv
│
└── README.md

````

<br/>

## ⚡ Example Queries
- **Track Module Completion**
```sql
SELECT u.id AS student_id, u.firstname, u.lastname,
       c.fullname AS course, cmc.completionstate AS status
FROM mdl_course_modules_completion cmc
JOIN mdl_user u ON cmc.userid = u.id
JOIN mdl_course_modules cm ON cmc.coursemoduleid = cm.id
JOIN mdl_course c ON cm.course = c.id;
````

* **Find Students at Risk (low engagement)**

```sql
SELECT u.id, u.firstname, u.lastname, COUNT(l.id) AS logins
FROM mdl_user u
LEFT JOIN mdl_logstore_standard_log l ON l.userid = u.id
WHERE l.timecreated > UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 14 DAY))
GROUP BY u.id
HAVING logins < 3;
```

<br/>

## 📊 Sample Insights

* % of students who completed each module
* Students who haven’t logged in for 14+ days
* Average completion rate per week
* Comparison of engagement across cohorts

<br/>

## 💡 Future Enhancements

* Automate queries into **scheduled reports**
* Integrate with **Power BI / Tableau** dashboards
* Build a **Python script** to export reports weekly
* Explore **AI-driven predictions** for dropout risks

<br/>

## 🙌 Acknowledgements

* Moodle LMS community for their documentation
* My students, who inspired this project by challenging me to find better engagement insights

<br/>
