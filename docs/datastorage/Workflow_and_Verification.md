# Storage and access verification

Review date: 14 November 2026. Paths below are relative to the folder containing README.md.

## What this contribution does

Part 3 already produced the monthly table. Part 4 demonstrates its tidy structure and verifies retrieval.
The report contribution is in [Sections_5_and_6.md](Sections_5_and_6.md), and outsider instructions are in [Data_Access.md](Data_Access.md).
One dataset is offered as an immediately downloadable Drive CSV and an optional MotherDuck SQL share.

## Checks and their limits

| Item | Result |
|---|---|
| Prepared table | 96 rows, 14 columns, complete Jan 2018–Dec 2025 calendar, unique month key |
| Usable observations | 96 complete levels, 95 paired MoM changes, 84 export YoY changes |
| Local pandas vs DuckDB | Current Part 4 passes all 12 checks from both the project root and notebooks folder; exact full-table match |
| Current documentation examples | Both local Python examples pass; exact Drive Python example retrieves 96 × 14 without sign-in; optional DuckDB CLI is not installed and was not tested |
| Relative documentation links | All 17 links in README, storage docs and Part 4 resolve; no obsolete personal-name paths remain |
| February 2018 recognition value | 7772901 CAD thousands |
| Drive | Anonymous download returned HTTP 200 and is byte-identical to project CSV (14,358 bytes) |
| Drive CSV SHA-256 | fb2ef5816ea81fa9cda50a9dc73709ca405cafae7df98968646aa18255705f0d |
| Current MotherDuck share | `md:_share/milestone2/707b0003-257d-4b21-8bec-e70a4b2ee441` |
| Share source | energy_fx_prepared.main.analysis_monthly |
| Current share attachment | Successful in publisher account; attached as milestone2; table preview returned 96 rows and 14 columns with expected February value |
| Share settings observed | Link access; discoverable; automatic updates; recipient table access is read-only |
| Prior publisher full-table check | Original publication record reports zero rows differing in either direction against local CSV, matching NULL counts and correct types |
| Independent MotherDuck account | Pending; recipient must use the same cloud region and their own account |
| GitHub push | Not performed in this task; the downloaded local folder is not proof of online publication |

## Preserving the team pipeline

- All raw, cleaned and transformed CSV contents are preserved. No earlier pipeline cells are executed during this cleanup.
- Notebook Parts 2 and 3, their outputs, execution counts, IDs and metadata remain unchanged from the start of this cleanup.
- Compared with the original backup, three earlier saved outputs use lists of lines instead of a single string. Their displayed contents are identical; this predates the cleanup.
- Part 4 code and results are preserved. Only its Markdown links and hand-off explanations change.
- The README and setup script now distinguish simple data access from optional full pipeline reproduction.
- All live storage documentation paths use docs/datastorage/. No personal-name documentation directory is required.

## Cleanup decisions

Removed only data/raw/.gitkeep and data/clean/.gitkeep: zero-byte placeholders in folders already containing real CSVs.
There is no active .env file inside the repository. The nonsecret .env.example template remains because teammates' optional MotherDuck pipeline code and python-dotenv support use that configuration.
setup.bat no longer creates .env automatically or asks all readers for a token, and it points to the actual milestone2_pipeline.ipynb.
requirements.txt, pyproject.toml, uv.lock, .python-version, .gitignore and the teammate cleaning log remain necessary for reproducibility and are retained.

## How to repeat

1. Follow Data_Access.md option A for the anonymous CSV route, or option B for browser SQL.
2. For local project inspection, run only Part 4 in notebooks/milestone2_pipeline.ipynb.
3. Optional local SQL file: docs/datastorage/query_prepared_data.sql. Run its Python example from the project root.
4. Check dimensions, full calendar and the February recognition value. A small preview is not the complete dataset.

The backup folder is untouched. The rest of the group submission, including other report sections, sources, AI-use declaration and meeting minutes/photo, remains the team's responsibility.
