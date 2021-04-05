/*
||  Name:          apply_plsql_lab11.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 12 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql
@/home/student/Data/cit325/lab9/apply_plsql_lab9.sql
-- Open log file.
SPOOL apply_plsql_lab11.txt

ALTER TABLE item
ADD text_file_name varchar2(30);

DROP TABLE logger;
DROP SEQUENCE logger_s1;


CREATE TABLE logger
( LOGGER_ID                         NUMBER CONSTRAINT logger_pk NOT NULL PRIMARY KEY
 ,OLD_ITEM_ID                       NUMBER
 ,OLD_ITEM_BARCODE                  VARCHAR2(20)
 ,OLD_ITEM_TYPE                     NUMBER
 ,OLD_ITEM_TITLE                    VARCHAR2(60)
 ,OLD_ITEM_SUBTITLE                 VARCHAR2(60)
 ,OLD_ITEM_RATING                   VARCHAR2(8)
 ,OLD_ITEM_RATING_AGENCY            VARCHAR2(4)
 ,OLD_ITEM_RELEASE_DATE             DATE
 ,OLD_CREATED_BY                    NUMBER
 ,OLD_CREATION_DATE                 DATE
 ,OLD_LAST_UPDATED_BY               NUMBER
 ,OLD_LAST_UPDATE_DATE              DATE
 ,OLD_TEXT_FILE_NAME                VARCHAR2(40)
 ,NEW_ITEM_ID                       NUMBER
 ,NEW_ITEM_BARCODE                  VARCHAR2(20)
 ,NEW_ITEM_TYPE                     NUMBER
 ,NEW_ITEM_TITLE                    VARCHAR2(60)
 ,NEW_ITEM_SUBTITLE                 VARCHAR2(60)
 ,NEW_ITEM_RATING                   VARCHAR2(8)
 ,NEW_ITEM_RATING_AGENCY            VARCHAR2(4)
 ,NEW_ITEM_RELEASE_DATE             DATE
 ,NEW_CREATED_BY                    NUMBER
 ,NEW_CREATION_DATE                 DATE
 ,NEW_LAST_UPDATED_BY               NUMBER
 ,NEW_LAST_UPDATE_DATE              DATE
 ,NEW_TEXT_FILE_NAME                VARCHAR2(40));

CREATE SEQUENCE logger_s1;


DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'Brave Heart';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
 
  INSERT INTO logger
  ( logger_id
  , old_item_id
  , old_item_title
  , new_item_id
  , new_item_title)
  VALUES
  ( logger_s1.NEXTVAL
  , 1014
  , 'Brave Heart'
  , 1014
  , 'Brave Heart');
 
  END LOOP;
END;
/

/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;


 @/home/student/Data/cit325/lab11/create_spec11.sql



desc manage_item;


DECLARE

    CURSOR get_row IS
        SELECT * FROM item WHERE item_title = 'King Arthur';
BEGIN

    FOR i IN get_row LOOP
    
    manage_item.item_insert
    ( pv_new_item_id                => i.item_id
    , pv_new_item_barcode           => i.item_barcode
    , pv_new_item_type              => i.item_type
    , pv_new_item_title             => i.item_title
    , pv_new_item_subtitle          => i.item_subtitle
    , pv_new_item_rating            => i.item_rating
    , pv_new_item_rating_agency     => i.item_rating_agency
    , pv_new_item_release_date      => i.item_release_date
    , pv_new_item_created_by        => i.item_created_by
    , pv_new_item_creation_date     => i.item_creation_date
    , pv_new_item_last_updated_by   => i.item_last_updated_by
    , pv_new_item_update_date       => i.item_update_date
    , pv_new_item_text_file_name    => i.item_text_file_name
    , pv_old_item_id                => i.item_id
    , pv_old_item_barcode           => i.item_barcode
    , pv_old_item_type              => i.item_type
    , pv_old_item_title             => i.item_title
    , pv_old_item_subtitle          => i.item_subtitle
    , pv_olditem_rating             => i.item_rating
    , pv_old_item_rating_agency     => i.item_rating_agency
    , pv_old_item_release_date      => i.item_release_date
    , pv_old_item_created_by        => i.item_created_by
    , pv_old_item_creation_date     => i.item_creation_date
    , pv_old_item_last_updated_by   => i.item_last_updated_by
    , pv_old_item_update_date       => i.item_update_date
    , pv_old_item_text_file_name    => i.item_text_file_name );
    
    manage_item.item_insert
    ( pv_new_item_id                => i.item_id
    , pv_new_item_barcode           => i.item_barcode
    , pv_new_item_type              => i.item_type
    , pv_new_item_title             => i.item_title
    , pv_new_item_subtitle          => i.item_subtitle
    , pv_new_item_rating            => i.item_rating
    , pv_new_item_rating_agency     => i.item_rating_agency
    , pv_new_item_release_date      => i.item_release_date
    , pv_new_item_created_by        => i.item_created_by
    , pv_new_item_creation_date     => i.item_creation_date
    , pv_new_item_last_updated_by   => i.item_last_updated_by
    , pv_new_item_update_date       => i.item_update_date
    , pv_new_item_text_file_name    => i.item_text_file_name );
    
    manage_item.item_insert
    ( pv_old_item_id                => i.item_id
    , pv_old_item_barcode           => i.item_barcode
    , pv_old_item_type              => i.item_type
    , pv_old_item_title             => i.item_title
    , pv_old_item_subtitle          => i.item_subtitle
    , pv_olditem_rating             => i.item_rating
    , pv_old_item_rating_agency     => i.item_rating_agency
    , pv_old_item_release_date      => i.item_release_date
    , pv_old_item_created_by        => i.item_created_by
    , pv_old_item_creation_date     => i.item_creation_date
    , pv_old_item_last_updated_by   => i.item_last_updated_by
    , pv_old_item_update_date       => i.item_update_date
    , pv_old_item_text_file_name    => i.item_text_file_name );
    
    END LOOP;
END;
/

/* Query the logger table. */

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;



CREATE OR REPLACE TRIGGER item_trig
    BEFORE INSERT OR UPDATE OF item_title ON item
    FOR EACH ROW
DECLARE

    lv_input_title  VARCHAR2(80);
    lv_item_title        VARCHAR2(40);
    lv_item_subtitle     VARCHAR2(40);
    
BEGIN

    lv_input_title := :NEW.item_title;
    
    IF REGEXP_INSTR(lv_input_title,':') > 0 AND
        REGEXP_INSTR(lv_input_title,':' = LENGTH(lv_input_title) THEN
        
        lv_item_title := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') -1);
        lv_item_subtitle := :NEW.item_subtitle;
      ELSIF REGEXP_INSTR(lv_input_title,':') > 0 THEN
    
         lv_item_title := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') -1);
         lv_item_subtitle := LTRIM(SUBSTR(lv_input_title,REGEXP_INSTR(lv_input_title,':') + 1, LENGTH(lv_input_title)));
      ELSE
    
         lv_item_subtitle := :NEW.item_subtitle;
         
      END IF;
    IF INSERTING THEN
    
        manage_item.item_insert
        ( pv_new_item_id                => :NEW.item_id
        , pv_new_item_barcode           => :NEW.item_barcode
        , pv_new_item_type              => :NEW.item_type
        , pv_new_item_title             => lv_item_title
        , pv_new_item_subtitle          => lv_item_subtitle
        , pv_new_item_rating            => :NEW.item_rating
        , pv_new_item_rating_agency     => :NEW.item_rating_agency
        , pv_new_item_release_date      => :NEW.item_release_date
        , pv_new_item_created_by        => :NEW.item_created_by
        , pv_new_item_creation_date     => :NEW.item_creation_date
        , pv_new_item_last_updated_by   => :NEW.item_last_updated_by
        , pv_new_item_update_date       => :NEW.item_update_date
        , pv_new_item_text_file_name    => :NEW.item_text_file_name );

    ELSIF UPDATING THEN
        
         manage_item.item_insert
        ( pv_new_item_id                => :NEW.item_id
        , pv_new_item_barcode           => :NEW.item_barcode
        , pv_new_item_type              => :NEW.item_type
        , pv_new_item_title             => i.item_title
        , pv_new_item_subtitle          => i.item_subtitle
        , pv_new_item_rating            => :NEW.item_rating
        , pv_new_item_rating_agency     => :NEW.item_rating_agency
        , pv_new_item_release_date      => :NEW.item_release_date
        , pv_new_item_created_by        => :NEW.item_created_by
        , pv_new_item_creation_date     => :NEW.item_creation_date
        , pv_new_item_last_updated_by   => :NEW.item_last_updated_by
        , pv_new_item_update_date       => :NEW.item_update_date
        , pv_new_item_text_file_name    => :NEW.item_text_file_name
        , pv_old_item_id                => :OLD.item_id
        , pv_old_item_barcode           => :OLD.item_barcode
        , pv_old_item_type              => :OLD.item_type
        , pv_old_item_title             => :OLD.item_title
        , pv_old_item_subtitle          => :OLD.item_subtitle
        , pv_olditem_rating             => :OLD.item_rating
        , pv_old_item_rating_agency     => :OLD.item_rating_agency
        , pv_old_item_release_date      => :OLD.item_release_date
        , pv_old_item_created_by        => :OLD.item_created_by
        , pv_old_item_creation_date     => :OLD.item_creation_date
        , pv_old_item_last_updated_by   => :OLD.item_last_updated_by
        , pv_old_item_update_date       => :OLD.item_update_date
        , pv_old_item_text_file_name    => :OLD.item_text_file_name );
    END IF;
END item_trig;
/


COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_type      FORMAT 9999 HEADING "Item|Type"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_type
,      i.item_rating
FROM   item i
WHERE  i.item_title = 'Star Wars';





COL common_lookup_table   FORMAT A14 HEADING "Common Lookup|Table"
COL common_lookup_column  FORMAT A14 HEADING "Common Lookup|Column"
COL common_lookup_type    FORMAT A14 HEADING "Common Lookup|Type"
SELECT common_lookup_table
,      common_lookup_column
,      common_lookup_type
FROM   common_lookup
WHERE  common_lookup_table = 'ITEM'
AND    common_lookup_column = 'ITEM_TYPE'
AND    common_lookup_type = 'BLU-RAY';




COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';



/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;




COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';


COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;



COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';



COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- Close log file.
SPOOL OFF
