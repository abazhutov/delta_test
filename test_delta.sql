
select '1  �������� ������ ���������, � ������� ������� ���� ��������. ������� ��� ��������' from RDB$DATABASE;
select FULLNAME from CLIENTS where BDATE = current_date;

select '2  ��������� ���������� ���������, � ������� �� ������� ���� ��������' from RDB$DATABASE;
select count(*) as CNT_BDATE_IS_NULL 
from CLIENTS 
where BDATE is null;

select '3  ��������� ���������� ���������, � ������� �� ������� ���� ��������, �� ��������� WHERE' from RDB$DATABASE;
--1
select count(*) as CNT_BDATE_IS_NULL_1 
from CLIENTS 
group by BDATE 
having BDATE is null;
--2
select sum(iif(BDATE is null, 1, 0)) as CNT_BDATE_IS_NULL_2 
from CLIENTS;

select '4  ��������� ������ ������������ ���� �������� � ������� ���������' from RDB$DATABASE;
select max(BDATE) as SECOND_MAX_BDATE
from CLIENTS
where BDATE < (select max(BDATE) from CLIENTS);

select '5  ��������� ������ ������������ ���� �������� � ������� ���������, �� ��������� ���������� ������� (�� ������� �� ����� ���� ��������� � ���������� ����� ��������)' from RDB$DATABASE;
select first 1 skip 1 BDATE as MAX_SECOND_DATE from CLIENTS order by BDATE desc;

select '6  ��������� ������ ������������ ���� �������� � ������� ���������, �� ��������� ���������� ������� (�� ������� ����� ���� �������� � ���������� ����� ��������)' from RDB$DATABASE;
select first 1 skip 1 BDATE as MAX_SECOND_DATE 
from (
  select distinct BDATE 
  from CLIENTS 
  order by BDATE desc);

select '7  ������� ������ ������� ���������, ��� ������� ��� �� ������ �������' from RDB$DATABASE;
select * from CLIENTS C where not exists(select first 1 1 from TREAT T where T.PCODE = C.PCODE) 

select '8  ������� ������ ������� ���������, ��� ������� ���� ���� �� ���� �������' from RDB$DATABASE;
select * from CLIENTS C where exists(select first 1 1 from TREAT T where T.PCODE = C.PCODE) 

select '9  ������� ������ ������� �������, ��� ������� �����, ����������� �� ��������, (TREAT.AMOUNTCL) �������� ������������ � ������ ����� ��������' from RDB$DATABASE;
select * 
from TREAT T
join (
  select PCODE, max(AMOUNTCL) as MAX_AMOUNTCL 
  from TREAT group by PCODE) TMA
on T.PCODE = TMA.PCODE and T.AMOUNTCL = TMA.MAX_AMOUNTCL

select '10 ������� ������ ������ ������������� (���������� ��� � ���� ��������): ���, ���� ��������, ����������.' from RDB$DATABASE;

select FULLNAME, BDATE, count(*) as CNT
from CLIENTS
group by FULLNAME, BDATE
having count(*) > 1;

select '11 ������� ��������� ������: ��� �������, ���������� ������� �� �������, ���������� ������� �� �������, ��������� ������� ������ 10000.' from RDB$DATABASE;
select D.DNAME, count(*) as CNT_TREATS, sum(iif(T.AMOUNTCL > 10000.00, 1, 0)) as CNT_TREATS_10000  
from DOCTOR D 
join TREAT T on D.DCODE = T.DCODE
where T.TREATDATE = current_date
group by 1;

select '12 ������� ������ ������� ������������, ��� ������� ���� ����������� (CLHISTNUM.FDATE) �������� ������������ � ������ ������� ��������' from RDB$DATABASE;
select * 
from CLHISTNUM CL
join (
  select CL1.PCODE, max(coalesce(CL1.FDATE, '31.12.2999')) as MAX_FDATE 
  from CLHISTNUM CL1
  group by 1) S
on S.PCODE = CL.PCODE and CL.FDATE = S.MAX_FDATE;

select '13 ��� ���� ������ ������� ��������� ���������� ��������� ������� ��������� ��������� ����� (TREAT.AMOUNTCL) � 2019 ���� �� ��������� � 2018 ����. ������� ��� ������� � ��������� ����������' from RDB$DATABASE;

select 
  D.DNAME,
  abs(coalesce(avg(case when extract(year from TREATDATE) = 2019 then AMOUNTCL end), 0) -
    coalesce(avg(case when extract(year from TREATDATE) = 2018 then AMOUNTCL end), 0)
  ) as ABS_CHANGE
from DOCTOR D
left join TREAT T on D.DCODE = T.DCODE
group by D.DNAME;

select '14 ������� ������ ������������, ��� ������� ��������� �������� ������������ (CLHISTNUM.AMOUNTRUB) ������ �������� ��������� ���������� ��������� �� ����� ������������ ����� (TREAT.AMOUNTJP).'||ascii_char(13)
'������� ��� ��������, ����� �������� (JPAGREEMENT.AGNUM), ����� ������ (CLHISTNUM.NSP), ������ ������������ (CLHISTNUM.BDATE,FDATE)' from RDB$DATABASE;

input P_TEST_14.sql;
select * from P_TEST_14;

select '15 ���� � ��� ���� ���� ���������� ������� �������, �������� ��������, ����������, ������ � ������ ��������� ������ �� ��� ����������� github (��� ������) � ���������.' from RDB$DATABASE;


-- 1. ������ � ���������� ���� CLHISTNUM.AMOUNTRUE decimal(255)
-- 2. ������ � ���������� ���� JPAGREEMENT.JID integer(255)
-- 3. �������� ����� CLHISTNUM.BDATE �������������, ����� ���� ������ ������, �.�. ����� �� ���� � CLIENTS?
-- 4. ������ ����� � ��������� (�� �� ��) CLHISTNUM�>JPAGREEMENT�>JPERSONS, � �� � ��.���� (�� � 1) CLHISTNUM�>JPERSONS�>JPAGREEMENT? 
-- 4.1 ��� ���������� ����������� ������� �� �������������� �����?
-- 4.2 �� ��������������� ����� JPERSONS �� ������������ � �������� (��������)
-- 4.3 ��� ����� CLHISTNUM�>JPERSONS�>JPAGREEMENT � ������� ��������� ����� �������� ���� �������� � ���������� ����������� ������� ����� ��.���� �� ����� ������������
-- 5. ������ �������� ������ CLIENTS,JPERSONS �� � ������������ ����� (��������)?