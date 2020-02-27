CREATE TABLE transactions(
    date DATE,
    activity CHAR(7),
    source VARCHAR,
    destination VARCHAR,
    energy REAL,
    total_value REAL,
    price REAL,
    PRIMARY KEY (date, activity, source, destination)
);

/*  NOTE: This path refers to the relative path from the Data Directory
    YOUR Data Directory can be found by executing the SHOW DATA_DIRECTORY command in SQL
    Simply copy the PhaseOneDataset into your Data Directory. */

copy transactions from 'PhaseOneDataset/elec_import_export.csv' (FORMAT CSV, ENCODING 'ISO-8859-1', NULL 'Confidential');
