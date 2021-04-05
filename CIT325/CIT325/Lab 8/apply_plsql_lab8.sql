/*
||  Name:          apply_plsql_lab8.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 9 lab.
*/


@/home/student/Data/cit325/lab7/apply_plsql_lab7.sql

  CREATE OR REPLACE
	PACKAGE contact_package IS 

	
   PROCEDURE contact_insert
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
	, pv_user_id		 NUMBER);


PROCEDURE contact_insert
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
	, pv_user_name           VARCHAR2);
END contact_package;
/

CREATE OR REPLACE
	PACKAGE BODY contact_package IS 

/* List of private Functions.
||------------------------------
||	get_lookup_id
||	( pv_lookup_table   VARCHAR2
||	, pv_lookup_column  VARCHAR2
||	, pv_lookup_type    VARCHAR2 ) RETURN NUMBER IS
||
||	get_member_id
||	( pv_account_number  VARCHAR2 ) RETURN NUMBER IS
||	get_user_id
||	( pv_user_name  VARCHAR2 ) RETURN NUMBER IS
*/

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

	
  -- Verify whether or not a member_id value exists, and if it does exist
  -- it will return that value. If there member_id, the cursor will not
  -- return a value and will in due course return the default value of
  -- zero.
  -- -------------------------------------------------------------------
  
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
  
   FUNCTION get_user_id
  ( pv_user_name  VARCHAR2 ) RETURN NUMBER IS

    /* Local return variable. */
    lv_retval  NUMBER := 0;  -- Default value is 0.

    /* Use a cursor, which will not raise an exception at runtime. */
    CURSOR find_user_id
    ( cv_user_name  VARCHAR2 ) IS
      SELECT system_user_id
      FROM   system_user
      WHERE  system_user_name = cv_user_name;

  BEGIN

    /* Assign a value when a row exists. */
    FOR i IN find_user_id(pv_user_name) LOOP
      lv_retval := i.system_user_id;
    END LOOP;

    /* Return 0 when no row found and the ID # when row found. */
    RETURN lv_retval;
  END get_user_id;
  
   PROCEDURE contact_insert
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
	, pv_user_id		 NUMBER) IS

	/* local variables for who-audit. */
	 lv_created_by          NUMBER   := pv_user_id;
	 lv_creation_date       DATE     := SYSDATE;
	 lv_last_updated_by     NUMBER   := pv_user_id;
	 lv_last_update_date    DATE     := SYSDATE;

  -- Local variables, to leverage subquery assignments.
  lv_address_type        VARCHAR(30);
  lv_contact_type        VARCHAR(30);
  lv_credit_card_type    VARCHAR(30);
  lv_member_type         VARCHAR(30);
  lv_telephone_type      VARCHAR(30);
  
  -- Member table sequence value local variable.
  lv_member_id  NUMBER;

BEGIN
  -- Assign parameter values to local variables for nested assignments
  -- to DML subqueries.
  lv_address_type := get_lookup_id('ADDRESS','ADDRESS_TYPE',pv_address_type);
  lv_contact_type := get_lookup_id('CONTACT','CONTACT_TYPE',pv_contact_type);
  lv_credit_card_type := get_lookup_id('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type);
  lv_member_type := get_lookup_id('MEMBER','MEMBER_TYPE',pv_member_type);
  lv_telephone_type := get_lookup_id('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type);
  
  
  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  -- Open log file.
SPOOL apply_plsql_lab8.txt;

  
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
    ,lv_member_type
    , pv_account_number
    , pv_credit_card_number
    , lv_credit_card_type
    , lv_created_by
    , lv_creation_date
    , lv_last_updated_by
    , lv_last_update_date );

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
  , lv_contact_type
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );  

  INSERT INTO address
  ( address_id
  , contact_id
  , address_type
  , city
  , state_province
  , postal_code
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  , lv_address_type
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );  

  INSERT INTO street_address
   ( street_address_id
  , address_id
  , line_number
  , street_address
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( street_address_s1.NEXTVAL
  , address_s1.CURRVAL
  , 1
  , pv_street_address
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );  

  INSERT INTO telephone
  ( telephone_id
  , contact_id
  , address_id
  , telephone_type
  , country_code
  , area_code
  , telephone_number
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  , lv_telephone_type								  -- TELEPHONE_TYPE
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , lv_created_by                                     -- CREATED_BY
  , lv_creation_date                                  -- CREATION_DATE
  , lv_last_updated_by                                -- LAST_UPDATED_BY
  , lv_last_update_date);                             -- LAST_UPDATE_DATE

  COMMIT;
  EXCEPTION 
   WHEN OTHERS THEN
     ROLLBACK TO starting_point;
     RETURN;
END contact_insert; /* Version 1 */

SPOOL OFF;


PROCEDURE contact_insert
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
	, pv_user_name           VARCHAR2)	IS
  
  /* local variables for who-audit. */
	 lv_user_id          NUMBER	 := get_user_id(pv_user_name);

BEGIN

  contact_package.contact_insert(
      pv_member_type         => pv_member_type
    , pv_account_number      => pv_account_number
    , pv_credit_card_number  => pv_credit_card_number
    , pv_credit_card_type    => pv_credit_card_type
    , pv_first_name          => pv_first_name
    , pv_middle_name         => pv_middle_name
    , pv_last_name           => pv_last_name
    , pv_contact_type        => pv_contact_type
    , pv_address_type        => pv_address_type
    , pv_city                => pv_city 
    , pv_state_province      => pv_state_province
    , pv_postal_code         => pv_postal_code 
    , pv_street_address      => pv_street_address
    , pv_telephone_type      => pv_telephone_type 
    , pv_country_code        => pv_country_code 
    , pv_area_code           => pv_area_code
    , pv_telephone_number    => pv_telephone_number 
    , pv_user_id			 => lv_user_id );
    
EXCEPTION 
   WHEN OTHERS THEN
     ROLLBACK TO starting_point;
     RETURN;
END contact_insert; /* Version 2*/

FUNCTION contact_insert
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
	, pv_user_id             NUMBER)	RETURN NUMBER IS
  
  /* local variables for who-audit. */
	 lv_retval			 NUMBER	 := 0;
     
BEGIN

  contact_package.contact_insert(
      pv_member_type         => pv_member_type
    , pv_account_number      => pv_account_number
    , pv_credit_card_number  => pv_credit_card_number
    , pv_credit_card_type    => pv_credit_card_type
    , pv_first_name          => pv_first_name
    , pv_middle_name         => pv_middle_name
    , pv_last_name           => pv_last_name
    , pv_contact_type        => pv_contact_type
    , pv_address_type        => pv_address_type
    , pv_city                => pv_city 
    , pv_state_province      => pv_state_province
    , pv_postal_code         => pv_postal_code 
    , pv_street_address      => pv_street_address
    , pv_telephone_type      => pv_telephone_type 
    , pv_country_code        => pv_country_code 
    , pv_area_code           => pv_area_code
    , pv_telephone_number    => pv_telephone_number 
    , pv_user_id			 => pv_user_id );
    
    /* When you get here the program has run without error and
		you need to update your return variable to true. */
	lv_retval := 1;
    
	RETURN lv_retval;
EXCEPTION 
   WHEN OTHERS THEN
     ROLLBACK TO starting_point;
     RETURN lv_retval;
END contact_insert; /* Version 3*/

FUNCTION contact_insert
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
	, pv_user_name           VARCHAR2)	RETURN NUMBER IS
  
  /* local variables for who-audit. */
	 lv_retval			 NUMBER	 := 0;
     
BEGIN

  contact_package.contact_insert(
      pv_member_type         => pv_member_type
    , pv_account_number      => pv_account_number
    , pv_credit_card_number  => pv_credit_card_number
    , pv_credit_card_type    => pv_credit_card_type
    , pv_first_name          => pv_first_name
    , pv_middle_name         => pv_middle_name
    , pv_last_name           => pv_last_name
    , pv_contact_type        => pv_contact_type
    , pv_address_type        => pv_address_type
    , pv_city                => pv_city 
    , pv_state_province      => pv_state_province
    , pv_postal_code         => pv_postal_code 
    , pv_street_address      => pv_street_address
    , pv_telephone_type      => pv_telephone_type 
    , pv_country_code        => pv_country_code 
    , pv_area_code           => pv_area_code
    , pv_telephone_number    => pv_telephone_number 
    , pv_user_name			 => pv_user_name );
    
    /* When you get here the program has run without error and
		you need to update your return variable to true. */
	lv_retval := 1;
    
    RETURN lv_retval;
EXCEPTION 
   WHEN OTHERS THEN
     ROLLBACK TO starting_point;
     RETURN lv_retval;
END contact_insert; /* Version 4*/

END contact_package;
/

-- Open log file.
SPOOL apply_plsql_lab8.txt append;


   INSERT INTO system_user
        ( system_user_id
        , system_user_name 
        , system_user_group_id
        , system_user_type
        , first_name
        , middle_initial
        , last_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
        VALUES
        ( '6'
        , 'BONDSB'
        , '1'
        , 'DBA'
        , 'Barry'
        , 'L'
        , 'Bonds'
        , '1'
        , SYSDATE
        , '1'
        , SYSDATE);

        INSERT INTO system_user
        ( system_user_id
        , system_user_name 
        , system_user_group_id
        , system_user_type
        , first_name
        , middle_initial
        , last_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
        VALUES
        ( '7'
        , 'OWENSR'
        , '1'
        , 'DBA'
        , 'Wardell'
        , 'S'
        , 'Curry'
        , '1'
        , SYSDATE
        , '1'
        , SYSDATE);

        INSERT INTO system_user
        ( system_user_id
        , system_user_name 
        , system_user_group_id
        , system_user_type
        , first_name
        , middle_initial
        , last_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
        VALUES
        ( '-1'
        , 'ANONYMOUS'
        , '1'
        , 'DBA'
        , ''
        , ''
        , '1'
        , SYSDATE
        , '1'
        , SYSDATE);


COL system_user_id  FORMAT 9999  HEADING "System|User ID"
COL system_user_name FORMAT A12  HEADING "System|User Name"
COL first_name       FORMAT A10  HEADING "First|Name"
COL middle_initial   FORMAT A2   HEADING "MI"
COL last_name        FORMAT A10  HeADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      middle_initial
,      last_name
FROM   system_user
WHERE  last_name IN ('Bonds','Curry')
OR     system_user_name = 'ANONYMOUS';


/* Test cases. */
BEGIN
    contact_package.contact_insert
            ( pv_first_name => 'Charlie'
            , pv_middle_name => NULL
            , pv_last_name => 'Brown'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000011'
            , pv_member_type => 'GROUP'
            , pv_credit_card_number => '8888-6666-8888-4444'
            , pv_credit_card_type => 'VISA_CARD'
            , pv_city => 'Lehi'
            , pv_state_province => 'Utah'
            , pv_postal_code => '84043'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '877-4321'
            , pv_telephone_type => 'HOME'
            , pv_user_name => 'DBA 3' 
            , pv_user_id => '');

    contact_package.contact_insert
            ( pv_first_name => 'Peppermint'
            , pv_middle_name => NULL
            , pv_last_name => 'Patty'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000011'
            , pv_member_type => 'GROUP'
            , pv_credit_card_number => '8888-6666-8888-4444'
            , pv_credit_card_type => 'VISA_CARD'
            , pv_city => 'Lehi'
            , pv_state_province => 'Utah'
            , pv_postal_code => '84043'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '877-4321'
            , pv_telephone_type => 'HOME'
            , pv_user_name => '' 
            , pv_user_id => '' );
            
    contact_package.contact_insert
            ( pv_first_name => 'Sally'
            , pv_middle_name => NULL
            , pv_last_name => 'Brown'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000011'
            , pv_member_type => 'GROUP'
            , pv_credit_card_number => '8888-6666-8888-4444'
            , pv_credit_card_type => 'VISA_CARD'
            , pv_city => 'Lehi'
            , pv_state_province => 'Utah'
            , pv_postal_code => '84043'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '877-4321'
            , pv_telephone_type => 'HOME'
            , pv_user_name => 'DBA 3' 
            , pv_user_id => '6');
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
WHERE  c.last_name IN ('Brown','Patty');


BEGIN
 IF contact_package.contact_insert
            ( pv_first_name => 'Shirley'
            , pv_middle_name => ''
            , pv_last_name => 'Patridge'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000012'
            , pv_member_type => 'GROUP'
            , pv_credit_card_number => '8888-6666-8888-4444'
            , pv_credit_card_type => 'VISA_CARD'
            , pv_city => 'Lehi'
            , pv_state_province => 'Utah'
            , pv_postal_code => '84043'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '877-4321'
            , pv_telephone_type => 'HOME'
            , pv_user_name => 'DBA 3' 
            , pv_user_id => '') = 1 THEN
             dbms_output.put_line('Insert function succeeds.');
  END IF;
END;
/

BEGIN
 IF contact_package.contact_insert
            ( pv_first_name => 'Keith'
            , pv_middle_name => ''
            , pv_last_name => 'Patridge'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000012'
            , pv_member_type => 'GROUP'
            , pv_credit_card_number => '8888-6666-8888-4444'
            , pv_credit_card_type => 'VISA_CARD'
            , pv_city => 'Lehi'
            , pv_state_province => 'Utah'
            , pv_postal_code => '84043'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '877-4321'
            , pv_telephone_type => 'HOME'
            , pv_user_name => 'DBA 3' 
            , pv_user_id => '') = 1 THEN
             dbms_output.put_line('Insert function succeeds.');
  END IF;
END;
/

BEGIN
	IF contact_package.contact_insert
            ( pv_first_name => 'Laurie'
            , pv_middle_name => ''
            , pv_last_name => 'Patridge'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000012'
            , pv_member_type => 'GROUP'
            , pv_credit_card_number => '8888-6666-8888-4444'
            , pv_credit_card_type => 'VISA_CARD'
            , pv_city => 'Lehi'
            , pv_state_province => 'Utah'
            , pv_postal_code => '84043'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '877-4321'
            , pv_telephone_type => 'HOME'
            , pv_user_name => 'DBA 3' 
            , pv_user_id => '') = 1 THEN
             dbms_output.put_line('Insert function succeeds.');
  END IF;
END;
/

COL full_name      FORMAT A18   HEADING "Full Name"
COL created_by     FORMAT 9999  HEADING "System|User ID"
COL account_number FORMAT A12   HEADING "Account|Number"
COL address        FORMAT A16   HEADING "Address"
COL telephone      FORMAT A16   HEADING "Telephone"
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      c.created_by 
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';

-- Close log file.
SPOOL OFF
