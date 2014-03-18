SET ECHO OFF;
SET TERM OFF;
@ C:\Data\oracle\lab6\lab6.sql
SELECT COUNT(*) FROM(RENTAL_ITEM);
SELECT COUNT(*) FROM(RENTAL);
SET ECHO OFF;
SET TERM OFF;
@ C:\Data\oracle\lab7\Lab7Step1.sql
@ C:\Data\oracle\lab7\Lab7Step2.sql
@ C:\Data\oracle\lab7\Lab7Step3.sql
@ C:\Data\oracle\lab7\Lab7Step4.sql
@ C:\Data\oracle\lab7\Lab7Step5.sql
SET TERM ON;

@ C:\Data\oracle\lab7\Lab7Step6.sql

COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;