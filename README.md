# Housing Analysis - Data Cleaning
In this repository, we will do some data cleaning on the Nashville Housing dataset obtained from: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx. 

## Technologies Used
- Python - pandas
- VSCode with PostgreSQL from Microsoft extension - SQL queries

## Setup
- Download the Nashville Housing excel file.
- In setup.py, use python and pandas to convert the excel file into csv file.
- In VSCode with PostgreSQL extension, go to default postgres database and right click. Select the option New Query. Then run the following query: `CREATE DATABASE <database_name>`. 
- Once the database is created, create the table using the command in *table_creation.sql*.
- Populate the table with data using the command: `\copy <table_name> FROM '<csv_file>.csv' CSV HEADER;`

## SQL Cleaning Functions
- To fill the column's value with other column's value, use `update <table_name> set <column_name> = <new_value>`. When working with null values, set `<new_value>` to `coalesce(<table_name>.<column_name>, <other_table_name>.<other_column_name>)`. The function coalesce() must be called with at least 2 parameters and it returns the first non-null value from the parameters.
- To change the column's data type, use:
  ```
  alter table <table_name> 
  alter column <column_name> type <new_data_type>
  using <column_name>::<new_data_type>;
  ```
- To split the value of an attribute (column), like property address into the individual components like street, city, state, use:
  - (regex_split_to_array(<column_name>, \<delimeter>))[n] to get the n-th component.
  - split_part(<column_name>, \<delimeter>, \<position>) to get the component at the requested \<position>.
  - trim() to remove the leading and trailing white spaces.
- To create new columns for the split attributes, use *alter table* and *add column*. For example:
  ```
  alter table property_sales
  add column ownerstreetaddress text, 
  add column ownercity text,
  add column ownerstate text;
  ```
  and then use the *update-set* query:
  ```
  update property_sales
  set ownerstreetaddress = split_part(owneraddress, ',', 1),
      ownercity = trim(split_part(owneraddress, ',', 2)),
      ownerstate = trim(split_part(owneraddress, ',', 3));  
  ```
- To standardize the values of a column to a common value, use case statements. For example, if a column have values Y, N, Yes, No, to change the Y to Yes, and N to No, use:
  ```
  update property_sales
  set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
        when soldasvacant = 'N' then 'No'
        else soldasvacant
        end; 
  ```
- To delete duplicates, consider what attributes will be used to indicate that two rows are duplicates. Once figured out, use a CTE and Row_Number() window function to number all the rows. Then, use the *delete from - using* query. For example, to remove duplicates in property records, use:
  ```
  with duplicates as (
      select *, row_number() over 
      (partition by parcelid, propertyaddress, saleprice, saledate, legalreference 
       order by uniqueid) as row_num
      from property_sales
  )
  delete from property_sales
  using duplicates
  where property_sales.uniqueid = duplicates.uniqueid
    and duplicates.row_num > 1;
  ```
- To delete unused columns, use: `alter table <table_name> drop column <column_name>`
  
## Acknowledgement
This project is a continuation from a video I stumbled previously from Alex The Analyst. However this time, this repository will focus on the technique from the youtube video titled "Data Analyst Portfolio Project | Data Cleaning in SQL | Project 3/4" from Alex The Analyst, again very cool stuff! So, I created this repository to practice my data cleaning skills using PostgreSQL and also to keep track of my progress in becoming a Data Analyst.

- Link to AlexTheAnalyst youtube video: https://www.youtube.com/watch?v=8rO7ztF4NtU
- Link to AlexTheAnalyst repository: https://github.com/AlexTheAnalyst/PortfolioProjects/tree/main
