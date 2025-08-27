
select '1  Отобрать список пациентов, у которых сегодня день рождения. Вывести ФИО пациента' from RDB$DATABASE;
select FULLNAME from CLIENTS where BDATE = current_date;

select '2  Вычислить количество пациентов, у которых не указана дата рождения' from RDB$DATABASE;
select count(*) as CNT_BDATE_IS_NULL 
from CLIENTS 
where BDATE is null;

select '3  Вычислить количество пациентов, у которых не указана дата рождения, не используя WHERE' from RDB$DATABASE;
--1
select count(*) as CNT_BDATE_IS_NULL_1 
from CLIENTS 
group by BDATE 
having BDATE is null;
--2
select sum(iif(BDATE is null, 1, 0)) as CNT_BDATE_IS_NULL_2 
from CLIENTS;

select '4  Вычислить вторую максимальную дату рождения в таблице пациентов' from RDB$DATABASE;
select max(BDATE) as SECOND_MAX_BDATE
from CLIENTS
where BDATE < (select max(BDATE) from CLIENTS);

select '5  Вычислить вторую максимальную дату рождения в таблице пациентов, не используя агрегатных функций (по условию не может быть пациентов с одинаковой датой рождения)' from RDB$DATABASE;
select first 1 skip 1 BDATE as MAX_SECOND_DATE from CLIENTS order by BDATE desc;

select '6  Вычислить вторую максимальную дату рождения в таблице пациентов, не используя агрегатных функций (по условию могут быть пациенты с одинаковой датой рождения)' from RDB$DATABASE;
select first 1 skip 1 BDATE as MAX_SECOND_DATE 
from (
  select distinct BDATE 
  from CLIENTS 
  order by BDATE desc);

select '7  Вывести строки таблицы пациентов, для которых нет ни одного лечения' from RDB$DATABASE;
select * from CLIENTS C where not exists(select first 1 1 from TREAT T where T.PCODE = C.PCODE) 

select '8  Вывести строки таблицы пациентов, для которых есть хотя бы одно лечение' from RDB$DATABASE;
select * from CLIENTS C where exists(select first 1 1 from TREAT T where T.PCODE = C.PCODE) 

select '9  Вывести строки таблицы лечений, для которых сумма, начисленная на пациента, (TREAT.AMOUNTCL) является максимальной в рамках этого пациента' from RDB$DATABASE;
select * 
from TREAT T
join (
  select PCODE, max(AMOUNTCL) as MAX_AMOUNTCL 
  from TREAT group by PCODE) TMA
on T.PCODE = TMA.PCODE and T.AMOUNTCL = TMA.MAX_AMOUNTCL

select '10 Вывести список полных однофамильцев (совпадение ФИО и даты рождения): ФИО, дата рождения, количество.' from RDB$DATABASE;

select FULLNAME, BDATE, count(*) as CNT
from CLIENTS
group by FULLNAME, BDATE
having count(*) > 1;

select '11 Вывести следующий список: ФИО доктора, количество лечений за сегодня, количество лечений за сегодня, стоимость которых больше 10000.' from RDB$DATABASE;
select D.DNAME, count(*) as CNT_TREATS, sum(iif(T.AMOUNTCL > 10000.00, 1, 0)) as CNT_TREATS_10000  
from DOCTOR D 
join TREAT T on D.DCODE = T.DCODE
where T.TREATDATE = current_date
group by 1;

select '12 Вывести строки таблицы прикреплений, для которых дата открепления (CLHISTNUM.FDATE) является максимальной в рамках каждого пациента' from RDB$DATABASE;
select * 
from CLHISTNUM CL
join (
  select CL1.PCODE, max(coalesce(CL1.FDATE, '31.12.2999')) as MAX_FDATE 
  from CLHISTNUM CL1
  group by 1) S
on S.PCODE = CL.PCODE and CL.FDATE = S.MAX_FDATE;

select '13 Для всех врачей клиники вычислить абсолютное изменение средней стоимости наличного приёма (TREAT.AMOUNTCL) в 2019 году по отношению к 2018 году. Вывести ФИО доктора и указанный показатель' from RDB$DATABASE;

select 
  D.DNAME,
  abs(coalesce(avg(case when extract(year from TREATDATE) = 2019 then AMOUNTCL end), 0) -
    coalesce(avg(case when extract(year from TREATDATE) = 2018 then AMOUNTCL end), 0)
  ) as ABS_CHANGE
from DOCTOR D
left join TREAT T on D.DCODE = T.DCODE
group by D.DNAME;

select '14 Вывести список прикреплений, для которых стоимость годового прикрепления (CLHISTNUM.AMOUNTRUB) меньше половины стоимости фактически оказанных по этому прикреплению услуг (TREAT.AMOUNTJP).'||ascii_char(13)
'Указать ФИО пациента, номер договора (JPAGREEMENT.AGNUM), номер полиса (CLHISTNUM.NSP), период прикрепления (CLHISTNUM.BDATE,FDATE)' from RDB$DATABASE;

input P_TEST_14.sql;
select * from P_TEST_14;

select '15 Если у вас есть опыт разработки сложных отчётов, хранимых процедур, интеграций, можете в ответе приложить ссылку на ваш репозиторий github (или другой) с примерами.' from RDB$DATABASE;


-- 1. ошибка в объявлении поля CLHISTNUM.AMOUNTRUE decimal(255)
-- 2. ошибка в объявлении поля JPAGREEMENT.JID integer(255)
-- 3. возможно стоит CLHISTNUM.BDATE переименовать, чтобы было меньше ошибок, т.к. такое же поле в CLIENTS?
-- 4. почему связи к договорам (мн ко мн) CLHISTNUM—>JPAGREEMENT—>JPERSONS, а не к юр.лицу (мн к 1) CLHISTNUM—>JPERSONS—>JPAGREEMENT? 
-- 4.1 Как определить действующий договор по представленной схеме?
-- 4.2 По предоставленной схеме JPERSONS не используется в запросах (выпадает)
-- 4.3 При схеме CLHISTNUM—>JPERSONS—>JPAGREEMENT в таблицу договором можно добавить даты действия и определять действующий договор через юр.лицо по датам прикрепления
-- 5. почему название таблиц CLIENTS,JPERSONS не в единственном числе (сущность)?