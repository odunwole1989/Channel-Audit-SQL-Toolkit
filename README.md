# Channel & System Control Audit Toolkit 🚀

A collection of lightweight T-SQL scripts designed for data analysts, system control officers, and operations teams to automate daily exception monitoring in SQL Server Management Studio (SSMS).

## 📌 Features
* **Orphaned Account Detection:** Flags active credentials lacking linked employee IDs.
* **Stuck Transaction Alerts:** Identifies channel transactions lingering in `PENDING` state (>15 mins).
* **Inactive Access Audit:** Detects active user accounts dormant for >30 days to reduce overhead and risk.

## 🛠 Usage
Run `Daily_Channel_Audit.sql` in your SSMS environment to generate a single consolidated Exception Report via `UNION ALL`.
