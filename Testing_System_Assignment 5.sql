use Testing_system_1;

/*Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale*/
CREATE VIEW NV_SALE AS
SELECT ac.AccountID,ac.FuLLName
FROM Account ac
WHERE ac.DepartmentID IN (SELECT de.DepartmentID
					FROM Department de
					WHERE DepartmentName='sale');
/*Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất*/
CREATE VIEW Most_Group_join AS
SELECT ac.*
FROM Account ac
INNER JOIN	(
SELECT AccountID,count(GroupID)
	FROM GroupAccount a1
	GROUP BY AccountID
	HAVING count(GroupID)= (SELECT MAX(mycount)
	FROM ( SELECT AccountID, count(GroupID) mycount
				FROM GroupAccount a2
			GROUP BY AccountID	)a3)) gpa ON gpa.AccountID=ac.AccountID;

/*Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ
được coi là quá dài) và xóa nó đi*/
CREATE VIEW Long_question AS
SELECT *
FROM Question
WHERE char_length(content)>300;

DROP VIEW Long_question;

/*Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất*/
CREATE VIEW Biggest_De AS
SELECT de.*
FROM Department de
INNER JOIN		(
SELECT DepartmentID,count(AccountID)
                FROM Account a1
                GROUP BY DepartmentID
                HAVING count(AccountID)=(SELECT MAX(mycount)
										FROM ( SELECT DepartmentID,count(AccountID) mycount
												FROM Account a2
												GROUP BY DepartmentID) a3)) ac
ON de.DepartmentID= ac.DepartmentID ;

SELECT * FROM Biggest_De;
/*Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo*/
# ko co bang creator chi co creator ID
CREATE TABLE Creator  (
			CreatorID int(8) Primary key auto_increment ,
            CreatorName varchar(30)
);
ALTER TABLE Question ADD foreign key (CreatorID) references Creator(CreatorID);
ALTER TABLE Exam ADD foreign key (CreatorID) references Creator(CreatorID);
INSERT INTO Creator(CreatorName) Values ('quan'),
										('NGUYEN'),
                                        ('Nguyen'),
                                        ('Nam'),
                                        ('Anh'),
                                        ('Lam'),
                                        ('ONG'),
                                        ('BAN'),
                                        ('QUA'),
                                        ('SAON'),
                                        ('lol'),
                                        ('qu213an');

CREATE VIEW Question_by_NGUYEN AS
SELECT q.*
FROM Question q
INNER JOIN (SELECT *
			FROM Creator
            WHERE CreatorName LIKE concat ('Nguyen','%')) c
ON q.CreatorID = c.CreatorID 		;	
SELECT * FROM Question_by_NGUYEN;
