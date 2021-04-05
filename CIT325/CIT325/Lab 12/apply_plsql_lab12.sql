/*
||  Name:          apply_plsql_lab12.sql
||  Date:          27 March 2021
||  Purpose:       Complete 325 Chapter 12 lab.
*/

-- Call seeding libraries.
@$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab12.txt


-- Create an item_obj object type.
CREATE OR REPLACE
  TYPE item_obj IS OBJECT
  ( title               VARCHAR2(60)
  , subtitle            VARCHAR2(60)
  , rating              VARCHAR2(8)
  , release_date        DATE );
/
desc item_obj


CREATE OR REPLACE
  TYPE item_tab IS TABLE of item_obj;
/

desc item_tab

-- Assign TRUNC(SYSDATE) + 1 as the DEFAULT value of the pv_end_date parameter.
CREATE OR REPLACE
  FUNCTION item_list
  ( pv_start_date  DATE
  , pv_end_date    DATE DEFAULT TRUNC(SYSDATE) + 1) RETURN item_tab IS
 
 -- Create an item_rec record type that mirrors the item_obj object type.
    TYPE item_rec IS RECORD
    ( title             VARCHAR2(60)
    , subtitle          VARCHAR2(60)
    , rating            VARCHAR2(8)
    , release_date      DATE );
 
-- Create an item_cur system reference cursor that is weakly typed cursor.
    item_cur   SYS_REFCURSOR;
 
-- Create an item_row variable of the item_rec data type
    item_row      ITEM_REC;
    
-- Create an item_set variable of the item_tab collection type, and create an empty instance of the item_tab collection.
    item_set      ITEM_TAB := item_tab();
 
-- Create a stmt string variable to hold a Native Dynamic SQL (NDS) variable.
    stmt  VARCHAR2(2000);
  BEGIN
         -- item_title with an alias of title
    stmt := 'SELECT     i.item_title AS title'||CHR(10)
         -- item_subtitle with an alias of subtitle 
         || ',          i.item_subtitle AS subtitle'||CHR(10)
         -- item_rating with an alias of rating
         || ',          i.item_rating AS rating'||CHR(10)
         -- item_release_date with an alias of release_date
         || ',          i.item_release_date AS release_date'||CHR(10)
         || 'FROM       item i'||CHR(10)
         -- WHERE clause should check for an item_rating_agency value of MPAA and an item_release_date 
         || 'WHERE      i.item_rating_agency = ''MPAA'''||CHR(10)
         || 'AND        i.item_release_date BETWEEN :start_date AND :end_date';

    -- Open the item_cur system reference cursor with the stmt dynamic statement, and assign the pv_start_date 
    -- and pv_end_date variables inside the USING clause.
    OPEN item_cur FOR stmt USING pv_start_date, pv_end_date;
    LOOP
    -- Fetch the item_cur system reference cursor into the item_row variable of the item_rec data type.
      FETCH item_cur INTO item_row;
      EXIT WHEN item_cur%NOTFOUND;
    
    -- Extend space in the item_set variable of the item_tab collection.
      item_set.EXTEND;
      item_set(item_set.COUNT) :=
      -- Use a item_row variable to create an instance of the item_set collection.
        item_obj( title         => item_row.title
                , subtitle      => item_row.subtitle
                , rating        => item_row.rating 
                , release_date  => item_row.release_date );
    END LOOP;
 
    RETURN item_set;
  END item_list;
/
-- describe the item_list function
desc item_list

-- test the item_list function with a query that uses the TABLE function and returns only the title and rating 
-- members from each of the item_obj object types.
COLUMN title FORMAT A60;
SELECT item_list.title
,      item_list.rating
FROM   TABLE(item_list(TO_DATE('01-JAN-2000'))) item_list;

-- Close log file.
SPOOL OFF
