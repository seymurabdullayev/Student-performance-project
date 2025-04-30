# Student-performance-project
A data analysis project exploring student attendance, course performance, and academic trends using SQL and Power BI.


## Project structure
1. University_students.sql - SQL file that builds and populates the database.
2. University_students_model_view.mwb - MySQL schema diagram for database structure.
3. Power BI Dashboards - Visual representations of selected analytical queries.
4. Questions results - CSV files generated from 12 SQL queries answering key business questions.
5. Tables - Contains 5 data tables used in the analysis ("students", "courses", "attendance", "grades" and "student_courses").

## 🛠️Technologies used 
1. Mockaroo.com - Used to generate realistic sample data for some database tables.
2. Python - Used to script and generate synthetic datasets for analysis.
3. MySQL - Relational database design, query writing include joins, subqueries and grouping.
4. Power BI - Data visualisation and storytelling via interactive dashboards.
5. GitHub - Version control and portfolio hosting.

## 🧹Data Preparation & Cleaning
After generating sample datasets using Mockaroo and Python, I thoroughly reviewed and standardized the data types and values in each table to ensure consistency, quality, and suitability for analysis. Key steps included:
- Converted improperly typed fields (e.g., from "TEXT") to more suitable types such as "VARCHAR", "DATE", "ENUM" etc.
- Reformatted textual date values into proper SQL "DATE" format.
- Cleaned and normalized categorical fields — for example, the "gender" column initially contained 9 inconsistent values (due to auto-generated data), which I consolidated into only two valid categories: "Male" and "Female".
- Defined "PRIMARY KEY" and "FOREIGN KEY" constraints to establish strong relationships between tables and enforce referential integrity
- Verified relational consistency across all tables to ensure accurate SQL joins and analysis.

These steps were essential for creating a clean, structured, and analysis-ready database for both SQL querying and Power BI visualization.

## 🔍Key Analytical Questions
Here are examples of the analytical questions I answered using SQL:
1. Which students have poor attendance records?
2. Which courses have the highest number of missed classes?
3. How has enrollment (enrollment_year) increased or decreased over the years?
4. What is the academic performance of students with the highest course load?

➡️ Each question was solved through an individual SQL query, and the corresponding result was saved as a separate CSV file.
All results can be found in the "Questions results" folder.

## 📊 Dashboard Previews
Here are a few Power BI visualizations based on SQL outputs:

