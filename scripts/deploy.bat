chcp 1251
rem del /q ..\db\*
isql -input create.sql
isql -user 'SYSDBA' -password 'masterkey' '../db/insurance.fdb' -input tables.sql
pause