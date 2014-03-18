USE studentdb;


\. /home/student/data/mysql/lab6/lab6_mysql.sql

-- create table
SELECT 'TRANSACTION' AS "Drop Table";
DROP TABLE IF EXISTS transaction;

SELECT 'TRANSACTION' AS "Create Table";

CREATE TABLE transaction
( transaction_id                    INT UNSIGNED    PRIMARY KEY AUTO_INCREMENT
, transaction_account		         CHAR(15)        NOT NULL
, transaction_type			         INT UNSIGNED    NOT NULL
, transaction_date 		            DATE            NOT NULL
, transaction_amount  	            DOUBLE          NOT NULL
, rental_id				               INT UNSIGNED    NOT NULL
, payment_method_type	            INT UNSIGNED    NOT NULL
, payment_account_number            CHAR(19)		    NOT NULL
, created_by                        INT UNSIGNED    NOT NULL
, creation_date                     DATE            NOT NULL
, last_updated_by                   INT UNSIGNED    NOT NULL
, last_update_date                  DATE            NOT NULL     
, KEY fk_transaction_1 (transaction_type)
, CONSTRAINT fk_transaction_1       FOREIGN KEY(transaction_type) REFERENCES common_lookup (common_lookup_id)
, KEY fk_transaction_2 (rental_id)
, CONSTRAINT fk_transaction_2       FOREIGN KEY(rental_id) REFERENCES rental (rental_id)
, KEY fk_transaction_3 (payment_method_type)
, CONSTRAINT fk_transaction_3       FOREIGN KEY(payment_method_type) REFERENCES common_lookup (common_lookup_id)
, KEY fk_transaction_4 (created_by)
, CONSTRAINT fk_transaction_4       FOREIGN KEY(created_by) REFERENCES system_user (system_user_id)
, KEY fk_transaction_5 (last_updated_by)
, CONSTRAINT fk_transaction_5       FOREIGN KEY(last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE UNIQUE INDEX transaction_u1 ON transaction (rental_id, transaction_type, transaction_date, payment_method_type, payment_account); 

INSERT INTO common_lookup VALUES
( null,'CREDIT','Credit', 1001, UTC_DATE(), 1001, UTC_DATE(), 'TRANSACTION', 'TRANSACTION_TYPE', 'CR');

INSERT INTO common_lookup VALUES
( null,'DEBIT','Debit', 1001, UTC_DATE(), 1001, UTC_DATE(), 'TRANSACTION', 'TRANSACTION_TYPE', 'DR');

INSERT INTO common_lookup VALUES
( null,'DISCOVER_CARD','Discover Card', 1001, UTC_DATE(), 1001, UTC_DATE(), 'TRANSACTION', 'PAYMENT_METHOD_TYPE', NULL);

INSERT INTO common_lookup VALUES
( null,'VISA_CARD','Visa Card', 1001, UTC_DATE(), 1001, UTC_DATE(), 'TRANSACTION', 'PAYMENT_METHOD_TYPE', NULL);

INSERT INTO common_lookup VALUES
( null,'MASTER_CARD','Master Card', 1001, UTC_DATE(), 1001, UTC_DATE(), 'TRANSACTION', 'PAYMENT_METHOD_TYPE', NULL);

INSERT INTO common_lookup VALUES
( null,'CASH','Cash', 1001, UTC_DATE(), 1001, UTC_DATE(), 'TRANSACTION', 'PAYMENT_METHOD_TYPE', NULL);

INSERT INTO common_lookup VALUES
( null,'1-DAY RENTAL','1-Day Rental', 1001, UTC_DATE(), 1001, UTC_DATE(), 'RENTAL_ITEM', 'RENTAL_ITEM_TYPE', NULL);
                                                                          
INSERT INTO common_lookup VALUES                                          
( null,'3-DAY RENTAL','3-Day Rental', 1001, UTC_DATE(), 1001, UTC_DATE(), 'RENTAL_ITEM', 'RENTAL_ITEM_TYPE', NULL);
                                                                          
INSERT INTO common_lookup VALUES                                          
( null,'5-DAY RENTAL','5-Day Rental', 1001, UTC_DATE(), 1001, UTC_DATE(), 'RENTAL_ITEM', 'RENTAL_ITEM_TYPE', NULL);

-- step 3
SELECT 'AIRPORT' AS "Drop Table";
DROP TABLE IF EXISTS airport;

SELECT 'AIRPORT' AS "Create Table";

-- create airport table
CREATE TABLE airport
( airport_id                   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, airport_code                 CHAR(3)       NOT NULL
, airport_city                 CHAR(30)      NOT NULL     
, city             		       CHAR(30)      NOT NULL
, state_province               CHAR(30)      NOT NULL
, created_by                   INT UNSIGNED 
, creation_date                DATE 		   NOT NULL 
, last_updated_by              INT UNSIGNED
, last_update_date             DATE          NOT NULL
, KEY fk_airport_1 (created_by)
, CONSTRAINT fk_airport_1       FOREIGN KEY(created_by) REFERENCES system_user (system_user_id)
, KEY fk_airport_2 (last_updated_by)
, CONSTRAINT fk_airport_2       FOREIGN KEY(last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8;

-- account_list
SELECT 'ACCOUNT_LIST' AS "Drop Table";
DROP TABLE IF EXISTS account_list;

SELECT 'ACCOUNT_LIST' AS "Create Table";

-- create account_list table
CREATE TABLE account_list
( account_list_id              INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, account_number               CHAR(10)      NOT NULL
, consumed_date                DATE     
, consumed_by                  INT UNSIGNED  
, created_by                   INT UNSIGNED
, creation_date                DATE 		   NOT NULL 
, last_updated_by              INT UNSIGNED
, last_update_date             DATE          NOT NULL
, KEY fk_account_list_1 (consumed_by)
, CONSTRAINT fk_account_list_1       FOREIGN KEY(consumed_by) REFERENCES system_user (system_user_id)
, KEY fk_account_list_2 (created_by)
, CONSTRAINT fk_account_list_2       FOREIGN KEY(created_by) REFERENCES system_user (system_user_id)
, KEY fk_ccount_list_3 (last_updated_by)
, CONSTRAINT fk_account_list_3       FOREIGN KEY(last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8;

INSERT INTO airport VALUES
( null,'LAX','Los Angeles', 'Los Angeles', 'California', 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO airport VALUES
( null,'SLC','Salt Lake City', 'Provo', 'Utah', 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO airport VALUES
( null,'SLC','Salt Lake City', 'Spanish Fork', 'Utah', 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO airport VALUES
( null,'SFO','San Francisco', 'San Francisco', 'California', 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO airport VALUES
( null,'SJC','San Jose', 'San Jose', 'California', 1001, UTC_DATE(), 1001, UTC_DATE());

INSERT INTO airport VALUES
( null,'SJC','San Jose', 'San Carlos', 'California', 1001, UTC_DATE(), 1001, UTC_DATE());

UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';

UPDATE address
SET    state_province = 'Utah'
WHERE  state_province = 'UT';

UPDATE address
SET city = 'Provo'
WHERE city = 'Prov';

-- Conditionally drop the procedure.
SELECT 'DROP PROCEDURE seed_account_list' AS "Statement";
DROP PROCEDURE IF EXISTS seed_account_list;
 
-- Create procedure to insert automatic numbered rows.
SELECT 'CREATE PROCEDURE seed_account_list' AS "Statement";
 
-- Reset delimiter to write a procedure.
DELIMITER $$
 
CREATE PROCEDURE seed_account_list() MODIFIES SQL DATA
BEGIN
 
  /* Declare local variable for call parameters. */
  DECLARE lv_key CHAR(3);
 
  /* Declare local control loop variables. */
  DECLARE lv_key_min  INT DEFAULT 0;
  DECLARE lv_key_max  INT DEFAULT 50;
 
  /* Declare a local variable for a subsequent handler. */
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE fetched INT DEFAULT 0;
 
  /* Declare a SQL cursor fabricated from local variables. */  
  DECLARE parameter_cursor CURSOR FOR
    SELECT DISTINCT airport_code FROM airport;
 
  /* Declare a duplicate key handler */
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
 
  /* Declare a not found record handler to close a cursor loop. */
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
 
  /* Start transaction context. */
  START TRANSACTION;
 
  /* Set savepoint. */  
  SAVEPOINT all_or_none;
 
  /* Open a local cursor. */  
  OPEN parameter_cursor;
  cursor_parameter: LOOP
 
    FETCH parameter_cursor
    INTO  lv_key;
 
    /* Place the catch handler for no more rows found
       immediately after the fetch operation.          */
    IF fetched = 1 THEN LEAVE cursor_parameter; END IF;
 
    seed: WHILE (lv_key_min < lv_key_max) DO
      SET lv_key_min = lv_key_min + 1;
 
      INSERT INTO account_list
      VALUES
      ( NULL
      , CONCAT(lv_key,'-',LPAD(lv_key_min,6,'0'))
      , NULL
      , NULL
      , 2
      , UTC_DATE()
      , 2
      , UTC_DATE());
    END WHILE;
 
    /* Reset nested low range variable. */
    SET lv_key_min = 0;
 
  END LOOP cursor_parameter;
  CLOSE parameter_cursor;
 
    /* This acts as an exception handling block. */  
  IF duplicate_key = 1 THEN
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
 
  END IF;
 
  /* Commit the writes as a group. */
  COMMIT;
 
END;
$$
 
-- Reset delimiter to the default.
DELIMITER ;

CALL seed_account_list();

SELECT COUNT(*) AS "# Accounts"
FROM   account_list;

-- Conditionally drop the procedure.
SELECT 'DROP PROCEDURE update_member_account' AS "Statement";
DROP PROCEDURE IF EXISTS update_member_account;
 
-- Create procedure to insert automatic numbered rows.
SELECT 'CREATE PROCEDURE update_member_account' AS "Statement";
 
-- Reset delimiter to write a procedure.
DELIMITER $$
 
CREATE PROCEDURE update_member_account() MODIFIES SQL DATA
BEGIN
 
  /* Declare local variable for call parameters. */
  DECLARE lv_member_id      INT UNSIGNED;
  DECLARE lv_city           CHAR(30);
  DECLARE lv_state_province CHAR(30);
  DECLARE lv_account_number CHAR(10);
 
  /* Declare a local variable for a subsequent handler. */
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE fetched INT DEFAULT 0;
 
  /* Declare a SQL cursor fabricated from local variables. */  
  DECLARE member_cursor CURSOR FOR
    SELECT DISTINCT
           m.member_id
    ,      a.city
    ,      a.state_province
    FROM   member m INNER JOIN contact c
    ON     m.member_id = c.member_id INNER JOIN address a
    ON     c.contact_id = a.contact_id
    ORDER BY m.member_id;
 
  /* Declare a duplicate key handler */
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
 
  /* Declare a not found record handler to close a cursor loop. */
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
 
  /* Start transaction context. */
  START TRANSACTION;
 
  /* Set savepoint. */  
  SAVEPOINT all_or_none;
 
  /* Open a local cursor. */  
  OPEN member_cursor;
  cursor_member: LOOP
 
    FETCH member_cursor
    INTO  lv_member_id
    ,     lv_city
    ,     lv_state_province;
 
    /* Place the catch handler for no more rows found
       immediately after the fetch operation.          */
    IF fetched = 1 THEN LEAVE cursor_member; END IF;
 
      /* Secure a unique account number as they're consumed from the list. */
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTRING(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = lv_city
      AND    ap.state_province = lv_state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL LIMIT 1;
 
      /* Update a member with a unique account number linked to their nearest airport. */
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = lv_member_id;
 
      /* Mark consumed the last used account number. */      
      UPDATE account_list
      SET    consumed_by = 2
      ,      consumed_date = UTC_DATE()
      WHERE  account_number = lv_account_number;
 
  END LOOP cursor_member;
  CLOSE member_cursor;
 
    /* This acts as an exception handling block. */  
  IF duplicate_key = 1 THEN
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
 
  END IF;
 
  /* Commit the writes as a group. */
  COMMIT;
 
END;
$$
 
-- Reset delimiter to the default.
DELIMITER ;

SELECT 'CALL update_member_account' AS "Statement";
CALL update_member_account();

SELECT DISTINCT
       m.member_id
,      c.last_name
,      m.account_number
,      a.city
,      a.state_province
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id;

-- account_list
SELECT 'TRANSACTION_UPLOAD' AS "Drop Table";
DROP TABLE IF EXISTS transaction_upload;

SELECT 'TRANSACTION_UPLOAD' AS "Create Table";

CREATE TABLE transaction_upload
( account_number          CHAR(10)
, first_name              CHAR(20)
, middle_name             CHAR(20)
, last_name               CHAR(20)
, check_out_date          DATE
, return_date             DATE
, rental_item_type        CHAR(12)
, transaction_type        CHAR(14)
, transaction_amount      DOUBLE
, transaction_date        DATE
, item_id                 INT UNSIGNED
, payment_method_type     CHAR(14)
, payment_account_number  CHAR(19)
) ENGINE=MEMORY;

LOAD DATA LOCAL INFILE '/home/student/data/download/transaction_upload_mysql.csv'
INTO TABLE transaction_upload
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

UPDATE transaction_upload
SET    middle_name = NULL
WHERE  middle_name = '';

CREATE INDEX tu_rental USING BTREE
ON transaction_upload (account_number, first_name, last_name, check_out_date, return_date);
 
ALTER TABLE rental_item
ADD CONSTRAINT natural_key 
UNIQUE INDEX USING BTREE (rental_item_id, rental_id, item_id, rental_item_type, rental_item_price);

ALTER TABLE member
ADD CONSTRAINT member_u1
UNIQUE INDEX member_key USING BTREE (account_number, credit_card_number, credit_card_type, member_type);

SHOW INDEXES FROM common_lookup;

-- Conditionally drop the procedure.
SELECT 'UPLOAD_TRANSACTION' AS "Drop Procedure";
DROP PROCEDURE IF EXISTS upload_transaction;
 
-- Reset the execution delimiter to create a stored program.
DELIMITER $$
 
-- The parentheses after the procedure name must be there or the MODIFIES SQL DATA raises an compile time exception.
CREATE PROCEDURE upload_transaction() MODIFIES SQL DATA
 
BEGIN

  /* Declare a handler variables. */
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE foreign_key   INT DEFAULT 0;
 
  /* Declare a duplicate key handler */
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
  DECLARE CONTINUE HANDLER FOR 1216 SET foreign_key = 1;
 
  /* ---------------------------------------------------------------------- */
 
  /* Start transaction context. */
  START TRANSACTION;
 
  /* Set savepoint. */  
  SAVEPOINT both_or_none;
 
  /* Open a local cursor. */   
    REPLACE INTO rental
    (SELECT DISTINCT
                r.rental_id
              , c.contact_id
              , tu.check_out_date
              , tu.return_date
              , 3, UTC_DATE(), 3, UTC_DATE()
         FROM     member m INNER JOIN contact c
         ON       m.member_id = c.member_id 
         INNER JOIN transaction_upload tu
         ON       c.first_name = tu.first_name
         AND      IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
         AND      c.last_name = tu.last_name
         AND      m.account_number = tu.account_number 
         LEFT JOIN rental r
         ON       r.customer_id = c.contact_id
         AND      r.check_out_date = tu.check_out_date
         AND      r.return_date = tu.return_date);
         
  REPLACE INTO rental_item
  (SELECT      ri.rental_item_id
         ,        r.rental_id
         ,        tu.item_id
         ,        3 AS created_by
         ,        r.creation_date AS creation_date
         ,        3 AS last_updated_by
         ,        r.last_update_date AS last_update_date
         ,        cl.common_lookup_id AS rental_item_type
         ,        DATEDIFF(r.return_date, r.check_out_date) AS rental_item_price
         FROM     member m INNER JOIN contact c
         ON       m.member_id = c.member_id 
         INNER JOIN transaction_upload tu
         ON       c.first_name = tu.first_name
         AND      IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
         AND      c.last_name = tu.last_name
         AND      m.account_number = tu.account_number 
         LEFT JOIN rental r
         ON       r.customer_id = c.contact_id
         AND      r.check_out_date = tu.check_out_date
         AND      r.return_date = tu.return_date
         INNER JOIN common_lookup cl
         ON       cl.common_lookup_type = tu.rental_item_type
         AND      cl.common_lookup_table = 'RENTAL_ITEM'
         LEFT JOIN rental_item ri
         ON       ri.item_id = tu.item_id
         AND      ri.rental_id = r.rental_id);
         
         
         
  REPLACE INTO transaction
  (SELECT
                  t.transaction_id
         ,        tu.payment_account_number AS transaction_account
         ,        cl1.common_lookup_id AS transaction_type
         ,        tu.transaction_date AS transaction_date
         ,        SUM(tu.transaction_amount) AS transaction_amount
         ,        r.rental_id
         ,        cl2.common_lookup_id AS payment_method_type
         ,        m.credit_card_number AS payment_account_number
         ,        3 AS created_by
         ,        UTC_DATE() AS creation_date
         ,        3 AS last_updated_by
         ,        UTC_DATE() AS last_update_date
         FROM     member m INNER JOIN contact c
         ON       m.member_id = c.member_id 
         INNER JOIN transaction_upload tu
         ON       c.first_name = tu.first_name
         AND      IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
         AND      c.last_name = tu.last_name
         AND      m.account_number = tu.account_number 
         INNER JOIN rental r
         ON       r.customer_id = c.contact_id
         AND      r.check_out_date = tu.check_out_date
         AND      r.return_date = tu.return_date
         INNER JOIN common_lookup cl1
         ON      cl1.common_lookup_table = 'TRANSACTION'
         AND     cl1.common_lookup_column = 'TRANSACTION_TYPE'
         AND     cl1.common_lookup_type = tu.transaction_type
         INNER JOIN common_lookup cl2
         ON      cl2.common_lookup_table = 'TRANSACTION'
         AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
         AND     cl2.common_lookup_type = tu.payment_method_type
         LEFT JOIN transaction t
         ON  t.transaction_account    = tu.payment_account_number
         AND t.transaction_type		  = cl1.common_lookup_id		
         AND t.transaction_date 		  = tu.transaction_date
         AND t.rental_id				  = r.rental_id
         AND t.payment_method_type	  = cl2.common_lookup_id
         AND t.payment_account_number = m.credit_card_number
         GROUP BY t.transaction_id
         , tu.payment_account_number 
         , cl1.common_lookup_id
         , tu.transaction_date
         , r.rental_id
         , cl2.common_lookup_id
         , m.credit_card_number);
  /* ---------------------------------------------------------------------- */
 
  /* This acts as an exception handling block. */  
  IF duplicate_key = 1 OR foreign_key = 1 THEN
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT both_or_none;
 
  ELSE
 
    /* This commits the writes. */
    COMMIT;
 
  END IF;
 
END;
$$
 
-- Reset the delimiter to the default.
DELIMITER ;

CALL upload_transaction;
CALL upload_transaction;

SELECT DISTINCT
   DATE_FORMAT(transaction_date, '%b-%Y') AS "MONTH"
,  CONCAT('$', FORMAT(SUM(transaction_amount) , 2)) AS "BASE_REVENUE"
,  CONCAT('$', FORMAT(SUM(transaction_amount) * 1.1, 2)) AS "10_PLUS"
,  CONCAT('$', FORMAT(SUM(transaction_amount) * 1.2, 2)) AS "20_PLUS"
,  CONCAT('$', FORMAT(SUM(transaction_amount) * 0.1, 2)) AS "10_PLUS_LESS_B"
,  CONCAT('$', FORMAT(SUM(transaction_amount) * 0.2, 2)) AS "20_PLUS_LESS_B"
FROM transaction WHERE EXTRACT(YEAR FROM(transaction_date)) = '2009'
GROUP BY
   DATE_FORMAT(transaction_date, '%b-%Y')
ORDER BY CASE
   WHEN MONTH = 'JAN-2009' THEN 0
   WHEN MONTH = 'FEB-2009' THEN 1
   WHEN MONTH = 'MAR-2009' THEN 2
   WHEN MONTH = 'APR-2009' THEN 3
   WHEN MONTH = 'MAY-2009' THEN 4
   WHEN MONTH = 'JUN-2009' THEN 5
   WHEN MONTH = 'JUL-2009' THEN 6
   WHEN MONTH = 'AUG-2009' THEN 7
   WHEN MONTH = 'SEP-2009' THEN 8
   WHEN MONTH = 'OCT-2009' THEN 9
   WHEN MONTH = 'NOV-2009' THEN 10
   WHEN MONTH = 'DEC-2009' THEN 11
END;


NOTEE
