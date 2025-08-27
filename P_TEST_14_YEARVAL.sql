--14 ¬ывести список прикреплений, дл€ которых стоимость годового прикреплени€ (CLHISTNUM.AMOUNTRUB) меньше половины стоимости фактически оказанных по этому прикреплению услуг (TREAT.AMOUNTJP).
--”казать ‘»ќ пациента, номер договора (JPAGREEMENT.AGNUM), номер полиса (CLHISTNUM.NSP), период прикреплени€ (CLHISTNUM.BDATE,FDATE)
set term ~;
create or alter procedure P_TEST_14_YEARVAL (YEARVAL int)
returns(
  FULLNAME type of column CLIENTS.FULLNAME,
  AGNUM    type of column JPAGREEMENT.AGNUM,
  NSP      type of column CLHISTNUM.NSP,
  BDATE    type of column CLHISTNUM.BDATE,
  FDATE    type of column CLHISTNUM.FDATE
)
as
begin
  -- select 
  --   extract(year from min(BDATE)), 
  --   extract(year from max(coalesce(FDATE, current_date)))
  -- from CLHISTNUM
  -- into :MIN_YEAR, :MAX_YEAR;

  -- lYEAR = :MIN_YEAR;
  -- while(:lYEAR <= :MAX_YEAR) do
  -- begin
    for 
      select C.FULLNAME, J.AGNUM, CLHN.NSP, CLHN.BDATE, CLHN.FDATE
      from CLHISTNUM CLHN
      join JPAGREEMENT J on J.AGRID = CLHN.AGRID
      join TREAT T on T.HISTID = CLHN.HISTID
      join CLIENTS C on CLHN.PCODE = C.PCODE 
      where (:YEARVAL between extract(year from CLHN.BDATE) 
          and extract(year from coalesce(CLHN.FDATE, current_date))
        )
      group by 1,2,3,4,5
      having sum(CLHN.AMOUNTRUB) < sum(T.AMOUNTJP)/2
      into :FULLNAME, :AGNUM, :NSP, :BDATE, :FDATE
    do
      suspend;

    -- lYEAR = :lYEAR + 1;
  -- end
end
~
set term ;~