--创建表空间
create tablespace tablespace1
datafile 'D:\app\yu\tablespace1.dbf'
size 100m
autoextend on
next 10m;

--delete tablespace
--drop tablespace tablespace1;

--create user
create user c##user1
identified by 123456
default tablespace tablespace1;

--给用户授权
--oracle数据库中的常用角色
--connect 连接角色，基本角色
--resource 开发者角色
-- dba 超级管理员角色
--给c##user1授予dba角色
grant dba to c##user1;

--create table
create table person(
  pid number(20),
  pname varchar2(10)
);
--修改列类型
 alter table person modify gender char(1);
 --修改列名
 alter table person rename column gender to sex;
 --删除列
 alter table person drop column sex;
 
 insert into person (pid, pname) values (1,'haha');
 commit;
 
 select * from person;
 update person set pname='xixi' where pid=1;
 commit;

--创建序列，默认从1开始， 序列不真的属于一张表
--dual: 虚表，只是为了补全语法规范
create sequence s_person;
select s_person.nextval from dual;
select s_person.currval from dual;

 
 insert into person (pid, pname) values (s_person.nextval,'haha');
 commit;
 
 --scott用户， 密码tiger
 --解锁scott用户
 alter user scott account unlock;
 
 select con_id, dbid, guid, name , open_mode from v$pdbs;
 
 alter session set container = ORCLPDB;
 
 alter user scott account unlock;

select months_between(sysdate, sysdate-100) from dual;
select months_between(sysdate, sysdate-100)/12 from dual;

select to_char(sysdate, 'yyyy-mm-dd hh:mi:ss') from dual;

select to_char(sysdate, 'fm yyyy-mm-dd hh:mi:ss') from dual;

select to_char(sysdate, 'fm yyyy-mm-dd hh24:mi:ss') from dual;

select to_date('2019-10-13 14:37:', 'fm yyyy-mm-dd hh24:mi:ss') from dual;
--给emp表中员工起中文名
select e.ename,
  case e.ename
    when 'SMITH' then '曹贼'
      when 'ALLEN' then '大猪'
        else '无名'
          end
from emp e;

--emp表中员工工资，高于3000高工资，高于1500低于3000中等，其余低工资

select e.ename, e.SAL,
  case
    when e.sal>3000 then '高收入'
      when e.sal>1500 then '中等收入'
        else '低收入'
          end
from emp e;

--oracle专用条件表达式
--oracle除了起别名，其他都是单引号，别名可以不加引号，用了只能用双引号
select e.ename,
  decode(e.ename,
    'SMITH','曹贼',
      'ALLEN', '大猪',
        '无名') 中文名
from emp e;

