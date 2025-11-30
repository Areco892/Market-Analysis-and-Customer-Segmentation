-- Preview of the Data
select * 
from property_sales

-- Standardize Data Format
select saledate
from property_sales

alter table property_sales
alter column saledate type DATE
using saledate::DATE;

-- Populate Null Property Address Values with Known Property Address Data
select p1.parcelid, p1.propertyaddress, p2.propertyaddress, p2.parcelid, coalesce(p1.propertyaddress, p2.propertyaddress)
from property_sales p1
join property_sales p2
    on p2.parcelid = p1.parcelid
    and p1.uniqueid <> p2.uniqueid
where p1.propertyaddress is null

update property_sales p1
set propertyaddress = coalesce(p1.propertyaddress, p2.propertyaddress)
from property_sales p2
where p2.parcelid = p1.parcelid
    and p1.uniqueid <> p2.uniqueid
    and p1.propertyaddress is null

-- Breaking out Property Address into Individual Columns - Using regexp_split_to_array
select propertyaddress, regexp_split_to_array(propertyaddress,',')[1] as propertystreetaddress,
       regexp_split_to_array(propertyaddress,', ')[2] as propertycity
from property_sales

alter table property_sales
add column  propertystreetaddress text, 
            propertycity text;

update property_sales
set propertystreetaddress = (regexp_split_to_array(propertyaddress, ','))[1],
    propertycity = (regexp_split_to_array(propertyaddress, ', '))[2];

-- Breaking out Owner Address into Individual Columns - Using split_part & trim
select owneraddress, split_part(owneraddress, ',', 1) as ownerstreetaddress,
         trim(split_part(owneraddress, ',', 2)) as ownercity,
         trim(split_part(owneraddress, ',', 3)) as ownerstate
from property_sales
where owneraddress is not null
limit 10;

alter table property_sales
add column ownerstreetaddress text, 
add column ownercity text,
add column ownerstate text;

update property_sales
set ownerstreetaddress = split_part(owneraddress, ',', 1),
    ownercity = trim(split_part(owneraddress, ',', 2)),
    ownerstate = trim(split_part(owneraddress, ',', 3));    

-- Standardize Categorical Variables - Case Statements and Type Conversion
select distinct soldasvacant, count(soldasvacant)
from property_sales
group by soldasvacant;

alter table property_sales
alter column soldasvacant type text
using soldasvacant::text;

update property_sales
set soldasvacant = case when soldasvacant = 'true' then 'Yes'
        when soldasvacant = 'false' then 'No'
        else soldasvacant
        end;

-- Remove Duplicates - Using Row_Number() Window Function
with duplicates as (
    select *, row_number() over 
    (partition by   parcelid, 
                    propertyaddress, 
                    saleprice, 
                    saledate, 
                    legalreference 
                    order by uniqueid) as row_num
    from property_sales
)
select *
from duplicates
where row_num > 1;

with duplicates as (
    select *, row_number() over 
    (partition by   parcelid, 
                    propertyaddress, 
                    saleprice, 
                    saledate, 
                    legalreference 
                    order by uniqueid) as row_num
    from property_sales
)
delete from property_sales
using duplicates
where property_sales.uniqueid = duplicates.uniqueid
  and duplicates.row_num > 1;

-- Delete Unused Columns
alter table property_sales
drop column propertyaddress,
drop column owneraddress,
drop column taxdistrict;