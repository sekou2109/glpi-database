SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;
ALTER USER C##PAU QUOTA UNLIMITED ON USERS;
ALTER USER C##PAU QUOTA UNLIMITED ON TS_DONNEES;
ALTER USER C##PAU QUOTA UNLIMITED ON TS_INDEX;
ALTER USER C##PAU QUOTA UNLIMITED ON TS_LOGS;
ALTER USER C##PAU QUOTA UNLIMITED ON TS_SITE_CERGY;
ALTER USER C##PAU QUOTA UNLIMITED ON TS_SITE_PAU;
