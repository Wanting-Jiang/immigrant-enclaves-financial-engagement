# immigrant-enclaves-financial-engagement
Replication code for "Financial Engagement Behaviors of Immigrant Populations," Journal of Consumer Policy

Author: Wanting Jiang, University of Wisconsin–Madison (wjiang96@wisc.edu)


## Before running

Change the global paths at the beginning of each do-file to your own directories. See the notes at the top of each do-file for the data used in this project and, where available, links for data access.

## Code

| File | What it does |
|---|---|
| `001a_data-cleaning_descriptive.do` | Cleans the FDIC survey and CPS data and constructs the outcome variables and citizenship and nativity groups. |
| `001b_data-cleaning_enclave.do` | Builds the enclave measure and the 1990 settlement-share instrument. |
| `002a_Analysis-Descriptive.do` | Summary statistics and baseline results by citizenship and nativity group. |
| `002b_Analysis-Enclave.do` | Main 2SLS enclave results. |
| `003_Robustness-Check.do` | Robustness and sensitivity checks. |
