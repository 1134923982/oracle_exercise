--https://blog.csdn.net/u013816709/article/details/82022244


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

select count(1)from emp;
select sum(sal)from emp;
select max(sal)from emp;
select min(sal)from emp;
select avg(sal)from emp;

--分组查询
--查询每个部门的平均工资
--分组查询中，出现在group by后面的原始列，才能出现在select后面
--没有出现在group by后面的列，想在select后面出现，必须加上聚合函数
select e.deptno, avg(e.sal)
from emp e
group by e.deptno;

--查询平均工资高于2000的部门
--select 的别名不能在where中使用
select e.deptno, avg(e.sal) asal
from emp e
group by e.deptno having avg(e.sal)>2000;

--where过滤分组前的数据，having过滤分组后的数据
select e.deptno,avg(e.sal)
from emp e
where e.sal>800 group by deptno;

select e.deptno,avg(e.sal)
from emp e
where e.sal>800 group by deptno having avg(sal)>2000;

--oracle专用外连接，+表示以那个表为基准
select * from emp e, dept d
where e.deptno(+) = d.deptno;

--查询员工姓名，员工领导姓名 自连接
--查询员工姓名,员工部门名称，员工领导姓名,领导部门名称
select e.ename ename, m.ename mname, d.dname, d2.dname mgrName
from emp e, emp m, dept d, dept d2
where e.MGR = m.empno
and e.deptno=d.deptno
and m.deptno = d2.deptno;

select * from emp where sal =
(select sal from emp where ename = 'SCOTT');

select * from emp where sal in
(select sal from emp where deptno = 10);

--查询每个部门最低工资，最低员工姓名，部门
select t.deptno, t.msal, e.ename, d.dname
from (select deptno, min(sal) msal from emp
group by deptno) t, emp e, dept d
where t.deptno = e.deptno and t.msal = e.sal
and e.deptno = d.deptno;

--oracle分页
--排序操作会影响rownum顺序
select rownum, e.* from emp e
order by e.sal desc;
--select 可以生成rownum
select rownum,t.* from (
select rownum, e.* from emp e
order by e.sal desc) t;

--emp表工资倒叙排列，每页5条数据
--rownum不能写上大于一个正数
select * from (
select rownum rn,e.* from(
select * from emp e order by e.sal desc
) e where rownum<11)
tt where rn>5;
--创建索引
--单列索引，触发条件, 必须是数据原始值，模糊查询，单行函数都会影响触发
create index idx_ename on emp(ename);

--create复合索引
--触发条件，必须包含优先检索列中的原始值
create index idx_enamejoy on emp(ename, job);

create * from emp where ename='SCOTT' and job='xx'; --触发复合索引
create * from emp where ename='SCOTT' or job='xx';--不触发索引
create * from emp where ename='SCOTT'; --触发单列索引

--instr('目标字符串'，匹配的字符)，返回匹配字符的下标
select SUBSTR('jayden zhang',INSTR('jayden zhang', ' ')+1,1) value from dual;
