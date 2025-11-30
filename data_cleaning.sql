-- Preview of the Data
select * 
from property_sales

-- Standardize Data Format
select saledate
from property_sales

update property_sales
set SaleDate = SaleDate::DATE

-- Populate Property Address Data
select p1.parcelid, p1.propertyaddress, p2.propertyaddress, p2.parcelid, coalesce(p1.propertyaddress, p2.propertyaddress)
from property_sales p1
join property_sales p2
    on p2.parcelid = p1.parcelid
    and p1.uniqueid <> p2.uniqueid
where p1.propertyaddress is null

update property_sales
set propertyaddress = coalesce(p1.propertyaddress, p2.propertyaddress)
from property_sales p1
join property_sales p2
    on p2.parcelid = p1.parcelid
    and p1.uniqueid <> p2.uniqueid
where p1.propertyaddress is null