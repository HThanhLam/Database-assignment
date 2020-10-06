create database if not exists  Testing_system_1;
use Testing_system_1;

/*Assignment 1 Question 1:
Tạo table với các ràng buộc và kiểu dữ liệu*/
CREATE TABLE Department (
    DepartmentID		TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    DepartmentName 		VARCHAR(30) NOT NULL
);
CREATE TABLE Positions (
    PositionID 			SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    PositionName 		VARCHAR(15) NOT NULL
);
CREATE TABLE Account (
    AccountID 			INT(8) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Email 				VARCHAR(40) NOT NULL,
    Username 			VARCHAR(30) NOT NULL,
    FuLLname 			VARCHAR(30) NOT NULL,
    DepartmentID 		TINYINT NOT NULL,
    PositionID 			SMALLINT NOT NULL,
    CreateDate			DATE NOT NULL,
    FOREIGN KEY (DepartmentID)
        REFERENCES Department (DepartmentID),
    FOREIGN KEY (PositionID)
        REFERENCES Positions (PositionID)
);
CREATE TABLE groupp (
    GroupID 			INT(8) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    GroupName 			VARCHAR(30) NOT NULL,
    CreatorID 			INT(8) NOT NULL,
    CreateDate 			DATE NOT NULL
);	
CREATE TABLE GroupAccount (
    GroupID INT(8) NOT NULL,
    AccountID INT(8) PRIMARY KEY NOT NULL,
    JoinDate DATE NOT NULL,
    FOREIGN KEY (GroupID)
        REFERENCES groupp (GroupID),
    FOREIGN KEY (AccountID)
        REFERENCES Account (AccountID)
);
CREATE TABLE TypeQuestion (
    TypeID				INT(8) PRIMARY KEY AUTO_INCREMENT,
    TypeName 			VARCHAR(30) NOT NULL
);
CREATE TABLE CatagoryQuestion (
    CatagoryID 			INT(8) PRIMARY KEY AUTO_INCREMENT,
    CatagoryName 		VARCHAR(20) NOT NULL
);
CREATE TABLE Question (
    QuestionID 			INT(8) PRIMARY KEY AUTO_INCREMENT,
    Content 			VARCHAR(100) NOT NULL,
    CategoryID 			INT(8) NOT NULL,
    TypeID 				INT(8) NOT NULL,
    CreatorID 			INT(8) NOT NULL,
    CreateDate 			DATE NOT NULL,
    FOREIGN KEY (CategoryID)
        REFERENCES CatagoryQuestion (CatagoryID),
    FOREIGN KEY (TypeID)
        REFERENCES TypeQuestion (TypeID)
);
CREATE TABLE Answer (
    AnswerID 			INT(8) PRIMARY KEY AUTO_INCREMENT,
    Content 			VARCHAR(300) NOT NULL,
    QuestionID 			INT(8) NOT NULL,
    isCorret 			BOOLEAN,
    FOREIGN KEY (QuestionID)
        REFERENCES Question (QuestionID)
);
CREATE TABLE Exam (
    ExamID 				INT(8) PRIMARY KEY AUTO_INCREMENT,
    Code 				INT(8) NOT NULL,
    Title 				VARCHAR(30) NOT NULL,
    CatagoryID 			INT(8) NOT NULL,
    Duration			SMALLINT NOT NULL,
    CreatorID 			INT(8) NOT NULL,
    CreateDate			DATE NOT NULL,
    FOREIGN KEY (CatagoryID)
        REFERENCES CatagoryQuestion (CatagoryID)
);
CREATE TABLE ExamQuestion (
    ExamID 				INT(8) NOT NULL,
    QuestionID 			INT(8) NOT NULL,
    FOREIGN KEY (ExamID)
        REFERENCES Exam (ExamID),
    FOREIGN KEY (QuestionID)
        REFERENCES Question (QuestionID)
); 
/*assignment 2 
	Question 1:
Tối ưu lại assignment trước
Question 2:
Thêm các constraint vào assignment trước
*/
/*Q3 Chuẩn bị data cho bài 3
Insert data vào 11 table, mỗi table có ít nhất 5 records*/
INSERT INTO Department(DepartmentName) VALUES("Marketing"),("DEV"),('ENGI'),('TRANSL'),('PM');
INSERT INTO Positions(PositionName) VALUES("Leader"),("Basic"),('med'),('high'),('master');
INSERT INTO Account(Email,Username,FuLLname,DepartmentID,PositionID,CreateDate) 
VALUES				("svgg@gmail.com","svgg",'nguyen nguyet ke',1,1,'3000/11/10'),
					("nfghgft@gmail.com",'nfghgft','vong nguyet que',2,3,'2000/10/20'),
					('2y2bg@gmail.com','2y2bg','nguy kieu vi',3,5,'2400/10/12'),
					('fhgke54@gmail.com','fhgke54','hoangti',3,2,'2003/10/30'),
					('141gjyjhh 5m@gmail.com','141gjyjhh 5m','uhon',2,5,'2011/04/10'),
					('asdgqw 5m@gmail.com','141gjyjhh 5m','Dio',2,5,'2011/04/10');
INSERT INTO Groupp(GroupName,CreatorID,CreateDate) VALUES	('bun',200,'2300/10/20'),
															('banh cuon',300,'2000/12/10'),
                                                            ('yeay',400,'4000/10/20'),
                                                            ('POPL',500,'2404/05/25'),
                                                            ('asdg',600,'2664/06/26');
INSERT INTO GroupAccount(GroupID,AccountID,JoinDate)	 VALUES (1,1,'2020/5/25'),
																(2,2,'2014/12/12'),
																(3,3,'2008/12/01'),
																(4,4,'2010/04/15'),
																(5,5,'2022/12/24');
INSERT INTO TypeQuestion (TypeName) VALUES	('tree'),
											('root'),
                                            ('leaf'),
                                            ('flower'),
                                            ('fruit');
/*assignment 3
Question 1: Thêm ít nhất 10 record vào mỗi table*/
/*Question 2: lấy ra tất cả các phòng ban*/
SELECT * 
FROM	Department;
/*Question 3: lấy ra id của phòng ban "Sale"*/
SELECT	DepartmentID
FROM   	Department
WHERE	DepartmentName = 'Sale';
/*Question 4: lấy ra thông tin account có full name dài nhất*/
SELECT *
FROM Account
WHERE CHAR_LENGTH(FuLLname) >= ALL (SELECT CHAR_LENGTH(FuLLname)
									FROM    Account);
/*Question 5: Lấy ra thông tin account có full name dài nhất và thuộc phòng ban có id
= 3*/
SELECT     *
FROM 	Account
WHERE	CHAR_LENGTH(FuLLname) >= ALL (SELECT CHAR_LENGTH(FuLLname)
										FROM	Account)
AND DepartmentID = 3;
/*Question 6: Lấy ra tên group đã tham gia trước ngày 20/12/2019*/
SELECT     GroupName
FROM	groupp
WHERE	DATEDIFF(CreateDate, '2019/12/20') <= 0;
/*Question 7: Lấy ra ID của question có >= 4 câu trả lời*/
/*----select bi loi syntax ma em ko biet tai sao?----*/
SELECT QuestionID
FROM	Question
WHERE	(SELECT COUNT(AnswerID)
        FROM	Answer
        WHERE	Question.QuestionID = Answer.QuestionID) >= 4;
/*Question 8: Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày
20/12/2019*/
SELECT ExamID
FROM	Exam
WHERE	Duration >= 60
AND DATEDIFF(CreateDate, '2019/12/20');
/*Question 9: Lấy ra 5 group được tạo gần đây nhất*/
SELECT     *
FROM    groupp
ORDER BY CreateDate DESC
LIMIT 5;
/*Question 10: Đếm số nhân viên thuộc department có id = 2*/
SELECT     COUNT(AccountID)
FROM    Account
WHERE	DepartmentID = 2;
/*Question 11: Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"*/
SELECT     FuLLName
FROM    Account
WHERE    FullName LIKE CONCAT('D', '%', 'o');
/*Question 12: Xóa tất cả các exam được tạo trước ngày 20/12/2019*/
DELETE FROM Exam 
WHERE    DATEDIFF(CreateDate, '2019/12/20') <= 0;
/*Question 13: Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"*/
DELETE FROM Question 
WHERE    Content LIKE CONCAT('cau hoi', '%');
/*Question 14: Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và
email thành loc.nguyenba@vti.com.vn*/
UPDATE Account 
SET 
    FuLLName = 'Nguyen Ba Loc',
    Email = 'loc.nguyenba@vti.com.vn'
WHERE
    AccountID = 5;
/*Question 15: update account có id = 5 sẽ thuộc group có id = 4*/
UPDATE GroupAccount 
SET 
    GroupID = 4
WHERE
    AccountID = 5;

/*Assignment 4*/
/*Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ*/
SELECT     *
FROM	Account a
INNER JOIN
    Department de ON de.DepartmentID = a.DepartmentID;  
/*Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010*/
SELECT * FROM Account a
INNER JOIN (SELECT * FROM Account
			WHERE DATEDIFF(CreateDate,'2010/12/20')>=0) a2
		ON a.AccountID=a2.AccountID;
/*Question 3: Viết lệnh để lấy ra tất cả các developer*/
SELECT * FROM Account a
INNER JOIN Department de ON de.DepartmentID=a.DepartmentID
AND DepartmentName='DEV';
/*Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên*/
SELECT de.DepartmentID,de.DepartmentName
FROM Department de
INNER JOIN ( SELECT DepartmentID,Count(AccountID)
			FROM Account
            GROUP BY DepartmentID
            HAVING Count(AccountID)>3 ) a ON de.DepartmentID=a.DepartmentID;
/*Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều
nhất*/
SELECT QuestionID,Count(ExamID)
FROM ExamQuestion 
GROUP BY QuestionID
ORDER BY Count(ExamID) DESC
LIMIT 1;
/*Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question*/
Select q1.CategoryID,cq.CatagoryName,Count(QuestionID)
FROM Question q1
INNER JOIN CatagoryQuestion cq ON q1.CategoryID= cq.CatagoryID
GROUP BY q1.CategoryID;
/*Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam*/
SELECT ExamID,Count(QuestionID)
FROM ExamQuestion
GROUP BY ExamID;
/*Question 8: Lấy ra Question có nhiều câu trả lời nhất*/
SELECT QuestionID,Count(AnswerID)
FROM Answer
GROUP BY QuestionID
ORDER BY Count(AnswerID) DESC
LIMIT 1;
/*Question 9: Thống kê số lượng account trong mỗi group*/
SELECT ga.GroupID,gg.GroupName,Count(AccountID)
FROM GroupAccount ga
INNER JOIN groupp gg ON ga.GroupID=gg.GroupID
GROUP BY ga.GroupID;
/*Question 10: Tìm chức vụ có ít người nhất*/
SELECT PositionID,Count(AccountID)
FROM Account
GROUP BY PositionID
ORDER BY Count(AccountID) asc
LIMIT 1;
/*Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM*/
SELECT ac.DepartmentID,ac.PositionID,po.PositionName,Count(ac.PositionID) as so_luong_nv
FROM Account ac
INNER JOIN  Department de ON de.DepartmentID=ac.DepartmentID
INNER JOIN	Positions  po ON po.PositionID=ac.PositionID	
GROUP BY  ac.DepartmentID,po.PositionName;
/*Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của
question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, ...*/
SELECT *,ans.Content FROM Question qu
INNER JOIN Answer ans ON ans.QuestionID=ans.QuestionID;
/*Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm*/
SELECT q.CategoryID, cq. CatagoryName,Count(QuestionID)
FROM Question q
INNER JOIN CatagoryQuestion cq ON q.CategoryID=cq.CatagoryID
GROUP BY CategoryID;
/*Question 14:Lấy ra group không có account nào
  Question 15: Lấy ra group không có account nào	
*/
SELECT gg.GroupID
FROM groupp gg
LEFT JOIN (SELECT GroupID, Count(AccountID)
			FROM GroupAccount
			GROUP BY GroupID
            HAVING NOT Count(AccountID)=0) ga 
ON ga.GroupID=gg.GroupID
WHERE ga.GroupID is NULL;

/*Question 16: Lấy ra question không có answer nào*/
SELECT q.QuestionID
FROM Question q
LEFT JOIN (SELECT QuestionID, Count(AnswerID)
			FROM Answer
			GROUP BY QuestionID
            HAVING NOT Count(AnswerID)=0) ans 
ON q.QuestionID=ans.QuestionID
WHERE ans.QuestionID is NULL;

/*Question 17:a) Lấy các account thuộc nhóm thứ 1
b) Lấy các account thuộc nhóm thứ 2
c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau*/
# a)
SELECT * from Account
WHERE DepartmentID=1;
# b)
SELECT * from Account
WHERE DepartmentID=2;
# c)
SELECT * from Account
WHERE DepartmentID=1
UNION DISTINCT
SELECT * from Account
WHERE DepartmentID=2;
/*Question 18:
a) Lấy các group có lớn hơn 5 thành viên
b) Lấy các group có nhỏ hơn 7 thành viên
c) Ghép 2 kết quả từ câu a) và câu b)*/
#a)
Select gg.GroupID,gg.GroupName
FROM groupp gg
INNER JOIN (SELECT GroupID, Count(AccountID)
			FROM GroupAccount
            GROUP BY GroupID
            HAVING Count(AccountID)>5) ac ON gg.GroupID=ac.GroupID;
#b)
Select gg.GroupID,gg.GroupName
FROM groupp gg
INNER JOIN (SELECT GroupID, Count(AccountID)
			FROM GroupAccount
            GROUP BY GroupID
            HAVING Count(AccountID)<7) ac ON gg.GroupID=ac.GroupID;
#c)
Select gg.GroupID,gg.GroupName
FROM groupp gg
INNER JOIN (SELECT GroupID, Count(AccountID)
			FROM GroupAccount
            GROUP BY GroupID
            HAVING Count(AccountID)>5) ac ON gg.GroupID=ac.GroupID
UNION DISTINCT
Select gg.GroupID,gg.GroupName
FROM groupp gg
INNER JOIN (SELECT GroupID, Count(AccountID)
			FROM GroupAccount
            GROUP BY GroupID
            HAVING Count(AccountID)<7) ac ON gg.GroupID=ac.GroupID;