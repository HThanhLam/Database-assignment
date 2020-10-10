use Testing_system_1;


/*Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các
account thuộc phòng ban đó
các department có: Marketing,DEV,ENGI,TRANSL,PM,sale*/
DELIMITER $$
CREATE PROCEDURE  print_account_dep (IN ten_department VARCHAR(30)) 
BEGIN
	
	SELECT a.*
    FROM Account as a
    INNER JOIN (SELECT *
				FROM Department 
                WHERE ten_department=DepartmentName) as b
	ON a.departmentID=b.departmentID;
END;
$$
DELIMITER ;
CALL print_account_dep('DEV');

/*Question 2: Tạo store để in ra số lượng account trong mỗi group*/
DELIMITER $$
CREATE PROCEDURE Account_inside_group ()
BEGIN 
	SELECT gp.GroupID,GroupName,count(AccountID)
	FROM GroupAccount gp
	INNER JOIN groupp gg ON gg.GroupID=gp.GroupID
	GROUP BY gp.GroupID;

END;
$$ 
DELIMITER 
CALL Account_inside_group;
/*Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo
trong tháng hiện tại*/
DELIMITER $$
CREATE PROCEDURE Question_By_Type ()
BEGIN
	SELECT qu.TypeID,TypeName,COUNT(QuestionID)
    FROM Question qu
    INNER JOIN TypeQuestion tq ON tq.TypeID=qu.TypeID
    GROUP BY qu.TypeID;
    
END;$$
DELIMITER ;
CALL Question_By_Type;
/*Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất*/
DELIMITER $$
CREATE PROCEDURE MAX_Type_Question (OUT ID int(8))
BEGIN
	
    
(SELECT TypeID INTO ID
					FROM (SELECT a.TypeID,COUNT(QuestionID)
							FROM Question a
							GROUP BY a.TypeID
							HAVING COUNT(QuestionID)=(SELECT MAX(my_count)
									FROM ( SELECT TypeID,COUNT(QuestionID) as my_count
										FROM	Question 
										GROUP BY TypeID)b))c);
END;
$$
DELIMITER ;
CALL MAX_Type_Question (@ID);
SELECT (@ID);
/*Question 5: Sử dụng store ở question 4 để tìm ra tên của type question*/

    
    SELECT tq.TypeName
    FROM TypeQuestion tq
	INNER JOIN (SELECT (@ID)) b ON tq.TypeID=(@ID);
    
/*Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa
chuỗi của người dùng nhập vào*/
DELIMITER $$
CREATE PROCEDURE NAME_GROUP_OR_USERNAME (IN WORD varchar(30))

BEGIN 
	SELECT a.*,gg.* FROM Account a
    INNER JOIN GroupAccount gp on gp.AccountID=a.AccountID
    INNER JOIN groupp gg ON gg.GroupID=gp.GroupID
    WHERE GroupName=WORD or UserName=WORD;

END;
$$
DELIMITER ;
DROP PROCEDURE NAME_GROUP_OR_USERNAME;
CALL NAME_GROUP_OR_USERNAME ('svgg') ;
/*Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và
trong store sẽ tự động gán:

username sẽ giống email nhưng bỏ phần @..mail đi
positionID: sẽ có default là developer
departmentID: sẽ được cho vào 1 phòng chờ

Sau đó in ra kết quả tạo thành công*/
DELIMITER //
CREATE PROCEDURE INSERT_INFO (IN NAME varchar(30),IN mail varchar(40))
BEGIN
	INSERT INTO Account(Email,UserName,FuLLName,DepartmentID,PositionID,CreateDate)
    Values (mail,SUBSTR(mail,1,locate('@',mail)-1),NAME,1,1,current_date());
    SELECT 'them thanh cong';
END;
//
DELIMITER ;
DROP PROCEDURE INSERT_INFO;
CALL INSERT_INFO ('NgoDaiVi','ngodaivi@gmail.com');
/*Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice
để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất*/
DELIMITER //
CREATE PROCEDURE LONGEST_QUESTION (IN Type_name varchar(30))
BEGIN 
	SELECT * FROM Question q
    INNER JOIN TypeQuestion tq ON tq.TypeID=q.TypeID AND TypeName=Type_name
    HAVING max(char_length(content));
END;
//
DELIMITER ;
CALL LONGEST_QUESTION('Essay');

/*Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID*/
DELIMITER //
CREATE PROCEDURE DEL_EXAM (IN DEL_ID INT(8))
BEGIN 
	DELETE FROM Exam
    WHERE ExamID=DEL_ID;

END;
//
DELIMITER ;
CALL DEL_EXAM(1);
/*Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử
dụng store ở câu 9 để xóa)
Sau đó in số lượng record đã remove từ các table liên quan trong khi
removing*/
DELIMITER //
CREATE PROCEDURE DEL_OUTDATED_EXAM ( )
BEGIN 
	DECLARE ALPHA INT(8);
	DECLARE Count TINYINT;
    SET Count=1;
    WHILE  (SELECT ExamID 
				FROM Exam
				WHERE (YEAR(current_date())-YEAR(CreateDate))>3
                LIMIT 1) IS NOT NULL DO
	SET ALPHA =(SELECT ExamID 
				FROM Exam
				WHERE (YEAR(current_date())-YEAR(CreateDate))>3
                LIMIT 1);
			DELETE FROM ExamQuestion WHERE ExamID=ALPHA;
			CALL DEL_EXAM(ALPHA);            
             SET Count=+1; 
				END WHILE;
			SELECT Count;
END;
//
DELIMITER ;
CALL DEL_OUTDATED_EXAM();
SELECT * FROM Exam;
INSERT INTO Exam  (Code,Title,CatagoryID,Duration,CreatorID,CreateDate) VALUES	(123,'easy exam',1,60,2000,'2000/10/02'),
                                                                                (123,'dev exam',5,220,2000,'2010/10/02');
/*Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng
nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được
chuyển về phòng ban default là phòng ban chờ việc*/
INSERT INTO Department(DepartmentName) VALUES ('Phong ban cho viec');
DELIMITER //
CREATE PROCEDURE DEL_DEPARTMENT (IN DEP_NAME VARCHAR(30))
BEGIN

UPDATE Account a2
INNER JOIN
		(SELECT AccountID FROM Account a
        INNER JOIN Department d  ON d.DepartmentID=a.DepartmentID
        AND DepartmentName='DEP_NAME') e ON a2.AccountID=e.AccountID
SET DepartmentID=7;

DELETE FROM Department
WHERE DepartmentName='DEP_NAME';
END;
 //
DELIMITER ;
DROP PROCEDURE DEL_DEPARTMENT ;                                                                               SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 0;
CALL DEL_DEPARTMENT('DEV');
SELECT * FROM ACCOUNT

                                                                                