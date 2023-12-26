-- CHECKING THE DATA

Select * from Portfolio..HousingDetails


--FORMATING THE SALES DATE 

Alter Table portfolio..HousingDetails
Add
SaleDates Date

Update Portfolio..HousingDetails
Set SaleDates = Convert(Date,SaleDates)

Select SaleDates, Convert(Date,SaleDate) as Date
from Portfolio..HousingDetails


-- WORKING WITH THE PROPERTY ADDRESS

Select *
from Portfolio..HousingDetails 
Order By ParcelID


Select A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)AS ADDRESS
from Portfolio..HousingDetails A
JOIN
Portfolio..HousingDetails B 
ON
A.ParcelID = B.ParcelID AND
A.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress is NULL

Update A
Set propertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
from Portfolio..HousingDetails A
JOIN
Portfolio..HousingDetails B 
ON
A.ParcelID = B.ParcelID AND
A.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress is NULL

-- SEPERATING THE ADDRESS AS PER ADDRESS CITY AND STATE

Select PropertyAddress from Portfolio..HousingDetails

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)AS ADDRESS,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) AS CITY
from Portfolio..HousingDetails

Alter Table portfolio..HousingDetails
Add
Property_Address Nvarchar(255)

Update Portfolio..HousingDetails
Set Property_Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table portfolio..HousingDetails
Add
CityName Nvarchar(255)

Update Portfolio..HousingDetails
Set CityName = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


-- WORKING WITH OWNER ADDRESS

Select OwnerAddress from Portfolio..HousingDetails

Select 
PARSENAME(replace(OwnerAddress,',','.'),3) as address,
PARSENAME(replace(OwnerAddress,',','.'),2)as city,
PARSENAME(replace(OwnerAddress,',','.'),1)as state
from Portfolio..HousingDetails

Alter Table portfolio..HousingDetails
Add
Ownar_Address Nvarchar(255)

Update Portfolio..HousingDetails
Set Ownar_Address = PARSENAME(replace(OwnerAddress,',','.'),3)

Alter Table portfolio..HousingDetails
Add
OwnarCityName Nvarchar(255)

Update Portfolio..HousingDetails
Set OwnarCityName = PARSENAME(replace(OwnerAddress,',','.'),2)


Alter Table portfolio..HousingDetails
Add
OwnarStateName Nvarchar(255)

Update Portfolio..HousingDetails
Set OwnarStateName = PARSENAME(replace(OwnerAddress,',','.'),1)


-- WORKING WITH SOLD AS VACANT 

Select SoldAsVacant from Portfolio..HousingDetails

Select Distinct(SoldAsVacant) 
from Portfolio..HousingDetails


Select SoldAsVacant,
CASE
  When SoldAsVacant = 'Y' then 'YES'
  When SoldAsVacant = 'N' then 'NO'
  Else SoldAsVacant
  End
from Portfolio..HousingDetails

Update Portfolio..HousingDetails
Set SoldAsVacant =
					CASE
					When SoldAsVacant = 'Y' then 'YES'
					When SoldAsVacant = 'N' then 'NO'
					Else SoldAsVacant
					End


-- REMOVING DUPLICATES 

WITH  dupliacteCTE AS
(
SELECT *,
    ROW_NUMBER() over(PARTITION BY ParcelID, propertyAddress,SalePrice, SaleDate, LegalReference  ORDER BY UniqueID) ROWS
from Portfolio..HousingDetails
)
Select *
From dupliacteCTE
Where ROWS > 1
Order by PropertyAddress


-- DELETE THE UNUSED/UNWANTED COLUMNS

Select * from Portfolio..HousingDetails


alter table Portfolio..HousingDetails
DROP COLUMN
   PropertyAddress, SaleDate, OwnerAddress, TaxDistrict