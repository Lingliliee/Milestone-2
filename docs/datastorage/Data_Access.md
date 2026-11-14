# Get the prepared dataset

Use **one** of the two routes below. You do not need this repository on your computer to begin.
The complete dataset is **96 months × 14 columns**, January 2018 to December 2025.

## A Download and open in Excel

1. [Open the Google Drive folder](https://drive.google.com/drive/folders/1cITtAQFp08k3Eg16VB2h84qYlul-cGkP?usp=sharing).
2. Select **analysis_monthly.csv**, then choose **Download**. [Direct file page](https://drive.google.com/file/d/1XaqURO3VLrchvkVwrtXKZE7qfw-4Dgyy/view?usp=sharing).
3. Open the downloaded CSV in Excel. The access test required no Google sign-in.
4. Check 96 data rows and 14 columns. February 2018 `export_value_cad_k` is **7772901** (CAD thousands).

This is the simplest route for inspecting the data. Preserve the original file; save analysis separately.

### Python users Load the Drive file directly

Install pandas once if necessary: `python -m pip install pandas`. No local project path is required.

```python
import pandas as pd

file_id = "1XaqURO3VLrchvkVwrtXKZE7qfw-4Dgyy"
url = "https://drive.google.com/uc?export=download&id=" + file_id
df = pd.read_csv(url, parse_dates=["month"])
print(df.shape)  # (96, 14): every row and column is loaded
print(df.head(5))  # preview only; df still contains all 96 months
```

`df` contains all 96 rows and 14 columns; `head(5)` only prints a preview.

## B Query in MotherDuck with SQL

1. Go to [MotherDuck](https://app.motherduck.com/) and sign in with your **own** account.
2. Use an account in the same cloud region as the share owner. If a region/access error appears, ask the owner which region to choose.
3. Open a SQL notebook, paste the code below, and run it. No Python, API token or `.env` file is needed for this web route.

```sql
ATTACH
 'md:_share/milestone2/707b0003-257d-4b21-8bec-e70a4b2ee441'
AS milestone2;

SELECT *
FROM milestone2.main.analysis_monthly
ORDER BY month;
```

Run ATTACH once. It creates the read-only database reference **milestone2** in your workspace.
If that name is already attached, run only SELECT. If it refers to an unrelated database, use a different alias after AS and use that alias in the FROM clause.
SELECT returns **all columns and months**. Add `LIMIT 5` before its final semicolon for a preview.

The share named `milestone2` comes from the publisher's `energy_fx_prepared` database. Its table is `main.analysis_monthly`.
The share uses link access and automatic updates. This does not make the underlying table editable by recipients.

Optional recognition checks:

```sql
SELECT COUNT(*) AS rows, COUNT(DISTINCT month) AS distinct_months,
       MIN(month) AS first_month, MAX(month) AS last_month
FROM milestone2.main.analysis_monthly;

SELECT export_value_cad_k
FROM milestone2.main.analysis_monthly
WHERE month = DATE '2018-02-01';
```

Expected: 96 rows, 96 distinct months, 2018-01-01 to 2025-12-01, February export value 7772901.
[MotherDuck sharing and region requirements](https://motherduck.com/docs/key-tasks/sharing-data/sharing-overview/).

## What the columns mean

- One row is one calendar month. `month` is the unique key.
- `export_value_cad_k`: thousands of current CAD; C12 energy products, Trade = Export, Canadian origin, U.S. destination.
- `usd_cad_monthly_avg`: average of published daily FXUSDCAD rates, CAD per USD.
- `fx_mom_pct` and `exports_mom_pct`: monthly percentage changes; blank in January 2018. 95 paired months.
- `exports_yoy_pct`: annual percentage change; blank in 2018. 84 available months.
- Blank changes are undefined, not zero. `2.5` means 2.5%. The other fields retain source selection and quality information.

## Optional For teammates who already have the project

These instructions apply **after downloading/extracting the project**, not to an outsider who only has this page.
The project root is the folder containing `README.md`. The reference CSV is `data/transformed/analysis_monthly.csv`.

```python
from pathlib import Path
import pandas as pd

root = Path.cwd().parent if Path.cwd().name == "notebooks" else Path.cwd()
df = pd.read_csv(root / "data/transformed/analysis_monthly.csv",
                 parse_dates=["month"], dtype={"status": "string"})
print(df.shape)  # (96, 14)
```

The notebook is `notebooks/milestone2_pipeline.ipynb`. Run only **Part 4** to inspect the existing prepared table.
Running earlier parts regenerates cleaning/transformation outputs and is unnecessary for access.

### Optional local SQL

This reads the project CSV locally; it is a separate option from MotherDuck. Requires the DuckDB Python package.
From the project root:

```python
import duckdb
from pathlib import Path

con = duckdb.connect()
sql = Path("docs/datastorage/query_prepared_data.sql").read_text(encoding="utf-8")
result = con.execute(sql).df()
print(result.shape)  # (96, 14), the final query returns the full table
```

Or, with the separately installed DuckDB CLI:
`duckdb -c ".read docs/datastorage/query_prepared_data.sql"`.

## Why two routes

CSV is portable and opens in Excel. MotherDuck lets SQL users query the same prepared data in a browser.
The project CSV remains the reference copy. Readers choose one route, and Markdown supplies the instructions.

## Verification status on 14 November 2026

| Check | Result |
|---|---|
| Local Part 4, pandas and DuckDB | 96 × 14; full local values match; 95 MoM pairs and 84 YoY changes |
| Drive anonymous download | HTTP 200; 14,358 bytes; byte-identical to reference CSV; SHA-256 fb2ef5816ea81fa9cda50a9dc73709ca405cafae7df98968646aa18255705f0d |
| New milestone2 share | Attached successfully in publisher's existing account; main.analysis_monthly preview returned 96 rows and 14 columns; February value 7772901 |
| Independent MotherDuck recipient account | Pending; publisher attachment does not establish another account's permissions/region |
| GitHub publication of this local update | Not performed by this task |

See [Workflow_and_Verification.md](Workflow_and_Verification.md) for preservation and cleanup details.
