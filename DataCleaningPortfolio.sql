/*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProject.dbo.NashvilleHousing


-- Standardize Date Format


SELECT SaleDate, CONVERT(date,SaleDate),SaleDateConvert
From Portfolio..NashvilleHousing

Update Portfolio..NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)


-- If it doesn't Update properly


Alter table Portfolio..NashvilleHousing
Add SaleDateConvert Date

Update Portfolio..NashvilleHousing
SET SaleDateConvert = CONVERT(date,SaleDate)


-- Populate Property Address data


SELECT PropertyAddress
From Portfolio..NashvilleHousing
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
	SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	From Portfolio.dbo.NashvilleHousing a
	JOIN Portfolio.dbo.NashvilleHousing b
		on a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select PropertyAddress, 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Adress,
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Adress
From Portfolio.dbo.NashvilleHousing 

Alter table Portfolio..NashvilleHousing
Add ProperySplitAdress Nvarchar(255)
Update Portfolio..NashvilleHousing
SET ProperySplitAdress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter table Portfolio..NashvilleHousing
Add ProperySplitCity Nvarchar(255)
Update Portfolio..NashvilleHousing
SET ProperySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select OwnerAddress, 
	PARSENAME( Replace(OwnerAddress,',','.'),3), 
	PARSENAME( Replace(OwnerAddress,',','.'),2), 
	PARSENAME( Replace(OwnerAddress,',','.'),1)
From Portfolio.dbo.NashvilleHousing 

Alter table Portfolio..NashvilleHousing
Add OwnerAddressSplit Nvarchar(255)
Update Portfolio..NashvilleHousing
SET OwnerAddressSplit =  PARSENAME( Replace(OwnerAddress,',','.'),3)

Alter table Portfolio..NashvilleHousing
Add OwnerAddressCity Nvarchar(255)
Update Portfolio..NashvilleHousing
SET OwnerAddressCity =  PARSENAME( Replace(OwnerAddress,',','.'),2)

Alter table Portfolio..NashvilleHousing
Add OwnerAddressState Nvarchar(255)
Update Portfolio..NashvilleHousing
SET OwnerAddressState =  PARSENAME( Replace(OwnerAddress,',','.'),1)

Select *
From PortfolioProject.dbo.NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select distinct(SoldAsVacant)
From Portfolio.dbo.NashvilleHousing 

Select SoldAsVacant,
Case when SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	ELSE SoldAsVacant
	END
From Portfolio.dbo.NashvilleHousing 

Update Portfolio..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- Remove Duplicates


With RowNumber as (
Select *, 
ROW_NUMBER() OVER 
	(PARTITION BY ParcelID, 
	PropertyAddress, 
	SalePrice, SaleDate, 
	LegalReference 
	ORDER BY UniqueID) as row_num

FROM Portfolio.dbo.NashvilleHousing
)

Delete
FROM RowNumber
Where row_num > 1


Select *
From Portfolio.dbo.NashvilleHousing


-- Delete Unused Columns


ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


Select *
From PortfolioProject.dbo.NashvilleHousing



