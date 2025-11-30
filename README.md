# Housing Analysis - Data Cleaning
In this repository, we will do some data cleaning on the Nashville Housing dataset obtained from: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx. 

## Technologies Used
- Python - pandas
- VSCode with PostgreSQL from Microsoft extension - SQL queries

## Setup
- Download the Nashville Housing excel file.
- In setup.py, use python and pandas to convert the excel file into csv file.
- In VSCode with PostgreSQL extension, go to default postgres database and right click. Select the option New Query. Then run the following query: `CREATE DATABASE <database_name>`. 
- Once the database is created, create the table using the commands in *table_creation.sql*.
- Populate the table with data using the command: `\copy <table_name> FROM '<csv_file>.csv' CSV HEADER;`

## SQL Cleaning Functions
- `update <table_name> set <column_name> = <new_value>`
  - If we want to change the column's data type, we can set `<new_value>` to `<column_name>::<new_data_type>`.
  - If we want to fill the column's null value with other column's value, we can set `<new_value>` to `coalesce(<table_name>.<column_name>, <other_table_name>.<other_column_name>)`.

## Acknowledgement
This project is a continuation from a video I stumbled previously from Alex The Analyst. However this time, this repository will focus on the technique from the youtube video titled "Data Analyst Portfolio Project | Data Cleaning in SQL | Project 3/4" from Alex The Analyst, again very cool stuff! So, I created this repository to practice my data cleaning skills using PostgreSQL and also to have a way of keep track my progress in becoming a Data Analyst.

- Link to AlexTheAnalyst youtube video: https://www.youtube.com/watch?v=8rO7ztF4NtU
- Link to AlexTheAnalyst repository: https://github.com/AlexTheAnalyst/PortfolioProjects/tree/main
