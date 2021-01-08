# Analysis of Covid-19 Incidence in the Southwestern US

Nick Milikich /
ACMS 60855 Advanced Biostatistical Methods /
December 2020

This project is an analysis of the factors influencing Covid-19 incidence and death rate for several states in the southwestern US. It looks at data on demographics, weather, education, population size, poverty, and unemployment, which are all freely available on various websites and government portals (see `instructions.pdf`). It was completed to fulfill the requirements for ACMS 60855 Advanced Biostatistical Methods at the University of Notre Dame.

The project is contained in FinalProject.R, and can be run by simply executing this one file. Also included in this repository is FinalProject.pdf, a markdown file including the source code and general conclusions of the analysis.

Running this code requires that the R packages readxl, tidyverse, and lme4 be installed.

To run the source code, the following should be included in the same directory (included in this repository):
- `_Demographics.csv`, `_MaxTemp.csv`, `_MinTemp.csv`, `_Precip.csv`, with `_` for each of Arizona, NewMexico, and Texas
- `Education.xls`
- `PopulationEstimates.xls`
- `PovertyEstimates.xls`
- `Unemployment.xls`
- `covid19.txt`

This project was run using R version 4.0.3.
