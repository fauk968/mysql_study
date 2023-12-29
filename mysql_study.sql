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