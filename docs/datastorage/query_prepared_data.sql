-- Prepared dataset queries (Part 4, Emily)
-- Dialect: DuckDB. Runs locally against the reference CSV. No MotherDuck account or token needed.
--
-- Run from the PROJECT ROOT (the folder that contains README.md), for example:
--   duckdb -c ".read docs/datastorage/query_prepared_data.sql"          (DuckDB command-line tool)
--   or from Python with the runner in docs/datastorage/Data_Access.md under "Optional local SQL".
-- Paths are relative to the project root.

-- 1. A view over the CSV (in memory only, nothing is written to disk)
CREATE OR REPLACE VIEW analysis_monthly AS
SELECT *
FROM read_csv('data/transformed/analysis_monthly.csv', header = true);

-- 2. Column names and the types DuckDB detected (expect 14 columns:
--    month DATE, export_value_cad_k BIGINT, rates/changes DOUBLE, mom_pair_available BOOLEAN)
DESCRIBE analysis_monthly;

-- 3. Five-row preview, rounded for display only
SELECT strftime(month, '%Y-%m')         AS month,
       export_value_cad_k,               -- thousands of current CAD
       round(usd_cad_monthly_avg, 4)    AS usd_cad_monthly_avg,   -- CAD per USD
       round(fx_mom_pct, 2)             AS fx_mom_pct,            -- percent, NULL in January 2018
       round(exports_mom_pct, 2)        AS exports_mom_pct        -- percent, NULL in January 2018
FROM analysis_monthly
ORDER BY month
LIMIT 5;

-- 4. Structure checks (expected: 96, 96, 2018-01-01, 2025-12-01, 95, 95, 84, 7772901)
SELECT COUNT(*)                                                        AS row_count,
       COUNT(DISTINCT month)                                           AS distinct_months,
       MIN(month)                                                      AS first_month,
       MAX(month)                                                      AS last_month,
       COUNT(*) FILTER (WHERE fx_mom_pct IS NOT NULL
                          AND exports_mom_pct IS NOT NULL)             AS paired_mom_changes,
       COUNT(*) FILTER (WHERE mom_pair_available)                      AS mom_pair_available_true,
       COUNT(exports_yoy_pct)                                          AS export_yoy_changes,
       MAX(export_value_cad_k) FILTER (WHERE month = DATE '2018-02-01') AS feb_2018_export_cad_k
FROM analysis_monthly;

-- 5. Calendar gaps: months between January 2018 and December 2025 missing from the table (expect no rows)
SELECT CAST(cal.month AS DATE) AS missing_month
FROM generate_series(DATE '2018-01-01', DATE '2025-12-01', INTERVAL 1 MONTH) AS cal(month)
ANTI JOIN analysis_monthly a ON a.month = CAST(cal.month AS DATE)
ORDER BY 1;

-- 6. All columns, all months (the complete prepared table, 96 rows)
SELECT *
FROM analysis_monthly
ORDER BY month;
