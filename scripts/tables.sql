--=============================================
create table CLIENTS(
  PCODE integer primary key,
  FULLNAME varchar(255),
  BDATE date);
COMMENT ON TABLE TREAT IS 'Пациенты';

insert into CLIENTS values(101, 'ИВАНОВ1 ИВАН1 ИВАНОВИЧ1', '01.01.2020');
insert into CLIENTS values(102, 'ИВАНОВ2 ИВАН2 ИВАНОВИЧ2', '01.01.2020');
insert into CLIENTS values(103, 'ИВАНОВ3 ИВАН3 ИВАНОВИЧ3', '03.03.2020');
insert into CLIENTS values(104, 'ИВАНОВ4 ИВАН4 ИВАНОВИЧ4', '03.03.2020');
insert into CLIENTS values(105, 'ИВАНОВ5 ИВАН5 ИВАНОВИЧ5', '05.05.2024');
insert into CLIENTS values(106, 'ИВАНОВ6 ИВАН6 ИВАНОВИЧ6', '06.06.2025');
insert into CLIENTS values(107, 'ИВАНОВ7 ИВАН7 ИВАНОВИЧ7', current_date);
insert into CLIENTS values(108, 'ИВАНОВ8 ИВАН8 ИВАНОВИЧ8', null);
insert into CLIENTS values(109, 'ИВАНОВ9 ИВАН9 ИВАНОВИЧ9', null);
insert into CLIENTS values(110, 'ИВАНОВ1 ИВАН1 ИВАНОВИЧ1', '01.01.2020');

commit;
--=============================================

create table DOCTOR(
  DCODE integer primary key,
  DNAME varchar(255)
);

comment on table DOCTOR is 'Доктора';

insert into DOCTOR values(1, '1_ДОТОР ДОКТОРОВИЧ ДОКТОРОВ');
insert into DOCTOR values(2, '2_ДОТОР ДОКТОРОВИЧ ДОКТОРОВ');
insert into DOCTOR values(9, '9_ДОТОР ДОКТОРОВИЧ ДОКТОРОВ');

commit;
--=============================================

create table JPAGREEMENT(
  AGRID integer primary key,
  AGNUM varchar(255),
  JID   integer not null
);

comment on table DOCTOR is 'Договоры со страховыми компаниями и организациями';

insert into JPAGREEMENT(AGRID,AGNUM,JID) values(1210, '182/0101-1', 1);
insert into JPAGREEMENT(AGRID,AGNUM,JID) values(1211, '182/0101-2', 1);
insert into JPAGREEMENT(AGRID,AGNUM,JID) values(1212, '182/0124-1', 1);
insert into JPAGREEMENT(AGRID,AGNUM,JID) values(1213, '213/0125-2', 2);

commit;
--=============================================

create table CLHISTNUM(
  HISTID integer primary key,
  PCODE integer not null,
  BDATE date not null,
  FDATE date,
  NSP varchar(255),
  AMOUNTRUB decimal,
  AGRID integer not null,
  constraint FK_CLHISTNUM_PCODE foreign key (PCODE) references CLIENTS(PCODE), 
  constraint FK_CLHISTNUM_AGRID foreign key (AGRID) references JPAGREEMENT(AGRID) 
);

comment on table CLHISTNUM is 'Страховые прикрепления';

insert into CLHISTNUM(HISTID, PCODE, BDATE, FDATE, NSP, AMOUNTRUB, AGRID)
values(10, 101, '01.01.2001', '01.01.2012', '8886643926043165', 1001.11, 1211);
insert into CLHISTNUM(HISTID, PCODE, BDATE, FDATE, NSP, AMOUNTRUB, AGRID)
values(11, 101, '01.06.2013', '01.01.2024', '8831242131511234', 1002.22, 1211);
insert into CLHISTNUM(HISTID, PCODE, BDATE, FDATE, NSP, AMOUNTRUB, AGRID)
values(12, 101, '02.01.2024', null, '5031242131511234', 1003.33, 1212);

insert into CLHISTNUM(HISTID, PCODE, BDATE, FDATE, NSP, AMOUNTRUB, AGRID)
values(13, 103, '01.01.2001', '01.01.2012', '5031243123123123', 1004.44, 1212);

insert into CLHISTNUM(HISTID, PCODE, BDATE, FDATE, NSP, AMOUNTRUB, AGRID)
values(14, 104, '01.06.2013', '01.01.2024', '8531243123123123', 1005.55, 1213);

insert into CLHISTNUM(HISTID, PCODE, BDATE, FDATE, NSP, AMOUNTRUB, AGRID)
values(15, 105, '02.01.2024', null, '8837821700910221', 1006.66, 1211);

commit;
--=============================================

create table TREAT(
  TREATCODE integer primary key,
  PCODE   integer not null,
  DCODE   integer not null,
  TREATDATE date,
  AMOUNTCL  decimal,
  AMOUNTJP  decimal,
  HISTID  integer,
  constraint FK_TREAT_PCODE foreign key (PCODE) references CLIENTS(PCODE),
  constraint FK_TREAT_DCODE foreign key (DCODE) references DOCTOR(DCODE),
  constraint FK_TREAT_HISTID foreign key (HISTID) references CLHISTNUM(HISTID)
);

COMMENT ON TABLE TREAT IS 'Приёмы';

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4001, 101, 1, '01.01.2024', 10000.01, 1000.01, 13);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4002, 101, 1, '02.01.2024', 16000.21, 1600.21, 13);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4019, 101, 1, '03.01.2024', 13000.14, 1300.14, 11);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4003, 109, 9, '03.01.2024', 81000.14, 8100.14, 12);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4004, 107, 2, current_date, 10000.14, 1000.14, 15);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4005, 103, 2, current_date, 9800.999, 980.999, 15);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4006, 103, 2, current_date, 9800.999, 980.999, 15);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4007, 107, 9, current_date, 11000.00, 1100.00, 15);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4008, 101, 1, '01.01.2019', 10000.01, 1000.01, 12);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4009, 101, 1, '02.01.2019', 16000.21, 1600.21, 12);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4010, 101, 1, '03.01.2019', 13000.14, 1300.14, 12);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4011, 109, 9, '03.01.2019', 81000.14, 8100.14, 15);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4012, 101, 1, '01.01.2018', 10000.01, 1000.01, 13);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4013, 101, 1, '02.01.2018', 16000.21, 1600.21, 13);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4014, 101, 1, '03.01.2018', 13000.14, 1300.14, 13);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4015, 109, 9, '03.01.2018', 81000.14, 8100.14, 14);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4016, 107, 2, '03.01.2018', 80000.14, 8000.14, 14);

insert into TREAT(TREATCODE, PCODE, DCODE, TREATDATE, AMOUNTCL, AMOUNTJP, HISTID) 
values(4017, 107, 2, '12.01.2018', 20000.14, 2000.14, 14);

commit;
--=============================================