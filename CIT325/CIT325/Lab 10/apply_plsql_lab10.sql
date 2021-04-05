/*
||  Name:          apply_plsql_lab10.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 11 lab.
*/

-- Open log file.
SPOOL apply_plsql_lab10.txt

/* Unconditional drops of objects. */
DROP TABLE logger;
DROP SEQUENCE logger_s;
DROP TYPE item_t FORCE;
DROP TYPE contact_t FORCE;

-- Create or replace a generic object type.
CREATE OR REPLACE
  TYPE base_t IS OBJECT
  ( oname  VARCHAR2(30)
  , name   VARCHAR2(30)
  , CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT
  -- Default construction, can be removed from specification
  -- body because assignments are automatically managed by 
  -- the generic Oracle object type constructor, which uses
  -- the attribute list.
  , CONSTRUCTOR FUNCTION base_t
    ( oname  VARCHAR2
    , name   VARCHAR2) RETURN SELF AS RESULT
  , MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER FUNCTION get_oname RETURN VARCHAR2
  , MEMBER PROCEDURE set_oname (oname VARCHAR2)
  , MEMBER FUNCTION to_string RETURN VARCHAR2
  )
INSTANTIABLE NOT FINAL;
/

desc base_t

/* Create base_t object body. */
CREATE OR REPLACE
  TYPE BODY base_t IS

    /* Override constructor. */
    CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
     b BASE_T := base_t(oname => 'BASE_T'
                      ,name => 'Base_t');
    BEGIN
    self := b;
    RETURN;
  END base_t;
  
    /* Formalized default constructor. */
    CONSTRUCTOR FUNCTION base_t
    ( oname  VARCHAR2
    , name   VARCHAR2 ) RETURN SELF AS RESULT IS
     BEGIN
    self.oname := oname;
    self.name := name;
    RETURN;
  END base_t;

    /* A getter function to return the name attribute. */
    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN self.name;
    END get_name;

    /* A getter function to return the name attribute. */
    MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
    BEGIN
      RETURN self.oname;
    END get_oname;

    /* A setter procedure to set the oname attribute. */
    MEMBER PROCEDURE set_oname
    ( oname VARCHAR2 ) IS
    BEGIN
      self.oname := oname;
    END set_oname;

    /* A to_string function. */
    MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN '['||self.oname||']';
    END to_string;
  END;
/

  /* Create logger table. */
CREATE TABLE logger
( logger_id  NUMBER
, log_text   BASE_T);

/* Create logger_s sequence. */
CREATE SEQUENCE logger_s;


/* Describe logger table. */
DESC logger
  
/* Anonymous block tests object type. */
DECLARE
  /* Create a default instance of the object type. */
  lv_instance  BASE_T := base_t();
BEGIN
  /* Print the default value of the oname attribute. */
  dbms_output.put_line('Default  : ['||lv_instance.get_oname()||']');
 
  /* Set the oname value to a new value. */
  lv_instance.set_oname('SUBSTITUTE');
 
  /* Print the default value of the oname attribute. */
  dbms_output.put_line('Override : ['||lv_instance.get_oname()||']');
END;
/



INSERT INTO logger
VALUES (logger_s.NEXTVAL, base_t());

DECLARE
  /* Declare a variable of the UDT type. */
  lv_base  BASE_T;
BEGIN
  /* Assign an instance of the variable. */
  lv_base := base_t(
      oname => 'BASE_T'
    , name => 'NEW' );
 
    /* Insert instance of the base_t object type into table. */
    INSERT INTO logger
    VALUES (logger_s.NEXTVAL, lv_base);
 
    /* Commit the record. */
    COMMIT;
END;
/

COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      NVL(t.log.get_name(),'Unset') AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname = 'BASE_T';


-- Create my subtype under the base_t type.
CREATE OR REPLACE
	TYPE item_t UNDER base_t
    ( ITEM_ID				NUMBER
    , ITEM_BARCODE			VARCHAR2(20)
    , ITEM_TYPE				NUMBER
    , ITEM_TITLE			VARCHAR2(60)
    , ITEM_SUBTITLE			VARCHAR2(60)
    , ITEM_RATING			VARCHAR2(8)
    , ITEM_RATING_AGENCY	VARCHAR2(4)
    , ITEM_RELEASE_DATE		DATE
    , CREATED_BY			NUMBER
    , CREATION_DATE			DATE
    , LAST_UPDATED_BY		NUMBER
    , LAST_UPDATE_DATE		DATE
    , CONSTRUCTOR FUNCTION item_t
	  ( oname				VARCHAR2
      , name				VARCHAR2
      , ITEM_ID				NUMBER
	  , ITEM_BARCODE		VARCHAR2
      , ITEM_TYPE			NUMBER
      , ITEM_TITLE			VARCHAR2
      , ITEM_SUBTITLE		VARCHAR2
      , ITEM_RATING			VARCHAR2
      , ITEM_RATING_AGENCY	VARCHAR2
      , ITEM_RELEASE_DATE	DATE
      , CREATED_BY			NUMBER
      , CREATION_DATE		DATE
      , LAST_UPDATED_BY		NUMBER
      , LAST_UPDATE_DATE	DATE ) RETURN SELF AS RESULT
	, OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
    , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
    INSTANTIABLE NOT FINAL;
/

desc item_t


-- Create my subtype under the base_t type.
CREATE OR REPLACE
	TYPE BODY item_t IS
    
    /* Default constructor, implicitly available, but you should
		include it for those who forget that fact. */
	CONSTRUCTOR FUNCTION item_t
    ( oname				VARCHAR2
	, name				VARCHAR2
    , ITEM_ID				NUMBER
    , ITEM_BARCODE			VARCHAR2
    , ITEM_TYPE				NUMBER
    , ITEM_TITLE			VARCHAR2
    , ITEM_SUBTITLE			VARCHAR2
    , ITEM_RATING			VARCHAR2
    , ITEM_RATING_AGENCY	VARCHAR2
    , ITEM_RELEASE_DATE		DATE
    , CREATED_BY			NUMBER
    , CREATION_DATE			DATE
    , LAST_UPDATED_BY		NUMBER
    , LAST_UPDATE_DATE		DATE ) RETURN SELF AS RESULT IS
    BEGIN
		/* Assign inputs to instance variables */
        self.oname := oname;
        self.name := name;
        
        /* Assign a designated value or assign a null value */
        IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
			self.name := name;
		END IF;
        
        /* Assign inputs to instance variables. */
        self.item_id:= item_id;
        self.item_barcode := item_barcode;
        self.item_type := item_type;
        self.item_title := item_title;
        self.item_subtitle := item_subtitle;
        self.item_rating := item_rating;
        self.item_rating_agency := item_rating_agency;
        self.item_release_date := item_release_date;
        self.created_by := created_by;
        self.creation_date := creation_date;
        self.last_updated_by := last_updated_by;
        self.last_update_date := last_update_date;
        
        /* Return an instance of self. */
        RETURN;
	END;
    
	/* An overriding function for the generalization class. */
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
		RETURN (self AS base_t).get_name();
	END get_name;
    
    /* An overriding fuction for the generalization class. */
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
		RETURN (self AS base_t).to_string()||'.['||self.name||']';
	END to_string;
END;
/



CREATE OR REPLACE
	TYPE contact_t UNDER base_t
    ( CONTACT_ID			NUMBER
    , MEMBER_ID			    NUMBER
    , CONTACT_TYPE			NUMBER
    , FIRST_NAME			VARCHAR2(60)
    , MIDDLE_NAME		    VARCHAR2(60)
    , LAST_NAME			    VARCHAR2(8)
    , CREATED_BY			NUMBER
    , CREATION_DATE			DATE
    , LAST_UPDATED_BY		NUMBER
    , LAST_UPDATE_DATE		DATE
    , CONSTRUCTOR FUNCTION contact_t
	  ( oname				VARCHAR2
      , name				VARCHAR2
      , CONTACT_ID			NUMBER
	  , MEMBER_ID		    VARCHAR2
      , CONTACT_TYPE		NUMBER
      , FIRST_NAME			VARCHAR2
      , MIDDLE_NAME		    VARCHAR2
      , LAST_NAME			VARCHAR2
      , CREATED_BY			NUMBER
      , CREATION_DATE		DATE
      , LAST_UPDATED_BY		NUMBER
      , LAST_UPDATE_DATE	DATE ) RETURN SELF AS RESULT
	, OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
    , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
    INSTANTIABLE NOT FINAL;
/


CREATE OR REPLACE
	TYPE BODY contact_t IS
    
    /* Default constructor, implicitly available, but you should
		include it for those who forget that fact. */
	CONSTRUCTOR FUNCTION contact_t
    ( oname				VARCHAR2
      , name				VARCHAR2
      , CONTACT_ID			NUMBER
	  , MEMBER_ID		    VARCHAR2
      , CONTACT_TYPE		NUMBER
      , FIRST_NAME			VARCHAR2
      , MIDDLE_NAME		    VARCHAR2
      , LAST_NAME			VARCHAR2
      , CREATED_BY			NUMBER
      , CREATION_DATE		DATE
      , LAST_UPDATED_BY		NUMBER
      , LAST_UPDATE_DATE	DATE ) RETURN SELF AS RESULT IS
    BEGIN
		/* Assign inputs to instance variables */
        self.oname := oname;
        self.name := name;
        
        /* Assign a designated value or assign a null value */
        IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
			self.name := name;
		END IF;
        
        /* Assign inputs to instance variables. */
        self.contact_id:= contact_id;
        self.member_id := member_id;
        self.contact_type := contact_type;
        self.first_name := first_name;
        self.middle_name := middle_name;
        self.last_name := last_name;
        self.created_by := created_by;
        self.creation_date := creation_date;
        self.last_updated_by := last_updated_by;
        self.last_update_date := last_update_date;
        
        /* Return an instance of self. */
        RETURN;
	END;
    
	/* An overriding function for the generalization class. */
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
		RETURN (self AS base_t).get_name();
	END get_name;
    
    /* An overriding fuction for the generalization class. */
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
		RETURN (self AS base_t).to_string()||'.['||self.name||']';
	END to_string;
END;
/

DESC contact_t

INSERT INTO logger
VALUES
( logger_s.NEXTVAL
, item_t(
    oname => 'ITEM_T'
  , name => 'NEW'));
  
  INSERT INTO logger
VALUES
( logger_s.NEXTVAL
, contact_t(
    oname => 'CONTACT_T'
  , name => 'NEW'));
    
  
  
  
  COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      t.log.get_name() AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname IN ('CONTACT_T','ITEM_T');

-- Close log file.
SPOOL OFF
