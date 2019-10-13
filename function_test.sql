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

