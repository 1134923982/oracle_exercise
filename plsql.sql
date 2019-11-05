--pl/sql编程语言
declare
  i number(2) := 10;
  s varchar2(10) := 'xiaoming';
  ena emp.ename%TYPE;--引用类型
  emprow emp%rowtype;--记录型变量
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
    dbms_output.put_line('未成年');
  elsif i<40 then
    dbms_output.put_line('中年人');
  else
    dbms_output.put_line('老年人');
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

--exit循环
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

--游标,可以存放多个对象，多个记录
--输出emp表中所有员工的姓名
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

--给指定部门员工涨工资
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

--存储过程：提前编译好的一段pl/sql放置在数据库中
--可以直接被调用，一般是固定步骤的业务
--给指定员工涨100块钱
create or replace procedure p1(eno emp.empno%type)
is

begin
  update emp set sal=sal+100 where empno=eno;
  commit;
end;

--测试p1
declare

begin
  p1(7788);
end;

select * from emp where empno=7788;

--function
--通过存储函数实现计算指定员工的年薪
--存储过程与函数参数不能带长度,存储函数的返回值类型必能带长度
create or replace function f_yearsal(eno emp.empno%type) return number
is
  s number(10);
begin
  select sal*12+nvl(comm,0) into s from emp where emp.empno=eno;
  return s;
end;

--test
--存储函数调用时返回值需要接收
declare
  s number(10);
begin
  s := f_yearsal(7788);
  dbms_output.put_line(s);
end;

--存储过程算年薪
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

--触发器,指定一个规则，在增删查改时，满足添加时自动调用
--语句级触发器
--行级触发器： 包含for each row为了使用：old :new对象

create or replace trigger t1
after insert
on person 
declare

begin
  dbms_output.put_line('一个新员工入职');
end;
insert into person values (1,'haha');
commit;
select * from person;

--行级触发器
--不能给员工降薪,raise_application_error()
create or replace trigger t2
before
update
on emp
for each row
declare

begin
  if :old.sal>:new.sal then
    raise_application_error(-20001,'不能给员工降薪');
  end if;
end;

update emp set sal=sal-1 where empno=7788;
commit;


--触发器实现主键自增
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
