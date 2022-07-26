/*

Cleaning Data in SQL Queries

*/

Select *
From Housing_Data.dbo.HousingRawData

---------------------------------------------------------------------------------------------

--Standardize Date Format


Select SaleDate, CONVERT(date, SaleDate)
From Housing_Data..HousingRawData


Update Housing_Data..HousingRawData
Set SaleDate = CONVERT(date, SaleDate)


-- If it doesn't Update properly

Alter Table Housing_Data..HousingRawData
Add SaleDateConverted date

Update Housing_Data..HousingRawData
Set SaleDateConverted = CONVERT(date, SaleDate)


Select SaleDateConverted
From Housing_Data..HousingRawData



---------------------------------------------------------------------------------------------

-- Populate Property Address data


Select *
From Housing_Data..HousingRawData
--Where PropertyAddress is null
Order by ParcelID


--Perform self join

Select ta.ParcelID, ta.PropertyAddress, tb.ParcelID, tb.PropertyAddress, ISNULL(ta.PropertyAddress, tb.PropertyAddress)
From Housing_Data..HousingRawData as ta
JOIN Housing_Data..HousingRawData as tb
	ON ta.ParcelID = tb.ParcelID
	AND ta.[UniqueID ] <> tb.[UniqueID ]
Where ta.PropertyAddress is null


Update ta
Set PropertyAddress = ISNULL(ta.PropertyAddress, tb.PropertyAddress)
From Housing_Data..HousingRawData as ta
JOIN Housing_Data..HousingRawData as tb
	ON ta.ParcelID = tb.ParcelID
	AND ta.[UniqueID ] <> tb.[UniqueID ]
Where ta.PropertyAddress is null



---------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From Housing_Data.dbo.HousingRawData


Select
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as City
From Housing_Data..HousingRawData



-- Add Property splited Address

Alter Table Housing_Data..HousingRawData
Add PropertySplitAddress Nvarchar(255)

Update Housing_Data..HousingRawData
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


-- Add Property Splited City

Alter Table Housing_Data..HousingRawData
Add PropertySplitCity Nvarchar(255)

Update Housing_Data..HousingRawData
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))


Select *
From Housing_Data..HousingRawData





Select OwnerAddress
From Housing_Data..HousingRawData



Select OwnerAddress,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From Housing_Data..HousingRawData




--Add Owner Splited Address

Alter Table Housing_Data..HousingRawData
Add OwnerSplitAddress Nvarchar(255)

Update Housing_Data..HousingRawData
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)



--Add Owner Splited City

Alter Table Housing_Data..HousingRawData
Add OwnerSplitCity Nvarchar(255)

Update Housing_Data..HousingRawData
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)



--Add Owner Splited State

Alter Table Housing_Data..HousingRawData
Add OwnerSplitState Nvarchar(255)

Update Housing_Data..HousingRawData
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



Select *
From Housing_Data..HousingRawData




---------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct SoldAsVacant, COUNT(SoldAsVacant)
From Housing_Data..HousingRawData
Group by SoldAsVacant
Order by 2



Select Distinct SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From Housing_Data..HousingRawData



Update Housing_Data..HousingRawData
Set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
					WHEN SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END



---------------------------------------------------------------------------------------------


-- Remove Duplicates


With Row_Num_CTE as (
Select *,
	ROW_NUMBER() OVER(
		Partition by ParcelID,
					PropertyAddress,
					SaleDateConverted,
					SalePrice,
					LegalReference
					Order by
						UniqueID) as row_num
From Housing_Data..HousingRawData
)

--Select *
Delete
From Row_Num_CTE
Where row_num > 1





---------------------------------------------------------------------------------------------


-- Delete Unused Columns


Select *
From Housing_Data.dbo.HousingRawData


Alter Table Housing_Data.dbo.HousingRawData
DROP COLUMN PropertyAddress, SaleDate, Sale_Date, OwnerAddress, TaxDistrict



---------------------------------------------------------------------------------------------

