/*
||  Name:          apply_plsql_lab9.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 10 lab.
*/

-- Call seeding libraries from within the following file.
@$CIT325/lab9/apply_prep_lab9.sql

-- Open log file.
SPOOL apply_plsql_lab9.txt

-- ... insert your solution here ...

CREATE TABLE avenger
( avenger_id      NUMBER
, first_name      VARCHAR2(20)
, last_name       VARCHAR2(20)
, character_name  VARCHAR2(20))
 ORGANIZATION EXTERNAL
 ( TYPE oracle_loader
   DEFAULT DIRECTORY uploadtext
   ACCESS PARAMETERS
   ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
     BADFILE     'UPLOAD':'avenger.bad'
     DISCARDFILE 'UPLOAD':'avenger.dis'
     LOGFILE     'UPLOAD':'avenger.log'
     FIELDS TERMINATED BY ','
     OPTIONALLY ENCLOSED BY "'"
     MISSING FIELD VALUES ARE NULL )
   LOCATION ('avenger.csv'))
REJECT LIMIT 0;

SELECT * FROM avenger;


CREATE TABLE file_list
( file_name VARCHAR2(60))
ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY uploadtext
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      PREPROCESSOR uploadtext:'dir_list.sh'
      BADFILE     'UPLOADTEXT':'dir_list.bad'
      DISCARDFILE 'UPLOADTEXT':'dir_list.dis'
      LOGFILE     'UPLOADTEXT':'dir_list.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL)
    LOCATION ('dir_list.sh'))
  REJECT LIMIT UNLIMITED;
  
  SELECT * FROM file_list;

DECLARE
 /* Declare a cursor to find a single row from the item table. */
 CURSOR c IS
   SELECT i.item_id
   ,      i.item_title
   FROM   item i INNER JOIN common_lookup cl
   ON     i.item_type = cl.common_lookup_id
   WHERE  UPPER(i.item_title) LIKE '%GOBLET%'
   AND    UPPER(cl.common_lookup_meaning) = 'DVD: WIDE SCREEN';
BEGIN
  /* Read the cursor and load one large text file to the row. */
  FOR i IN c LOOP
    load_clob_from_file( src_file_name     => 'HarryPotter4.txt'
					   , src_clob_vdir	   => 'UPLOADTEXT'
                       , table_name        => 'ITEM'
                       , column_name       => 'ITEM_DESC'
                       , primary_key_name  => 'ITEM_ID'
                       , primary_key_value => TO_CHAR(i.item_id) );
  END LOOP;
END;
/


SELECT i.item_id
,      i.item_title
,      LENGTH(i.item_desc)
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  UPPER(i.item_title) LIKE '%GOBLET%'
AND    UPPER(cl.common_lookup_meaning) = 'DVD: WIDE SCREEN';

UPDATE item i
SET    i.item_title = 'Harry Potter and the Sorcerer''s Stone'
WHERE  i.item_title = 'Harry Potter and the Sorcer''s Stone';


ALTER TABLE ITEM ADD (text_file_name VARCHAR2(40));

COL text_file_name  FORMAT A16
COL item_title      FORMAT A42
SELECT   DISTINCT
         text_file_name
,        item_title
FROM     item i INNER JOIN common_lookup cl
ON       i.item_type = cl.common_lookup_id
WHERE    REGEXP_LIKE(i.item_title,'^.*'||'Harry'||'.*$')
AND      cl.common_lookup_table = 'ITEM'
AND      cl.common_lookup_column = 'ITEM_TYPE'
AND      REGEXP_LIKE(cl.common_lookup_type,'^(dvd|vhs).*$','i')
ORDER BY i.item_title;

UPDATE item i
SET    i.text_file_name = 'HarryPotter1.txt'
WHERE  i.item_title = 'Harry Potter and the Sorcerer''s Stone';

UPDATE item i
SET    i.text_file_name = 'HarryPotter2.txt'
WHERE  i.item_title = 'Harry Potter and the Chamber of Secrets';

UPDATE item i
SET    i.text_file_name = 'HarryPotter3.txt'
WHERE  i.item_title = 'Harry Potter and the Prisoner of Azkaban';

UPDATE item i
SET    i.text_file_name = 'HarryPotter4.txt'
WHERE  i.item_title = 'Harry Potter and the Goblet of Fire';

UPDATE item i
SET    i.text_file_name = 'HarryPotter5.txt'
WHERE  i.item_title = 'Harry Potter and the Order of the Phoenix';


COL text_file_name  FORMAT A16
COL item_title      FORMAT A42
SELECT   DISTINCT
         text_file_name
,        item_title
FROM     item i INNER JOIN common_lookup cl
ON       i.item_type = cl.common_lookup_id
WHERE    REGEXP_LIKE(i.item_title,'^.*'||'Harry'||'.*$')
AND      cl.common_lookup_table = 'ITEM'
AND      cl.common_lookup_column = 'ITEM_TYPE'
AND      REGEXP_LIKE(cl.common_lookup_type,'^(dvd|vhs).*$','i')
ORDER BY i.text_file_name;


DECLARE
 /* Declare a cursor to find a single row from the item table. */
 CURSOR c IS
   SELECT i.item_id
   ,      i.text_file_name
   FROM   item i INNER JOIN file_list fl
   ON     i.text_file_name = fl.file_name
   WHERE  UPPER(i.item_title) LIKE 'HARRY%'
   AND    i.text_file_name IS NOT NULL;
BEGIN
  /* Read the cursor and load one large text file to the row. */
  FOR i IN c LOOP
    load_clob_from_file( src_file_name     => i.text_file_name
					   , src_clob_vdir	   => 'UPLOADTEXT'
                       , table_name        => 'ITEM'
                       , column_name       => 'ITEM_DESC'
                       , primary_key_name  => 'ITEM_ID'
                       , primary_key_value => TO_CHAR(i.item_id) );
  END LOOP;
END;
/

CREATE OR REPLACE
	PROCEDURE upload_item_description
    (	pv_item_title	VARCHAR2 ) IS
    
 /* Declare a cursor to find a single row from the item table. */
 CURSOR c
 (	cv_item_title	VARCHAR2 ) IS
   SELECT i.item_id
   ,      i.text_file_name
   FROM   item i INNER JOIN file_list fl
   ON     i.text_file_name = fl.file_name
   WHERE  UPPER(i.item_title) LIKE cv_item_title||'%'
   AND    i.text_file_name IS NOT NULL;
BEGIN
  /* Read the cursor and load one large text file to the row. */
  FOR i IN c(pv_item_title) LOOP
    load_clob_from_file( src_file_name     => i.text_file_name
					   , src_clob_vdir	   => 'UPLOADTEXT'
                       , table_name        => 'ITEM'
                       , column_name       => 'ITEM_DESC'
                       , primary_key_name  => 'ITEM_ID'
                       , primary_key_value => TO_CHAR(i.item_id) );
  END LOOP;
END;
/

EXECUTE upload_item_description('Harry Potter');


COL item_id     FORMAT 9999
COL item_title  FORMAT A44
COL text_size   FORMAT 999,999
SET PAGESIZE 99
SELECT   item_id
,        item_title
,        LENGTH(item_desc) AS text_size
FROM     item
WHERE    REGEXP_LIKE(item_title,'^Harry Potter.*$')
AND      item_type IN
          (SELECT common_lookup_id 
           FROM   common_lookup 
           WHERE  common_lookup_table = 'ITEM' 
           AND    common_lookup_column = 'ITEM_TYPE'
           AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs).*$','i'))
ORDER BY item_id;
COMMIT
-- Close log file.
SPOOL OFF

