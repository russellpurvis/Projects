/*
||  Name:          apply_plsql_lab7.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 8 lab.
*/

@@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab7.txt

-- Validating table state
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';

-- Ensures the itereative test cases all start at the same point
UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';


-- creates initial procedure to convert the insert_contact procedure to a function.
BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE contact_insert
( pv_member_type         VARCHAR2
, pv_account_number      VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_address_type        VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_street_address      VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_created_by          NUMBER   := 1
, pv_creation_date       DATE     := SYSDATE
, pv_last_updated_by     NUMBER   := 1
, pv_last_update_date    DATE     := SYSDATE) IS

  -- Local variables, to leverage subquery assignments in INSERT statements.
  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  
  -- Member table sequence value local variable.
  lv_member_id  NUMBER;

  -- Verify whether or not a member_id value exists, and if it does exist
  -- it will return that value. If there member_id, the cursor will not
  -- return a value and will in due course return the default value of
  -- zero.
  -- --------------------------------------------------------------------
  FUNCTION get_member_id
  ( pv_account_number  VARCHAR2 ) RETURN NUMBER IS

    /* Local return variable. */
    lv_retval  NUMBER := 0;  -- Default value is 0.

    /* Use a cursor, which will not raise an exception at runtime. */
    CURSOR find_member_id
    ( cv_account_number  VARCHAR2 ) IS
      SELECT member_id
      FROM   member
      WHERE  account_number = cv_account_number;

  BEGIN

    /* Assign a value when a row exists. */
    FOR i IN find_member_id(pv_account_number) LOOP
      lv_retval := i.member_id;
    END LOOP;

    /* Return 0 when no row found and the ID # when row found. */
    RETURN lv_retval;
  END get_member_id;

  FUNCTION get_lookup_id
  ( pv_lookup_table   VARCHAR2
  , pv_lookup_column  VARCHAR2
  , pv_lookup_type    VARCHAR2 ) RETURN NUMBER IS

    /* Return value. */
    retval  NUMBER := -1;

    /* Define a cursor. */
    CURSOR find_lookup_id
    ( cv_lookup_table   VARCHAR2
    , cv_lookup_column  VARCHAR2
    , cv_lookup_type    VARCHAR2 ) IS
      SELECT   common_lookup_id
      FROM     common_lookup
      WHERE    common_lookup_table = cv_lookup_table
      AND      common_lookup_column = cv_lookup_column
      AND      common_lookup_type = cv_lookup_type;

  BEGIN
    FOR i IN find_lookup_id( pv_lookup_table
                           , pv_lookup_column
                           , pv_lookup_type ) LOOP
      retval := i.common_lookup_id;
    END LOOP;

    RETURN retval;
  END get_lookup_id;

PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  -- Assign parameter values to local variables for nested assignments
  -- to DML subqueries.
  lv_address_type := pv_address_type;
  lv_contact_type := pv_contact_type;
  lv_credit_card_type := pv_credit_card_type;
  lv_member_type := pv_member_type;
  lv_telephone_type := pv_telephone_type;
  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  /* Check for existing grandma row. */
  lv_member_id := get_member_id(pv_account_number);
  IF lv_member_id = 0 THEN

    INSERT INTO member
    ( member_id
    , member_type
    , account_number
    , credit_card_number
    , credit_card_type
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date )
    VALUES
    ( member_s1.NEXTVAL
    ,(SELECT   common_lookup_id
      FROM     common_lookup
      WHERE    common_lookup_table = 'MEMBER'
      AND      common_lookup_column = 'MEMBER_TYPE'
      AND      common_lookup_type = lv_member_type)
    , pv_account_number
    , pv_credit_card_number
    ,(SELECT   common_lookup_id
      FROM     common_lookup
      WHERE    common_lookup_table = 'MEMBER'
      AND      common_lookup_column = 'CREDIT_CARD_TYPE'
      AND      common_lookup_type = lv_credit_card_type)
    , pv_created_by
    , pv_creation_date
    , pv_last_updated_by
    , pv_last_update_date );

    /* Assign member_s1.currval to local variable. */
    lv_member_id := member_s1.currval;

  END IF;

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , lv_member_id
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'CONTACT'
    AND      common_lookup_column = 'CONTACT_TYPE'
    AND      common_lookup_type = lv_contact_type)
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'ADDRESS'
    AND      common_lookup_column = 'ADDRESS_TYPE'
    AND      common_lookup_type = lv_address_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO street_address
  VALUES
  ( street_address_s1.NEXTVAL
  , address_s1.CURRVAL
  , 1
  , pv_street_address
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'TELEPHONE'
    AND      common_lookup_column = 'TELEPHONE_TYPE'
    AND      common_lookup_type = lv_telephone_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , pv_created_by                                     -- CREATED_BY
  , pv_creation_date                                  -- CREATION_DATE
  , pv_last_updated_by                                -- LAST_UPDATED_BY
  , pv_last_update_date);                             -- LAST_UPDATE_DATE

  COMMIT;
 EXCEPTION 
   WHEN OTHERS THEN
     ROLLBACK TO starting_point;
     RETURN;
END contact_insert;
/

-- Display any compilation errors.
SHOW ERRORS


-- Fixes the error of all starting at the same time 
DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;
 
  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;
 
  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);
 
BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;
 
    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/


-- verifies there are four rows
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';



/* Test cases. */
BEGIN
  
  contact_insert(
      pv_member_type         => 'INDIVIDUAL'
    , pv_account_number      => 'SLC-000008'
    , pv_credit_card_number  => '7777-6666-5555-4444'
    , pv_credit_card_type    => 'DISCOVER_CARD'
    , pv_first_name          => 'Charles'
    , pv_middle_name         => 'Francis'
    , pv_last_name           => 'Xavier'
    , pv_contact_type        => 'CUSTOMER'
    , pv_address_type        => 'HOME'
    , pv_city                => 'Milbridge'
    , pv_state_province      => 'Maine'
    , pv_postal_code         => '04658'
    , pv_street_address      => '1 Long Drive'
    , pv_telephone_type      => 'HOME'
    , pv_country_code        => '001'
    , pv_area_code           => '207'
    , pv_telephone_number    => '111-1234' );

END;
/

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Xavier';



/* Test cases. */
BEGIN
  
  contact_insert(
      pv_member_type         => 'INDIVIDUAL'
    , pv_account_number      => 'SLC-000009'
    , pv_credit_card_number  => '8888-7777-6666-5555'
    , pv_credit_card_type    => 'MASTER_CARD'
    , pv_first_name          => 'Maura'
    , pv_middle_name         => 'Jane'
    , pv_last_name           => 'Haggerty'
    , pv_contact_type        => 'CUSTOMER'
    , pv_address_type        => 'HOME'
    , pv_city                => 'Bangor'
    , pv_state_province      => 'Maine'
    , pv_postal_code         => '04401'
    , pv_street_address      => '1 Long Drive'
    , pv_telephone_type      => 'HOME'
    , pv_country_code        => '001'
    , pv_area_code           => '207'
    , pv_telephone_number    => '111-1234' );

END;
/

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Haggerty';


/* Test cases. */
BEGIN
  
  contact_insert(
      pv_member_type         => 'INDIVIDUAL'
    , pv_account_number      => 'SLC-000010'
    , pv_credit_card_number  => '9999-8888-7777-6666'
    , pv_credit_card_type    => 'VISA_CARD'
    , pv_first_name          => 'Harriet'
    , pv_middle_name         => 'Mary'
    , pv_last_name           => 'McDonnell'
    , pv_contact_type        => 'CUSTOMER'
    , pv_address_type        => 'HOME'
    , pv_city                => 'Orono'
    , pv_state_province      => 'Maine'
    , pv_postal_code         => '04469'
    , pv_street_address      => '1 Long Drive'
    , pv_telephone_type      => 'HOME'
    , pv_country_code        => '001'
    , pv_area_code           => '207'
    , pv_telephone_number    => '111-1234' );

END;
/

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'McDonnell';


SET PAGESIZE 999
COL full_name FORMAT A24
SELECT first_name || CASE
                       WHEN middle_name IS NOT NULL
                       THEN ' ' || middle_name || ' '
                       ELSE ' '
                     END || last_name AS full_name
FROM  contact;
SPOOL OFF;