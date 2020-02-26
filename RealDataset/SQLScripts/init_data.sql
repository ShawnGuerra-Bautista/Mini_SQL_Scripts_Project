/*  NOTE: This path refers to the relative path from the Data Directory
    YOUR Data Directory can be found by executing the SHOW DATA_DIRECTORY command in SQL
    Simply copy the MovieLensData into your Data Directory. */

copy transactions from 'PhaseOneDataset/elec_import_export.csv' (FORMAT CSV, ENCODING 'ISO-8859-1', NULL 'Confidential');