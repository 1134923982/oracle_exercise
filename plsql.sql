--pl/sql�������
declare
  i number(2) := 10;
  s varchar2(10) := 'xiaoming';
  ena emp.ename%TYPE;--��������
  emprow emp%rowtype;--��¼�ͱ���
begin
  dbms_output.put_line('hello');
  dbms_output.put_line(s);
  select ename into ena from emp where empno = 7788;
  dbms_output.put_line(ena);
  select * into emprow from emp where empno = 7788;
  dbms_output.put_line(emprow.ename || 'work:' || emprow.job);
end;


--if
declare
  i number(3) := &ii;
begin
  if i<18 then
    dbms_output.put_line('δ����');
  elsif i<40 then
    dbms_output.put_line('������');
  else
    dbms_output.put_line('������');
  end if;
 
end;

--while
declare
  i number(2) := 1;
begin
  while i<11 loop
    dbms_output.put_line(i);
    i := i+1;
  end loop;
end;

--exitѭ��
declare
  i number(2) :=1;
begin
  loop
    exit when i>10;
    dbms_output.put_line(i);
    i := i+1;
  end loop;
end;

--for
declare

begin
  for i in 1..10 loop
    dbms_output.put_line(i);
  end loop;
end;

--�α�,���Դ�Ŷ�����󣬶����¼
--���emp��������Ա��������
declare
  cursor c1 is select * from emp;
  emprow emp%rowtype;
begin
  open c1;
       loop
         fetch c1 into emprow;
         exit when c1%notfound;
         dbms_output.put_line(emprow.ename); 
       end loop;
  close c1;
end;

--��ָ������Ա���ǹ���
declare
  cursor c2(eno emp.deptno%type)
  is select empno from emp where deptno = eno;
  en emp.empno%type;
begin
  open c2(10);
       loop
         fetch c2 into en;
         exit when c2%notfound;
         update emp set sal=sal+180 where empno=en;
         commit;
       end loop;
  close c2;
end;
select sal from emp where deptno=10;

--�洢���̣���ǰ����õ�һ��pl/sql���������ݿ���
--����ֱ�ӱ����ã�һ���ǹ̶������ҵ��
--��ָ��Ա����100��Ǯ
create or replace procedure p1(eno emp.empno%type)
is

begin
  update emp set sal=sal+100 where empno=eno;
  commit;
end;

--����p1
declare

begin
  p1(7788);
end;

select * from emp where empno=7788;

--function
--ͨ���洢����ʵ�ּ���ָ��Ա������н
--�洢�����뺯���������ܴ�����,�洢�����ķ���ֵ���ͱ��ܴ�����
create or replace function f_yearsal(eno emp.empno%type) return number
is
  s number(10);
begin
  select sal*12+nvl(comm,0) into s from emp where emp.empno=eno;
  return s;
end;

--test
--�洢��������ʱ����ֵ��Ҫ����
declare
  s number(10);
begin
  s := f_yearsal(7788);
  dbms_output.put_line(s);
end;

--�洢��������н
create or replace procedure p_yearsal(eno emp.empno%type, yearsal out number)
is
   s number(10);
   c emp.comm%type;
begin
  select sal*12,nvl(comm,0) into s,c from emp where empno=eno;
  yearsal := s+c;
end;

--test
declare
  yearsal1 number(10);
begin
  p_yearsal(7788, yearsal1);
  dbms_output.put_line(yearsal1);
end;

--������,ָ��һ����������ɾ���ʱ���������ʱ�Զ�����
--��伶������
--�м��������� ����for each rowΪ��ʹ�ã�old :new����

create or replace trigger t1
after insert
on person 
declare

begin
  dbms_output.put_line('һ����Ա����ְ');
end;
insert into person values (1,'haha');
commit;
select * from person;

--�м�������
--���ܸ�Ա����н,raise_application_error()
create or replace trigger t2
before
update
on emp
for each row
declare

begin
  if :old.sal>:new.sal then
    raise_application_error(-20001,'���ܸ�Ա����н');
  end if;
end;

update emp set sal=sal-1 where empno=7788;
commit;


--������ʵ����������
create or replace trigger auid
before 
insert
on person
for each row
declare

begin
  select s_person.nextval into :new.pid from dual;
end;

insert into person (pname) values ('a');
commit;

select *from person;
