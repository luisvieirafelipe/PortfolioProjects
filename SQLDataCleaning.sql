/* Cleaning Data Using SQL Queries */

Select*
From Project..dbo.NashvilleHousing

-- Stardardize Date Format
Select SaleDateConverted, convert(date, SaleDate)
From Project..NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(date, SaleDate)

alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date, SaleDate)

-- Populate Property Adress data 

Select *
From Project..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, isnull(A.PropertyAddress, B.PropertyAddress) /*Quando A.PropertyAdress for Null, vai Colocar a informação de B.PropertyAdress */
From Project..NashvilleHousing A
join Project..NashvilleHousing B
	on A.ParcelID=B.ParcelID
	and A.[UniqueID ]<>B.[UniqueID ]
	Where A.PropertyAddress is null

Update A
Set PropertyAddress =  isnull(A.PropertyAddress, B.PropertyAddress)
From Project..NashvilleHousing A
join Project..NashvilleHousing B
	on A.ParcelID=B.ParcelID
	and A.[UniqueID ]<>B.[UniqueID ]
	Where A.PropertyAddress is null

Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, isnull(A.PropertyAddress, B.PropertyAddress) /*Quando A.PropertyAdress for Null, vai Colocar a informação de B.PropertyAdress */
From Project..NashvilleHousing A
join Project..NashvilleHousing B
	on A.ParcelID=B.ParcelID
	and A.[UniqueID ]<>B.[UniqueID ]

-- Breaking Out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Project..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1/* -1 Tira a vírgula do endereço*/) as Address /*Charindex procura um valor específico*/
, SUBSTRING (PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City

From Project..NashvilleHousing

alter table NashvilleHousing
Add PropertySplitAdress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAdress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING (PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
From Project..NashvilleHousing


Select OwnerAddress
From Project..NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress,',','.'), 3),
PARSENAME(Replace(OwnerAddress,',','.'), 2),
PARSENAME(Replace(OwnerAddress,',','.'), 1)
From Project..NashvilleHousing

alter table NashvilleHousing
Add OwnerSplitAdress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAdress = PARSENAME(Replace(OwnerAddress,',','.'), 3)

alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'), 2)


alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1)

Select *
From Project..NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" Field

Select distinct(SoldAsVacant), count(SoldAsVacant)
From Project..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
case When SoldAsVacant='Y' then 'Yes'
	 When SoldAsVacant='N' then 'No'
	 Else SoldAsVacant
	 End
From Project..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = case When SoldAsVacant='Y' then 'Yes'
	 When SoldAsVacant='N' then 'No'
	 Else SoldAsVacant
	 End


Select distinct(SoldAsVacant), count(SoldAsVacant)
From Project..NashvilleHousing
Group by SoldAsVacant
Order by 2

-- Remove Duplicates

With RowNumCTE as (
Select *,    --Procurando os Valores Iguais, colocando valor para as colunas
	ROW_NUMBER() Over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					) row_num

From Project..NashvilleHousing
--Order by ParcelID
)
Select*
from RowNumCTE
Where row_num>1
Order by PropertyAddress

With RowNumCTE as (
Select *,    --Procurando os Valores Iguais, colocando valor para as colunas
	ROW_NUMBER() Over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					) row_num

From Project..NashvilleHousing
--Order by ParcelID
)
Delete
from RowNumCTE
Where row_num>1

With RowNumCTE as (
Select *,    --Procurando os Valores Iguais, colocando valor para as colunas
	ROW_NUMBER() Over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					) row_num

From Project..NashvilleHousing
--Order by ParcelID
)
Select*
from RowNumCTE
Where row_num>1
Order by PropertyAddress

--Delete Unused Columns

Select*
From Project..NashvilleHousing

Alter table Project..NashvilleHousing
drop column OwnerAddress, PropertyAddress

Alter table Project..NashvilleHousing
drop column SaleDate

