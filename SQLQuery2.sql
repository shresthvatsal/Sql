drop table tblDepartment;
drop table	tblEmployee
drop table	tblTransaction

CREATE TABLE tblDepartment (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);
 
-- Sample data for tblDepartment
INSERT INTO tblDepartment (DepartmentID, DepartmentName)
VALUES
    (1, 'HR'),
    (2, 'Finance'),
    (3, 'IT');
 
-- Table Structure for tblEmployee
CREATE TABLE tblEmployee (
    EmployeeNumber INT PRIMARY KEY,
    EmployeeFirstName VARCHAR(100),
    EmployeeLastName VARCHAR(100),
    DepartmentID INT, -- Foreign key referencing tblDepartment
    CONSTRAINT FK_Department FOREIGN KEY (DepartmentID) REFERENCES tblDepartment(DepartmentID)
);
 
-- Sample data for tblEmployee
INSERT INTO tblEmployee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, DepartmentID)
VALUES
    (101, 'John', 'Smith', 1),
    (102, 'Emily', 'Johnson', 2),
    (103, 'Michael', 'Williams', 3);
 
-- Table Structure for tblTransaction
CREATE TABLE tblTransaction (
    TransactionID INT PRIMARY KEY,
    EmployeeNumber INT, -- Foreign key referencing tblEmployee
    DateOfTransaction DATE,
    Amount DECIMAL(10, 2),
    CONSTRAINT FK_Employee FOREIGN KEY (EmployeeNumber) REFERENCES tblEmployee(EmployeeNumber)
);
 
-- Sample data for tblTransaction
INSERT INTO tblTransaction (TransactionID, EmployeeNumber, DateOfTransaction, Amount)
VALUES
    (1, 101, '2024-01-05', 100.00),
    (2, 102, '2024-01-10', 150.50),
    (3, 103, '2024-01-15', 200.75);







 
select * from tblDepartment 
select * from tblEmployee
select * from tblTransaction

select min(EmployeeNumber) as MinNumber, max(EmployeeNumber) as MaxNumber
from tblTransaction

select min(EmployeeNumber) as MinNumber, max(EmployeeNumber) as MaxNumber
from tblEmployee

select T.* 
from tblTransaction as T
inner join tblEmployee as E
on E.EmployeeNumber = T.EmployeeNumber
where E.EmployeeLastName like 'y%'
order by T.EmployeeNumber

select * 
from tblTransaction as T
Where EmployeeNumber in
    (Select EmployeeNumber from tblEmployee where EmployeeLastName like 'y%')
order by EmployeeNumber

select * 
from tblTransaction as T
Where EmployeeNumber in
    (Select EmployeeNumber from tblEmployee where EmployeeLastName not like 'y%')
order by EmployeeNumber -- must be in tblEmployee AND tblTransaction, and not 126-129
                        -- INNER JOIN

select * 
from tblTransaction as T
Where EmployeeNumber not in
    (Select EmployeeNumber from tblEmployee where EmployeeLastName like 'y%')
order by EmployeeNumber -- must be in tblTransaction, and not 126-129
                        -- LEFT JOIN

select * 
from tblTransaction as T
Where EmployeeNumber = some -- or "some"
    (Select EmployeeNumber from tblEmployee where EmployeeLastName like 'y%')
order by EmployeeNumber

select * 
from tblTransaction as T
Where EmployeeNumber <> any -- does not work properly
    (Select EmployeeNumber from tblEmployee where EmployeeLastName like 'y%')
order by EmployeeNumber

select * 
from tblTransaction as T
Where EmployeeNumber <> all 
    (Select EmployeeNumber from tblEmployee where EmployeeLastName like 'y%')
order by EmployeeNumber

select * 
from tblTransaction as T
Where EmployeeNumber <= all
    (Select EmployeeNumber from tblEmployee where EmployeeLastName like 'y%')
order by EmployeeNumber

-- anything up to 126 AND
-- anything up to 127 AND
-- anything up to 128 AND
-- anything up to 129

-- ANY = anything up to 129
-- ALL = anything up to 126

-- any/some = OR
-- all = AND

-- 126 <> all(126,127,128,129)
-- 126<>126 AND 126<>127 AND 126<>128 AND 126<>129
-- FALSE    AND TRUE = FALSE

-- 126 <> any(126,127,128,129)
-- 126<>126 OR 126<>127 OR 126<>128 OR 126<>129
-- FALSE    OR TRUE = TRUE

select * 
from tblTransaction as T
left join (select * from tblEmployee
where EmployeeLastName like 'y%') as E
on E.EmployeeNumber = T.EmployeeNumber
order by T.EmployeeNumber

select * 
from tblTransaction as T
left join tblEmployee as E
on E.EmployeeNumber = T.EmployeeNumber
Where E.EmployeeLastName like 'y%'
order by T.EmployeeNumber

select * 
from tblTransaction as T
left join tblEmployee as E
on E.EmployeeNumber = T.EmployeeNumber
and E.EmployeeLastName like 'y%'
order by T.EmployeeNumber

Select   (select count(EmployeeNumber)
           from tblTransaction as T
		   where T.EmployeeNumber = E.EmployeeNumber) as NumTransactions,
		  (Select sum(Amount)
		   from tblTransaction as T
		   where T.EmployeeNumber = E.EmployeeNumber) as TotalAmount
from tblEmployee as E
Where E.EmployeeLastName like 'y%' --correlated subquery

select * 
from tblTransaction as T
Where exists 
    (Select EmployeeNumber from tblEmployee as E where EmployeeLastName like 'y%' and T.EmployeeNumber = E.EmployeeNumber)
order by EmployeeNumber

select * 
from tblTransaction as T
Where not exists 
    (Select EmployeeNumber from tblEmployee as E where EmployeeLastName like 'y%' and T.EmployeeNumber = E.EmployeeNumber)
order by EmployeeNumber

SELECT
    (SELECT COUNT(EmployeeNumber)
     FROM tblTransaction AS T
     WHERE T.EmployeeNumber = E.EmployeeNumber) AS NumTransactions,
    (SELECT SUM(Amount)
     FROM tblTransaction AS T
     WHERE T.EmployeeNumber = E.EmployeeNumber) AS TotalAmount
FROM
    tblEmployee AS E
WHERE
    E.EmployeeLastName LIKE 'y%';









	WITH
    tblWithRanking AS (
        SELECT
            D.DepartmentName AS Department, -- Corrected column name
            E.EmployeeNumber,
            E.EmployeeFirstName,
            E.EmployeeLastName,
            RANK() OVER (PARTITION BY D.DepartmentName ORDER BY E.EmployeeNumber) AS TheRank -- Corrected column name
        FROM
            tblDepartment AS D
        JOIN
            tblEmployee AS E ON D.DepartmentID = E.DepartmentID -- Assuming DepartmentID is the common column
    ),
    Transaction2014 AS (
        SELECT
            *
        FROM
            tblTransaction
        WHERE
            DateOfTransaction < '2015-01-01'
    )
SELECT
    *
FROM
    tblWithRanking
LEFT JOIN
    Transaction2014 ON tblWithRanking.EmployeeNumber = Transaction2014.EmployeeNumber
WHERE
    TheRank <= 5
ORDER BY
    Department,
    tblWithRanking.EmployeeNumber;





select max(EmployeeNumber) from tblTransaction;


with Numbers as (
    select top(select max(EmployeeNumber) from tblTransaction) row_Number() over(order by (select null)) as RowNumber
    from tblTransaction as U
)
select U.RowNumber
from Numbers as U
left join tblTransaction as T on U.RowNumber = T.EmployeeNumber
where T.EmployeeNumber is null
order by U.RowNumber;

with Numbers as (
    select top(select max(EmployeeNumber) from tblTransaction) row_Number() over(order by (select null)) as RowNumber
    from tblTransaction as U
),
Transactions2014 as (
    select *
    from tblTransaction
    where DateOfTransaction >= '2014-01-01' and DateOfTransaction < '2015-01-01'
),
tblGap as (
    select
        U.RowNumber,
        RowNumber - LAG(RowNumber) over(order by RowNumber) as PreviousRowNumber,
        LEAD(RowNumber) over(order by RowNumber) - RowNumber as NextRowNumber,
        case when RowNumber - LAG(RowNumber) over(order by RowNumber) = 1 then 0 else 1 end as GroupGap
    from
        Numbers as U
    left join
        Transactions2014 as T on U.RowNumber = T.EmployeeNumber
    where
        T.EmployeeNumber is null
)

WITH Numbers AS (
    SELECT
        TOP (SELECT MAX(EmployeeNumber) FROM tblTransaction)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNumber
    FROM
        tblTransaction AS U
),
Transactions2014 AS (
    SELECT *
    FROM tblTransaction
    WHERE DateOfTransaction >= '2014-01-01' AND DateOfTransaction < '2015-01-01'
),
tblGap AS (
    SELECT
        U.RowNumber,
        U.RowNumber - LAG(U.RowNumber) OVER (ORDER BY U.RowNumber) AS PreviousRowNumber,
        LEAD(U.RowNumber) OVER (ORDER BY U.RowNumber) - U.RowNumber AS NextRowNumber,
        CASE
            WHEN U.RowNumber - LAG(U.RowNumber) OVER (ORDER BY U.RowNumber) = 1 THEN 0
            ELSE 1
        END AS GroupGap
    FROM
        Numbers AS U
    LEFT JOIN
        Transactions2014 AS T ON U.RowNumber = T.EmployeeNumber
    WHERE
        T.EmployeeNumber IS NULL
),
tblGroup AS (
    SELECT
        *,
        SUM(GroupGap) OVER (ORDER BY RowNumber) AS TheGroup
    FROM
        tblGap
)
SELECT
    MIN(RowNumber) AS StartingEmployeeNumber,
    MAX(RowNumber) AS EndingEmployeeNumber,
    MAX(RowNumber) - MIN(RowNumber) + 1 AS NumberEmployees
FROM
    tblGroup
GROUP BY
    TheGroup
ORDER BY
    TheGroup;



	WITH myTable AS (
    SELECT
        YEAR(DateOfTransaction) AS TheYear,
        MONTH(DateOfTransaction) AS TheMonth,
        Amount
    FROM
        tblTransaction
)
SELECT
    TheYear,
    ISNULL([1], 0) AS [1],
    ISNULL([2], 0) AS [2],
    ISNULL([3], 0) AS [3],
    ISNULL([4], 0) AS [4],
    ISNULL([5], 0) AS [5],
    ISNULL([6], 0) AS [6],
    ISNULL([7], 0) AS [7],
    ISNULL([8], 0) AS [8],
    ISNULL([9], 0) AS [9],
    ISNULL([10], 0) AS [10],
    ISNULL([11], 0) AS [11],
    ISNULL([12], 0) AS [12]
FROM
    myTable
PIVOT
    (SUM(Amount) FOR TheMonth IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) AS myPvt
ORDER BY
    TheYear;




















-- Create the table [MyPivotTable] with relevant columns
CREATE TABLE MyPivotTable (
    -- Add your column definitions here
    [Month1] INT,
    [Month2] INT,
    [Month3] INT,
    -- Add more columns as needed
);
 
-- Insert some sample data into [MyPivotTable]
INSERT INTO MyPivotTable ([Month1], [Month2], [Month3])
VALUES (10, 20, 30),
       (15, 25, 35),
       (NULL, 28, 38); -- Example with NULL values
 
-- Perform the unpivot operation
SELECT *
FROM
    (SELECT * FROM MyPivotTable) AS SourceTable
UNPIVOT
    (Amount FOR Month IN ([Month1], [Month2], [Month3])) AS tblUnPivot
WHERE
    Amount IS NOT NULL;




begin tran
alter table tblEmployee
add Manager int
go
update tblEmployee
set Manager = ((EmployeeNumber-123)/10)+123
where EmployeeNumber>123;
with myTable as
(select EmployeeNumber, EmployeeFirstName, EmployeeLastName, 0 as BossLevel --Anchor
from tblEmployee
where Manager is null
UNION ALL --UNION ALL!!
select E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName, myTable.BossLevel + 1 --Recursive
from tblEmployee as E
join myTable on E.Manager = myTable.EmployeeNumber
) --recursive CTE

select * from myTable

rollback tran


CREATE FUNCTION AmountPlusOne(@Amount smallmoney)
RETURNS smallmoney
AS
BEGIN

    RETURN @Amount + 1

END
GO


select DateOfTransaction, EmployeeNumber, Amount
from tblTransaction







CREATE FUNCTION TransactionList(@EmployeeNumber int)
RETURNS TABLE AS RETURN
(
    SELECT * FROM tblTransaction
	WHERE EmployeeNumber = @EmployeeNumber
)



SELECT * 
from dbo.TransactionList(123)

select *
from tblEmployee
where exists(select * from dbo.TransactionList(EmployeeNumber))

select distinct E.*
from tblEmployee as E
join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber

select *
from tblEmployee as E
where exists(Select EmployeeNumber from tblTransaction as T where E.EmployeeNumber = T.EmployeeNumber)


SELECT * 
from dbo.TransList(123)
GO

select *, (select count(*) from dbo.TransList(E.EmployeeNumber)) as NumTransactions
from tblEmployee as E

select *
from tblEmployee as E
outer apply TransList(E.EmployeeNumber) as T

select *
from tblEmployee as E
cross apply TransList(E.EmployeeNumber) as T



create synonym EmployeeTable
for tblEmployee
go

select * from EmployeeTable

create synonym DateTabl
for tblDate
go

select * from DateTable

--create synonym RemoteTable
--for OVERTHERE.70-461remote.dbo.tblRemote
go

--select * from RemoteTable



select * from tblEmployee where EmployeeNumber = 129;
go
declare @command as varchar(255);
set @command = 'select * from tblEmployee where EmployeeNumber = 129;'
set @command = 'Select * from tblTransaction'
execute (@command);
go



declare @command as varchar(255), @param as varchar(50);
set @command = 'select * from tblEmployee where EmployeeNumber = '
set @param ='129'
execute (@command + @param); --sql injection potential
go
declare @command as nvarchar(255), @param as nvarchar(50);
set @command = N'select * from tblEmployee where EmployeeNumber = @ProductID'
set @param =N'129'
execute sys.sp_executesql @statement = @command, @params = N'@ProductID int', @ProductID = @param;




--begin tran
--insert into tblEmployee2
--values ('New Name')
--select * from tblEmployee2
--rollback tran

--truncate table tblEmployee2



declare @newvalue as uniqueidentifier --GUID
SET @newvalue = NEWID()
SELECT @newvalue as TheNewID
GO
declare @randomnumbergenerator int = DATEPART(MILLISECOND,SYSDATETIME())+1000*(DATEPART(SECOND,SYSDATETIME())
                                     +60*(DATEPART(MINUTE,SYSDATETIME())+60*DATEPART(HOUR,SYSDATETIME())))
SELECT RAND(@randomnumbergenerator) as RandomNumber;




begin tran
Create table tblEmployee4
(UniqueID uniqueidentifier CONSTRAINT df_tblEmployee4_UniqueID DEFAULT NEWID(),
EmployeeNumber int CONSTRAINT uq_tblEmployee4_EmployeeNumber UNIQUE)

Insert into tblEmployee4(EmployeeNumber)
VALUES (1), (2), (3)
select * from tblEmployee4
rollback tran





go
--declare @newvalue as uniqueidentifier
--SET @newvalue = NEWSEQUENTIALID()
--SELECT @newvalue as TheNewID
GO
--begin tran
--Create table tblEmployee4
--(UniqueID uniqueidentifier CONSTRAINT df_tblEmployee4_UniqueID DEFAULT NEWSEQUENTIALID(),
--EmployeeNumber int CONSTRAINT uq_tblEmployee4_EmployeeNumber UNIQUE)

--Insert into tblEmployee4(EmployeeNumber)
--VALUES (1), (2), (3)
--select * from tblEmployee4


BEGIN TRAN
CREATE SEQUENCE newSeq AS BIGINT
START WITH 1
INCREMENT BY 1
MINVALUE 1
--MAXVALUE 999999
--CYCLE
CACHE 50
CREATE SEQUENCE secondSeq AS INT
SELECT * FROM sys.sequences
ROLLBACK TRAN


BEGIN TRAN
CREATE SEQUENCE newSeq AS BIGINT
START WITH 1
INCREMENT BY 1
MINVALUE 1
CACHE 50
select NEXT VALUE FOR newSeq as NextValue;
--select *, NEXT VALUE FOR newSeq OVER (ORDER BY DateOfTransaction) as NextNumber from tblTransaction
rollback tran



CREATE SEQUENCE newSeq AS BIGINT
START WITH 1
INCREMENT BY 1
MINVALUE 1
--MAXVALUE 999999
--CYCLE
CACHE 50




alter table tblTransaction
ADD NextNumber int CONSTRAINT DF_Transaction DEFAULT NEXT VALUE FOR newSeq

alter table tblTransaction
drop DF_Transaction
alter table tblTransaction
drop column NextNumber

alter table tblTransaction
add NextNumber int
alter table tblTransaction
add CONSTRAINT DF_Transaction DEFAULT NEXT VALUE FOR newSeq for NextNumber



begin tran
select * from tblTransaction
INSERT INTO tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
VALUES (1,'2017-01-01',123)
select * from tblTransaction WHERE EmployeeNumber = 123;
update tblTransaction
set NextNumber = NEXT VALUE FOR newSeq
where NextNumber is null
select * from tblTransaction --WHERE EmployeeNumber = 123
ROLLBACK TRAN

--SET IDENTITY_INSERT tablename ON
--DBCC CHECKIDENT(tablename,RESEED)






alter sequence newSeq
restart with 1

alter table tblTransaction
drop DF_Transaction
alter table tblTransaction
drop column NextNumber
DROP SEQUENCE newSeq


