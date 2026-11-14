# Report contribution

## 5. Structure of the Prepared Dataset (Emily)

The prepared dataset is a tidy table: each row represents one calendar month, each column represents one variable, and month is the unique key. It contains 96 rows and 14 columns covering every month from January 2018 through December 2025, without duplicate or missing months.

Each row combines the monthly value of Canadian-origin energy products (C12) exported to the United States with the monthly mean of the Bank of Canada's published daily FXUSDCAD rates. The Statistics Canada selection is Trade = Export, origin = Canada, destination = United States and product = C12. C12 is already the total; its subgroups are not added to it.

Table 1. First five months with selected columns

| Month | Export value CAD thousands | Average FX CAD per USD | FX change monthly % | Export change monthly % |
|---|---|---|---|---|
| 2018-01 | 10,020,138 | 1.2427 | N/A | N/A |
| 2018-02 | 7,772,901 | 1.2586 | 1.28 | -22.43 |
| 2018-03 | 8,436,578 | 1.2932 | 2.75 | 8.54 |
| 2018-04 | 8,343,371 | 1.2733 | -1.54 | -1.10 |
| 2018-05 | 9,491,938 | 1.2873 | 1.11 | 13.77 |

N/A denotes undefined changes, stored as blank cells in the CSV. Display rounding only.

Export values are thousands of current CAD. Exchange rates are CAD per USD, so a higher rate means a weaker Canadian dollar. Monthly changes are percentages: 1.28 means 1.28%. January 2018 has no previous month in the file, so its monthly changes are undefined and stored as blanks, not zero. Year-over-year export changes are blank for the first 12 months.

The table provides 96 complete monthly levels, 95 paired monthly changes and 84 export year-over-year changes for Milestone 3. The other fields retain the product and country selection, quality flag, daily FX observation count and availability flag. This preserves the meaning of each observation without repeating the cleaning or transformation. Association does not establish causation: currency conversion, prices, quantities and product mix can all affect CAD export values.

## 6. Data Storage and Accessibility (Emily)

We use one prepared dataset with two access options. The CSV is the reference copy and is supplied through Google Drive for immediate download. MotherDuck stores the same prepared table for readers who prefer SQL. CSV is portable and opens in Excel; MotherDuck allows queries in a web browser. Readers choose one option. Neither route requires downloading the repository, running the notebook or obtaining Emily's API token.

### Option A Download the CSV from Google Drive

1. Open the Google Drive folder using the link below, or use the direct file link.
2. Select analysis_monthly.csv and choose Download. Open the downloaded file in Excel. No Google sign-in was required in the access test.
3. Check for 96 data rows and 14 columns, January 2018 to December 2025. The February 2018 export_value_cad_k value is 7772901 (CAD thousands). Keep the original CSV unchanged.

[Open the Drive folder](https://drive.google.com/drive/folders/1cITtAQFp08k3Eg16VB2h84qYlul-cGkP?usp=sharing) or [open the CSV directly](https://drive.google.com/file/d/1XaqURO3VLrchvkVwrtXKZE7qfw-4Dgyy/view?usp=sharing).

### Optional Python access directly from Drive

This loads the full dataset without requiring a local file first. Requires Python and pandas.

```python
import pandas as pd

file_id = "1XaqURO3VLrchvkVwrtXKZE7qfw-4Dgyy"
url = "https://drive.google.com/uc?export=download&id=" + file_id
df = pd.read_csv(url, parse_dates=["month"])
print(df.shape)  # (96, 14): every row and column is loaded
print(df.head(5))  # preview only; df still contains all 96 months
```

### Option B Query the table in MotherDuck

1. Open app.motherduck.com and sign in with your own MotherDuck account. The account must use the same cloud region as the shared database.
2. Open a SQL notebook and paste the code below. ATTACH makes the read-only share available under the name milestone2; SELECT retrieves every column and month.
3. Run ATTACH once. If milestone2 already appears in your database list, skip ATTACH and run SELECT only. For a five-row preview, add LIMIT 5 before the SELECT statement's final semicolon.

```sql
ATTACH
 'md:_share/milestone2/707b0003-257d-4b21-8bec-e70a4b2ee441'
AS milestone2;

SELECT *
FROM milestone2.main.analysis_monthly
ORDER BY month;
```

The query returns all months and columns. Readers need only choose one access route.

Access checks on 14 November 2026 confirmed that the Drive file downloads without signing in and is byte-for-byte identical to the project CSV. The supplied milestone2 MotherDuck share attached successfully in the publisher's account and its table preview returned 96 rows and 14 columns, including the expected February 2018 value. A separate teammate-account check remains pending; this does not affect the verified anonymous CSV download.

For team reproduction, the reference file is data/transformed/analysis_monthly.csv and the notebook is notebooks/milestone2_pipeline.ipynb in the project folder. Part 3 creates the table; Part 4 reopens and checks it. Detailed instructions are in docs/datastorage/Data_Access.md. These local paths apply after obtaining the project files; they are not a prerequisite for either shared access route above.
