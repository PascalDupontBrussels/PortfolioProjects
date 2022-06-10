-- ETL--
--Cleaning Data in SQL Queries

Select *
From PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------

--1-Standardize Date Format


Select SaleDate,CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted
From PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------

--2-Populate property Address Data 


Select *
From PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE a.PropertyAddress is null


UPDATE a
SET   PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

----------------------------------------------------------------------------------------------------

--3-Breaking out Address into Individual  columns (Address, City, State)


Select PropertyAddress 
From PortfolioProject..NashvilleHousing


Select SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)- 1) as Address
	  ,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress)) as City
From PortfolioProject..NashvilleHousing

--create two new columns

ALTER TABLE NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)- 1)

ALTER TABLE NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress))

SELECT *
FROM PortfolioProject..NashvilleHousing


SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT
 PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

ALTER TABLE NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)

SELECT *
FROM PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------

--4-Change Y and N in "Sold as Vacant" fiels


SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
      WHEN SoldAsVacant = 'N' THEN 'No' 
	  Else SoldAsVacant
END as SoldAsVacantBis

FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant =
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
      WHEN SoldAsVacant = 'N' THEN 'No' 
	  Else SoldAsVacant
END 
FROM PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------

--5-Remove Duplicates


WITH RowNum_CTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelId,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
ORDER BY UniqueID
) as row_num

FROM PortfolioProject..NashvilleHousing
)
DELETE
FROM  RowNum_CTE
WHERE row_num > 1

SELECT*
FROM PortfolioProject..NashvilleHousing


----------------------------------------------------------------------------------------------------


--6-Deleted Unused Columns


SELECT *
FROM PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate

