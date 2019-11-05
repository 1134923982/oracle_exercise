--������ռ�
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

--���û���Ȩ
--oracle���ݿ��еĳ��ý�ɫ
--connect ���ӽ�ɫ��������ɫ
--resource �����߽�ɫ
-- dba ��������Ա��ɫ
--��c##user1����dba��ɫ
grant dba to c##user1;

--create table
create table person(
  pid number(20),
  pname varchar2(10)
);
--�޸�������
 alter table person modify gender char(1);
 --�޸�����
 alter table person rename column gender to sex;
 --ɾ����
 alter table person drop column sex;
 
 insert into person (pid, pname) values (1,'haha');
 commit;
 
 select * from person;
 update person set pname='xixi' where pid=1;
 commit;

--�������У�Ĭ�ϴ�1��ʼ�� ���в��������һ�ű�
--dual: ���ֻ��Ϊ�˲�ȫ�﷨�淶
create sequence s_person;
select s_person.nextval from dual;
select s_person.currval from dual;

 
 insert into person (pid, pname) values (s_person.nextval,'haha');
 commit;
 
 --scott�û��� ����tiger
 --����scott�û�
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
--��emp����Ա����������
select e.ename,
  case e.ename
    when 'SMITH' then '����'
      when 'ALLEN' then '����'
        else '����'
          end
from emp e;

--emp����Ա�����ʣ�����3000�߹��ʣ�����1500����3000�еȣ�����͹���

select e.ename, e.SAL,
  case
    when e.sal>3000 then '������'
      when e.sal>1500 then '�е�����'
        else '������'
          end
from emp e;

--oracleר���������ʽ
--oracle������������������ǵ����ţ��������Բ������ţ�����ֻ����˫����
select e.ename,
  decode(e.ename,
    'SMITH','����',
      'ALLEN', '����',
        '����') ������
from emp e;

select count(1)from emp;
select sum(sal)from emp;
select max(sal)from emp;
select min(sal)from emp;
select avg(sal)from emp;

--�����ѯ
--��ѯÿ�����ŵ�ƽ������
--�����ѯ�У�������group by�����ԭʼ�У����ܳ�����select����
--û�г�����group by������У�����select������֣�������ϾۺϺ���
select e.deptno, avg(e.sal)
from emp e
group by e.deptno;

--��ѯƽ�����ʸ���2000�Ĳ���
--select �ı���������where��ʹ��
select e.deptno, avg(e.sal) asal
from emp e
group by e.deptno having avg(e.sal)>2000;

--where���˷���ǰ�����ݣ�having���˷���������
select e.deptno,avg(e.sal)
from emp e
where e.sal>800 group by deptno;

select e.deptno,avg(e.sal)
from emp e
where e.sal>800 group by deptno having avg(sal)>2000;

--oracleר�������ӣ�+��ʾ���Ǹ���Ϊ��׼
select * from emp e, dept d
where e.deptno(+) = d.deptno;

--��ѯԱ��������Ա���쵼���� ������
--��ѯԱ������,Ա���������ƣ�Ա���쵼����,�쵼��������
select e.ename ename, m.ename mname, d.dname, d2.dname mgrName
from emp e, emp m, dept d, dept d2
where e.MGR = m.empno
and e.deptno=d.deptno
and m.deptno = d2.deptno;

select * from emp where sal =
(select sal from emp where ename = 'SCOTT');

select * from emp where sal in
(select sal from emp where deptno = 10);

--��ѯÿ��������͹��ʣ����Ա������������
select t.deptno, t.msal, e.ename, d.dname
from (select deptno, min(sal) msal from emp
group by deptno) t, emp e, dept d
where t.deptno = e.deptno and t.msal = e.sal
and e.deptno = d.deptno;

--oracle��ҳ
--���������Ӱ��rownum˳��
select rownum, e.* from emp e
order by e.sal desc;
--select ��������rownum
select rownum,t.* from (
select rownum, e.* from emp e
order by e.sal desc) t;

--emp���ʵ������У�ÿҳ5������
--rownum����д�ϴ���һ������
select * from (
select rownum rn,e.* from(
select * from emp e order by e.sal desc
) e where rownum<11)
tt where rn>5;
--��������
--������������������, ����������ԭʼֵ��ģ����ѯ�����к�������Ӱ�촥��
create index idx_ename on emp(ename);

--create��������
--��������������������ȼ������е�ԭʼֵ
create index idx_enamejoy on emp(ename, job);

create * from emp where ename='SCOTT' and job='xx'; --������������
create * from emp where ename='SCOTT' or job='xx';--����������
create * from emp where ename='SCOTT'; --������������