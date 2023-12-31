CREATE TABLE classes (
	id BIGINT NOT NULL AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	PRIMARY KEY(id)
) ENGINE=INNODB DEFAULT CHARSET=utf8;



CREATE TABLE students (
    id BIGINT NOT NULL AUTO_INCREMENT,
    class_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    gender VARCHAR(1) NOT NULL,
    score INT NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO classes(id, name) VALUES (1, '一班');
INSERT INTO classes(id, name) VALUES (2, '二班');
INSERT INTO classes(id, name) VALUES (3, '三班');
INSERT INTO classes(id, name) VALUES (4, '四班');

INSERT INTO students (id, class_id, name, gender, score) VALUES (1, 1, '小明', 'M', 90);
INSERT INTO students (id, class_id, name, gender, score) VALUES (2, 1, '小红', 'F', 95);
INSERT INTO students (id, class_id, name, gender, score) VALUES (3, 1, '小军', 'M', 88);
INSERT INTO students (id, class_id, name, gender, score) VALUES (4, 1, '小米', 'F', 73);
INSERT INTO students (id, class_id, name, gender, score) VALUES (5, 2, '小白', 'F', 81);
INSERT INTO students (id, class_id, name, gender, score) VALUES (6, 2, '小兵', 'M', 55);
INSERT INTO students (id, class_id, name, gender, score) VALUES (7, 2, '小林', 'M', 85);
INSERT INTO students (id, class_id, name, gender, score) VALUES (8, 3, '小新', 'F', 91);
INSERT INTO students (id, class_id, name, gender, score) VALUES (9, 3, '小王', 'M', 89);
INSERT INTO students (id, class_id, name, gender, score) VALUES (10, 3, '小丽', 'F', 85);


SELECT * FROM students
SELECT * FROM classes

SELECT * FROM students WHERE score >= 80
SELECT * FROM students WHERE score >= 80 AND gender = 'M'
SELECT * FROM students WHERE score >= 80 OR gender = 'M'

-- NOT查询
SELECT * FROM students WHERE NOT class_id = 2

-- 按多个条件查询students:
SELECT * FROM students WHERE (score < 80 OR score > 90) AND gender='M'

-- 模糊查询
SELECT * FROM students WHERE name LIKE '%米'

-- 查询分数在60分(含)～90分(含)之间的学生
SELECT * FROM students WHERE score >= 60 AND score <= 90
SELECT * FROM students WHERE score BETWEEN 60 AND 90;

-- 查询分数在60分或者90分的学生
SELECT * FROM students  
WHERE score IN (60, 90);


-- 使用投影查询
SELECT id, score, name FROM students;

-- 将列名score重命名为points
SELECT id, score points, name FROM students WHERE gender = 'M';


-- 按score从低到高 ASC可省略
SELECT id, name, gender, score FROM students ORDER BY score ASC;


-- 倒序
SELECT id, name, gender, score FROM students ORDER BY score DESC

-- 先按score列倒序，如果有相同分数的，再按gender列排序
SELECT id, name, gender, score FROM students ORDER BY score DESC, gender

-- 带WHERE条件的ORDER BY:
SELECT id, name, gender, score
FROM students
WHERE class_id = 1
ORDER BY score DESC;

-- 第一页
SELECT id, name, gender, score
FROM students
ORDER BY score DESC
LIMIT 3 OFFSET 0;

-- 第二页 OFFSET = pageSize * (pageIndex - 1)
SELECT id, name, gender, score
FROM students
ORDER BY score DESC
LIMIT 3 OFFSET 3;

-- 聚合查询----------------------------------------------------
-- 使用聚合查询一共有多少条记录:
SELECT COUNT(*) FROM students;

-- 使用聚合查询并设置结果集的列名为num 筛选姓别为男生
SELECT COUNT(*) num FROM students  WHERE gender = 'M';

-- 使用聚合查询计算男生平均成绩
SELECT AVG(score) average FROM students WHERE gender = 'M';
-- SUM	计算某一列的合计值，该列必须为数值类型
-- AVG	计算某一列的平均值，该列必须为数值类型
-- MAX	计算某一列的最大值
-- MIN	计算某一列的最小值

-- 要特别注意：如果聚合查询的WHERE条件没有匹配到任何行，COUNT()会返回0，而SUM()、AVG()、MAX()和MIN()会返回NULL：
SELECT AVG(score) average FROM students WHERE gender = 'X';

-- 每页3条记录，如何通过聚合查询获得总页数？
SELECT CEILING(COUNT(*) / 3) totalPage FROM students;

-- 统计一班、二班、三班的学生数量“分组聚合”的功能
SELECT class_id, COUNT(*) num FROM students GROUP BY class_id;

-- 只有class_id都相同，name是不同的，SQL引擎不能把多个name的值放入一行记录中
SELECT name, class_id, COUNT(*) num FROM students GROUP BY class_id;

-- 各班的男生和女生人数
SELECT class_id, gender, COUNT(*) num FROM students GROUP BY class_id, gender;

-- 请使用一条SELECT查询查出每个班级的平均分
SELECT class_id, gender, AVG(score) FROM students GROUP BY class_id, gender;
SELECT class_id, gender, AVG(score) FROM students GROUP BY class_id, gender;

-- 选出所有的学生同时返回班级名称
SELECT 
	s.id, s.name, s.class_id, c.name class_name, s.gender, s.score 
FROM 
	students s 
INNER JOIN
	classes c 
ON 
	s.class_id = c.id
	
-- 右外连接 返回右表都存在的行
SELECT s.id, s.name, s.class_id, c.name class_name, s.gender, s.score
FROM students s
RIGHT OUTER JOIN classes c
ON s.class_id = c.id;

-- 左外连接 返回左表都存在的行
SELECT s.id, s.name, s.class_id, c.name class_name, s.gender, s.score
FROM students s
LEFT OUTER JOIN classes c
ON s.class_id = c.id

-- FULL OUTER JOIN，查询两张表的所有记录，并且把对方不存在的列填充为NULL mysql中没有FULL OUTER JOIN语法
SELECT s.id, s.name, s.class_id, c.name class_name, s.gender, s.score
FROM students s
FULL OUTER JOIN classes c
ON s.class_id = c.id;


-- ----------增删改查-----------------------

-- 插入 值的顺序必须和字段顺序一致
INSERT INTO students (class_id, name, gender, score)
VALUES (2, '大牛',  'M', 80)

-- 插入多条
INSERT INTO students (class_id, name, gender, score) VALUES
  (1, '大宝', 'M', 87),
  (2, '二宝', 'M', 81);
	
SELECT * FROM students;

-- --------更新------------
UPDATE students SET name='大牛', score=66 WHERE id=1
SELECT * FROM students;
-- 更新多条数据
UPDATE students SET name='小牛', score=77 WHERE id>=5 AND id<=7;
-- 所有80分以下的同学的成绩加10分：
UPDATE students SET score=score+10 WHERE score <= 80;
-- 如果WHERE条件没有匹配到任何记录，UPDATE语句不会报错
UPDATE students SET score=100 WHERE id=999;
-- 要特别小心的是，UPDATE语句可以没有WHERE条件 整个表的所有记录都会被更新
-- UPDATE students SET score=60;

-- 删除----------
DELETE FROM students WHERE id=1;
-- 删除id=5,6,7的记录
DELETE FROM students WHERE id>=5 AND id<=7;
-- 如果WHERE条件没有匹配到任何记录，DELETE语句不会报错
DELETE FROM students WHERE id=999;
-- 要特别小心的是，和UPDATE类似，不带WHERE条件的DELETE语句会删除整个表的数据 最好先select一下
-- DELETE FROM students;


-- ---------------管理-------------------
-- 列出所有的数据库 其中，information_schema、mysql、performance_schema和sys是系统库
SHOW DATABASES;

-- 创建一个数据库
CREATE DATABASE test1;
-- 删除一个数据库
DROP DATABASE test1;
-- 切换数据库
USE test
SELECT * FROM students

-- 列出当前数据库所有表
SHOW TABLEs
-- 查看一个表的结构
DESC students
-- 查看表的创建SQL语句：
SHOW CREATE TABLE students;
-- 创建表
CREATE TABLE students;
-- 删除表
DROP TABLE students;
-- 修改表 新增一列birth
ALTER TABLE students
ADD COLUMN birth VARCHAR(10) NOT NULL
-- 修改birth列，例如把列名改为birthday，类型改为VARCHAR(20)：
ALTER TABLE students CHANGE COLUMN birth birthday VARCHAR(20) NOT NULL
-- 删除列
ALTER TABLE students DROP COLUMN birthday


-- ------------实用SQL语句----------------
-- 插入一条新记录，但如果记录已经存在，就先删除原记录，再插入新记录 REPLACE
REPLACE INTO 
	students (id, class_id, name, gender, score) 
VALUES (1, 1, '小明', 'F', 99);

-- 插入一条新记录，但如果记录已经存在，就更新该记录 INSERT INTO ... ON DUPLICATE KEY UPDATE ...
INSERT INTO 
	students (id, class_id, name, gender, score)
VALUES
	(1, 1, '小明', 'F', 99)
ON DUPLICATE KEY UPDATE
	 name='小明', gender='F', score=99;
	 
-- 插入一条新记录，但如果记录已经存在，就啥事也不干直接忽略 INSERT IGNORE INTO ...
INSERT IGNORE INTO students
	(id, class_id, name, gender, score) 
VALUES
	(1, 1, '小明', 'F', 99);
	
-- 对一个表进行快照，即复制一份当前表的数据到一个新表，可以结合CREATE TABLE和SELECT：
CREATE TABLE 
	students_of_class1 
SELECT * FROM students
WHERE
	class_id=1;

-- 查询结果集需要写入到表中，可以结合INSERT和SELECT，将SELECT语句的结果集直接插入到指定表中
INSERT INTO 
	statistics (class_id, average) 
SELECT 
	class_id, AVG(score) 
FROM 
	students 
GROUP BY 
	class_id;
	
-- 强制使用指定索引 在查询的时候，数据库系统会自动分析查询语句，并选择一个最合适的索引。但是很多时候，数据库系统的查询优化器并不一定总是能使用最优索引。如果我们知道如何选择索引，可以使用FORCE INDEX强制查询使用指定的索引。例如：
SELECT * 
FROM
	students
FORCE INDEX
	(idx_class_id)
WHERE
	class_id = 1
ORDER BY id DESC;
