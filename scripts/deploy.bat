rem ��������� ��������� WIN-1251
chcp 1251
mkdir ..\db\
del /q ..\db\*
rem �������� ��
isql -input create.sql
rem ���������� �������� ������ � ��������� �� ����������
isql -user 'SYSDBA' -password 'masterkey' '../db/insurance.fdb' -input tables.sql
rem ���������� ������� ���������
isql -user 'SYSDBA' -password 'masterkey' '../db/insurance.fdb' -input P_TEST_14.sql
rem �������������� ������� ���������
rem ---------------------------------
rem ����� ������� ������ 1-14
isql -user 'SYSDBA' -password 'masterkey' '../db/insurance.fdb' -input '../test_delta.sql'
rem 
pause