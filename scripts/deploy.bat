rem установка кодировки WIN-1251
chcp 1251
mkdir ..\db\
del /q ..\db\*
rem создание БД
isql -input create.sql
rem применения скриптов таблиц и первичное их заполнение
isql -user 'SYSDBA' -password 'masterkey' '../db/insurance.fdb' -input tables.sql
rem применения скрипта процедуры
isql -user 'SYSDBA' -password 'masterkey' '../db/insurance.fdb' -input P_TEST_14.sql
rem разворачивание успешно завершено
rem ---------------------------------
rem вывод решения залдач 1-14
isql -user 'SYSDBA' -password 'masterkey' '../db/insurance.fdb' -input '../test_delta.sql'
rem 
pause