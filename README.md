# SCM Query Lab

Static website for choosing real SQLite SELECT queries, adding parameter-bound filters, selecting output columns, grouping and exporting results.

The browser loads a gzip-compressed snapshot of the synthetic SCM database: 30 dates, 456 observed products, six business tables containing 18,000 source rows, 14 physical tables and 10 views. No application server or remote database connection is used for query execution.

## Features

- Fourteen named SQL templates and direct selection of all 24 tables/views.
- Date, category, MD, supplier and product search filters. Unavailable filters are disabled.
- Up to twelve custom conditions with AND/OR, comparisons, ranges, IN/NOT IN, text matching and NULL checks.
- Output column picker, up to three grouping keys, SUM/AVG/MIN/MAX, row count, distinct count and time-weighted stockout percentage.
- Actual parameterized SQL preview and copy, sorting, pagination and up to 50,000-result CSV export.
- Bar, line and numeric scatter charts with explicit chart aggregation.
- Browser-local saved query preferences (up to twenty), JSON export and schema inspection.
- Compatible local `.db` file selection, processed entirely in browser memory. No file upload request is issued.

## Data freshness and scope

The online default snapshot ends on 2026-11-07. It does not synchronize with a user's PC. Select an updated `scm.db` file to query newer PC data. An explicitly connected DB now persists in browser IndexedDB and is shared with the data connection and virtual-center pages, including other same-origin tabs. Before any connection is selected, the SQL page uses the hosted synthetic snapshot.

The database must have the original SCM application ID and schema. File selection is limited to 100 MB. Query and center views are read-only and do not modify the selected PC file. The data connection page can import original files into a browser-local copy and export the resulting DB. SQL definitions are supplied by known presets or quoted identifiers; values are bound as parameters.

Filtering wraps the selected SQL as a subquery. Therefore, a pre-aggregated preset is filtered after its existing aggregation. For pre-aggregation MD/category filtering, start from `v_sku_day` and configure grouping. Multiple-day inventory sums and unweighted rate averages require interpretation; UI warnings explain this.

## Runtime

This is a buildless static site. `dist/` is published according to `.openai/hosting.json`.
SQL.js is vendored from its official npm package with a verified SHA-512 package integrity value. Its version, origin and MIT license are retained under `dist/assets/`.

## Validation

See `validation.json` for actual database query checks and browser checks. SQL preset execution, all source objects, compound filters, parameter injection attempts, literal LIKE escaping, grouping and weighted percentages, invalid numeric/identifier rejection and database read-only mode were tested against the SQLite snapshot.
Browser checks verified 100 default rows, 27 latest stockout rows, five stockout rows for ambient food, thirty daily weighted groups, saved queries, opening a local DB file, schema inspection and CSV export of 100 rows and ten columns.
