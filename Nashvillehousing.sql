-- standardize the date
 
 ALter table Nashvillehousing
 Add Saledateupdated date

 update Nashvillehousing
 set Saledateupdated = convert(date, saledate)
 
 Select * --Saledateupdated 
 from Portfolio1..Nashvillehousing


 -- populating the property address
 -- we'll use Join to populate the address

 Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
 from Portfolio1..Nashvillehousing a
 Join Portfolio1..Nashvillehousing b
 on  a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null

 update a
 set propertyaddress = isnull(a.PropertyAddress,b.PropertyAddress)
 from Portfolio1..Nashvillehousing a
 Join Portfolio1..Nashvillehousing b
 on  a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]

 -- separating the address into state and city 

 select 
 SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as address
 , SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(propertyaddress)) as address 
 from Portfolio1..Nashvillehousing

 Alter table nashvillehousing
 add propertysplitaddress nvarchar(255)
 
 Update Nashvillehousing
 set propertysplitaddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

 Alter table nashvillehousing
 add propertysplitcity nvarchar(255)
  
Update Nashvillehousing
set propertysplitcity =  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(propertyaddress))


select
PARSENAME(replace(OwnerAddress,',','.'),3)
,PARSENAME(replace(OwnerAddress,',','.'),2)
,PARSENAME(replace(OwnerAddress,',','.'),1)
From Portfolio1..Nashvillehousing

  Alter table nashvillehousing
  add ownerhouse nvarchar(255)
  Update Nashvillehousing
  set ownerhouse = PARSENAME(replace(OwnerAddress,',','.'),3)

  Alter table nashvillehousing
  add ownercity nvarchar(255)
  Update Nashvillehousing
  set ownercity = PARSENAME(replace(OwnerAddress,',','.'),2)
  
  Alter table nashvillehousing
  add ownerstate nvarchar(255)
  Update Nashvillehousing
  set ownerstate = PARSENAME(replace(OwnerAddress,',','.'),1)

  
  --changing y to yes and N to no

  select SoldAsVacant
  , case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N'then 'No'
	   else SoldAsVacant
	   End
  From Portfolio1..Nashvillehousing

  Update Nashvillehousing
  set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N'then 'No'
	   else SoldAsVacant
	   End



  -- Removing Duplicates
  
  WITH rownumCTE as(
  Select *,
  ROW_NUMBER() over (
  Partition by ParcelId,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   Order By 
			     UniqueID
				 ) row_num
   from Portfolio1..nashvillehousing
 --  order by ParcelID
)
 
   Select *
   from rownumCTE
   where row_num > 1
 --order by PropertyAddress



 -- delete unused columns

  Select *
  From Portfolio1..Nashvillehousing


  Alter table Portfolio1..Nashvillehousing
  drop column Owneraddress, taxdistrict, propertyaddress, 

  Alter table Portfolio1..Nashvillehousing
  drop column saledate

  -- splitting the owner names

   Select ownername,
   SUBSTRING(OwnerName,1,CHARINDEX('&',OwnerName)),
   SUBSTRING(OwnerName, CHARINDEX('&',OwnerName)+1, len(ownername))
   From Portfolio1..Nashvillehousing
   where OwnerName is not null

   Alter table portfolio1..nashvillehousing
   add Name1 nvarchar(255)
   Update portfolio1..nashvillehousing
   set Name1 = SUBSTRING(OwnerName,1,CHARINDEX('&',OwnerName))

   Alter table portfolio1..nashvillehousing
   add Name2 nvarchar(255)
   Update portfolio1..nashvillehousing
   set Name2 = SUBSTRING(OwnerName, CHARINDEX('&',OwnerName)+1, len(ownername))
    

	Alter table Portfolio1..Nashvillehousing
    drop column ownername 
	
SELECT
SUBSTRING(Name1,1,CHARINDEX(',',Name1)),
SUBSTRING(Name1,CHARINDEX(',',Name1), len(Name1))
FROM Portfolio1..Nashvillehousing


 ALter table Portfolio1..Nashvillehousing
 add Name3 nvarchar(255)

 Update Portfolio1..Nashvillehousing
 set Name3 = SUBSTRING(Name1,CHARINDEX(',',Name1), len(Name1))

 update Portfolio1..Nashvillehousing
 set Name1 = SUBSTRING(Name1,1,CHARINDEX(',',Name1))