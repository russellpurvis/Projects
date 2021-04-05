/*
||  Name:          apply_plsql_lab4.sql
||  Date:          30 Jan 2021
||  Purpose:       Print out song lyrics.
*/

-- Call seeding libraries.
-- @$LIB/cleanup_oracle.sql
-- @$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab4.txt

SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  /* Create a single column collection that is a list strings
     less than 8 characters in length and another of strings
     less than 30 characters in length. */
  TYPE DAY   IS TABLE OF VARCHAR2(8);
  TYPE verse IS TABLE OF VARCHAR2(30);
 
  /* Create variables that use the user-defined types:*/
  lv_day   DAY   := DAY('first',
						            'second',
                        'third',
                        'fourth',
                        'fifth',
                        'sixth',
                        'seventh',
                        'eighth',
                        'ninth',
                        'tenth',
                        'eleventh',
                        'twelfth');
  lv_verse VERSE := verse(
						              'Partridge in a pear tree'
                        , 'Two Turtle doves'
                        , 'Three French hens'
                        , 'Four Calling birds'
                        , 'Five Golden rings'
                        , 'Six Geese a laying'
                        , 'Seven Swans a swimming'
                        , 'Eight Maids a milking'
                        , 'Nine Ladies dancing'
                        , 'Ten Lords a leaping'
                        , 'Eleven Pipers piping'
                        , 'Twelve Drummers drumming');
 
BEGIN

 
  FOR i IN 1..lv_day.LAST LOOP
 
    IF lv_day.EXISTS(i) THEN
 
      /* Print the beginning of the stanza. */
      dbms_output.put_line('On the '||lv_day(i)||' day of Christmas, my true love sent to me:');
 
      /* Print the song. */
      FOR j IN REVERSE 1..i LOOP
        /* Check if the day exists. */
        IF lv_verse.EXISTS(j) THEN
          /* All but first and last verses. */
          IF j > 1 THEN
            dbms_output.put_line('-   '||lv_verse(j)||'');
          /* The last verse. */
          ELSIF i = j THEN
            dbms_output.put_line('- A '||lv_verse(j)||''||CHR(10));
          /* Last verse. */
          ELSE
            dbms_output.put_line('-   and a '||lv_verse(j)||''||CHR(10));
          END IF;
        END IF;
      END LOOP;
    ELSE
      CONTINUE;
    END IF;
  END LOOP;
END;

/


-- Close log file.
SPOOL OFF
