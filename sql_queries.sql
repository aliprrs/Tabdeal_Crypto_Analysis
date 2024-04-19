-- SQL Queries for Data Analysis

-- 1. Data Aggregation
SELECT CryptoAsset, SUM(TransactionVolume) AS TotalVolume
FROM Transactions
GROUP BY CryptoAsset;

-- 2. Window Functions
SELECT UserID, TransactionAmountUSD,
       RANK() OVER (ORDER BY TransactionAmountUSD DESC) AS TransactionRank
FROM Transactions;

-- 3. Subqueries and Joins
SELECT UserID, TransactionDate
FROM Transactions
WHERE UserID NOT IN (
    SELECT UserID
    FROM Transactions
    WHERE TransactionDate < DATEADD(MONTH, -1, GETDATE())
);

-- 4. Common Table Expression (CTE)
WITH AvgTransaction AS (
    SELECT UserID, AVG(TransactionAmountUSD) AS AvgAmount
    FROM Transactions
    GROUP BY UserID
)
SELECT UserID, TransactionAmountUSD
FROM Transactions
JOIN AvgTransaction ON Transactions.UserID = AvgTransaction.UserID
WHERE TransactionAmountUSD > AvgAmount * 2;

-- 5. Conditional Aggregation
SELECT Referral, SUM(TransactionVolume) AS TotalVolume
FROM Transactions
GROUP BY Referral;

-- 6. Pivoting Data
SELECT CryptoAsset,
       SUM(CASE WHEN MONTH(TransactionDate) = 1 THEN TransactionVolume ELSE 0 END) AS JanVolume,
       SUM(CASE WHEN MONTH(TransactionDate) = 2 THEN TransactionVolume ELSE 0 END) AS FebVolume,
       ...
FROM Transactions
GROUP BY CryptoAsset;

-- 7. Temporal Queries
SELECT UserID, MAX(TransactionDate) AS LastTransactionDate
FROM Transactions
GROUP BY UserID
HAVING MAX(TransactionDate) < DATEADD(MONTH, -6, GETDATE());

-- 8. Recursive Queries (if supported)
WITH ReferralHierarchy AS (
    SELECT UserID, Referral
    FROM Users
    WHERE Referral IS NOT NULL
    UNION ALL
    SELECT r.UserID, u.Referral
    FROM Users u
    JOIN ReferralHierarchy r ON u.UserID = r.Referral
)
SELECT *
FROM ReferralHierarchy;
