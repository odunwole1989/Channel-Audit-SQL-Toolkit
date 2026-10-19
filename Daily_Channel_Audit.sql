-- Daily Channel & System Exception Audit Script
-- Author: Odunwole
-- Database: Microsoft SQL Server (T-SQL)

DROP TABLE IF EXISTS #system_users;
DROP TABLE IF EXISTS #channel_transactions;
DROP TABLE IF EXISTS #core_system_access;

-- 1. Create temporary test tables
CREATE TABLE #system_users (
    account_id INT IDENTITY(1,1),
    email VARCHAR(100),
    status VARCHAR(20),
    employee_id INT,
    date_created DATETIME
);

CREATE TABLE #channel_transactions (
    transaction_id INT IDENTITY(1,1),
    channel_id VARCHAR(50),
    created_at DATETIME,
    status VARCHAR(20)
);

CREATE TABLE #core_system_access (
    user_id INT IDENTITY(1,1),
    last_login_date DATETIME,
    role VARCHAR(50),
    status VARCHAR(20)
);

-- 2. Insert test data
INSERT INTO #system_users VALUES ('unlinked.user@company.com', 'ACTIVE', NULL, GETDATE());
INSERT INTO #channel_transactions VALUES ('MOBILE_API_02', DATEADD(MINUTE, -30, GETDATE()), 'PENDING');
INSERT INTO #core_system_access VALUES (DATEADD(DAY, -45, GETDATE()), 'USER', 'ACTIVE');

-- 3. Consolidated Exception Report (UNION ALL)
SELECT 
    'Orphaned Account' AS [Exception_Type], 
    email AS [Entity_Identifier], 
    CONVERT(VARCHAR, date_created, 120) AS [Event_Timestamp]
FROM #system_users 
WHERE status = 'ACTIVE' AND employee_id IS NULL

UNION ALL

SELECT 
    'Stuck Transaction' AS [Exception_Type], 
    channel_id AS [Entity_Identifier], 
    CONVERT(VARCHAR, created_at, 120) AS [Event_Timestamp]
FROM #channel_transactions 
WHERE status = 'PENDING' AND created_at < DATEADD(MINUTE, -15, GETDATE())

UNION ALL

SELECT 
    'Inactive Active User' AS [Exception_Type], 
    CONCAT('User_ID: ', user_id) AS [Entity_Identifier], 
    CONVERT(VARCHAR, last_login_date, 120) AS [Event_Timestamp]
FROM #core_system_access 
WHERE status = 'ACTIVE' AND last_login_date < DATEADD(DAY, -30, GETDATE());
