# EventData

**Prerequisite**
There are two directories in the main branch, for Task1 and Task2.
The sql code mentioned in the Task 2 is dependent on Execution of all the sql codes which are there in Task 1.


**Steps :**

1. Create all the table structures.DDLs of all the tables have been provided in Task1/DDL.sql
2. Copy the data from event_data.csv and user_data.csv into sandbox.stageUserData and sandbox.stageEventData respectively using either the copy command or insert statements provided in the directory. i.e. copy sandbox.stageUserData from 'user_data.csv' DELIMITER ';' CSV HEADER;  copy sandbox.stageEventData from 'event_data.csv' DELIMITER ';' CSV HEADER; 
3. Execute DataLoadSQL.sql to load and transform the data into facts and dimensions. It will create a view at the end which contains all the fields which are expected in destination table for Task1.
4. Execute ViewDefinationForActiveUsers.sql, It will create a view on top of the event's fact table and provide all the active user with their maximum number of consecutive days.
5. Output/Extract of the destination table has been provided in Task 1/Task1Export.csv for Task1 and Task 2/ActiveUsers.csv for Task2.


**Note :** Insert statements for events and users data have been provisioned in the main branch.
