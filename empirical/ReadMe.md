### Replicating Empirical Figures

1.  The file input_wdi.do reads in the data from the WDI database, combines it with the Wealth of Nations database, and stores the merged data as "debt_data.dta" in the data folder.  Note that as the WDI is updated, some series may change.  The file wdi_data.dta in the data folder, which was created in October 2023, is the vintage used in the lecture.  The latest version of the Wealth of Nations data can be found here:  https://www.brookings.edu/articles/the-external-wealth-of-nations-database/.  The lecture used the version from 2022.
   
2.  The file data_figures.do generates the empirical figures in the lecture (Figures 1-12).
