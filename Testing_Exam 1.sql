CREATE DATABASE db;
use db;

CREATE TABLE CUSTOMER (
    CustomerID 				INT(8) PRIMARY KEY AUTO_INCREMENT,
    Name					VARCHAR(30) NOT NULL,
    Phone 					INT(10) NOT NULL,
    Email 					VARCHAR(30) NOT NULL,
    Address 				VARCHAR(100) NOT NULL,
    Note 					VARCHAR(200) NOT NULL
);
CREATE TABLE CAR(
	CarID INT(8) PRIMARY KEY  AUTO_INCREMENT,
	Maker VARCHAR(10) NOT NULL,
	Model VARCHAR(30) NOT NULL,
	Year	YEAR NOT NULL,
    Color 	VARCHAR (10) NOT NULL,
	Note  	VARCHAR(200) NOT NULL,
	CHECK (Maker='HONDA' OR Maker='TOYOTA' OR Maker='NISSAN')
);
CREATE TABLE CAR_ORDER(
	OrderID			INT(8) PRIMARY KEY AUTO_INCREMENT,
	CustomerID INT(8) NOT NULL,
	CarID INT(8) NOT NULL,	
	Amount 	INT	DEFAULT 1,
	SalePrice INT NOT NULL,
	OrderDate DATE NOT NULL,
	DeliveryDate DATE ,
	DeliveryAddress VARCHAR(100) NOT NULL,
	Status	TINYINT DEFAULT 0,
	Note 	VARCHAR(200) NOT NULL,
    CHECK (Status=0 OR Status=1 OR Status=2),
    CONSTRAINT CUSTI FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
    CONSTRAINT CAR_COS FOREIGN KEY (CarID) REFERENCES CAR(CarID)
);

/*Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã
mua và sắp sếp tăng dần theo số lượng oto đã mua.*/

SELECT cu.CustomerID,Name, Amount
FROM CAR_ORDER co
INNER JOIN CUSTOMER cu ON cu.CustomerID=co.CustomerID
GROUP BY cu.CustomerID
ORDER BY Amount ASC;

/*Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được nhiều
oto nhất trong năm nay.*/
DELIMITER //
CREATE PROCEDURE B_BRAND (OUT B_NAME VARCHAR(10))
BEGIN 
	SELECT Maker ## INTO B_NAME
    FROM CAR c
    INNER JOIN (SELECT *
				FROM CAR_ORDER a
                GROUP BY OrderID
                HAVING YEAR(OrderDate)=YEAR(CURRENT_DATE())
                ORDER BY amount DESC
                LIMIT 1
                )
                co ON co.CarID=c.CarID;
    
END;
//
DELIMITER ;
DROP PROCEDURE B_BRAND;
CALL B_BRAND	(@B_NAME);
/*Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của
những năm trước. In ra số lượng bản ghi đã bị xóa.*/
DELIMITER //
CREATE PROCEDURE DEL_CANCEL()
BEGIN 

    SELECT COUNT(OrderID)  
					FROM CAR_ORDER
					WHERE status=2 AND YEAR(OrderDate)<YEAR(current_date());
	DELETE FROM CAR_ORDER 
    WHERE status=2 AND YEAR(OrderDate)<YEAR(current_date());
END;
//
DELIMITER ;
DROP PROCEDURE DEL_CANCEL;
SET SQL_SAFE_UPDATES = 0;
CALL DEL_CANCEL;
SELECT * FROM CAR_ORDER;
/*Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn
hàng đã đặt hàng bao gồm: tên của khách hàng, mã đơn hàng, số lượng oto
và tên hãng sản xuất.*/
DELIMITER //
CREATE PROCEDURE CUS_INFO (IN CUS_ID INT(8))
BEGIN 		
	SELECT NAME,OrderID,Maker,Amount
    FROM CAR_ORDER co
    INNER JOIN CUSTOMER cu ON cu.CustomerID=co.CustomerID AND cu.CustomerID=CUS_ID
    INNER JOIN CAR 		ca ON ca.CarID= co.CarID;
END;
//
DELIMITER ;
CALL CUS_INFO(2);
/*Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ
vào database (DeliveryDate < OrderDate + 15).*/
DELIMITER //

CREATE TRIGGER VALID_DATE
BEFORE INSERT
	ON CAR_ORDER FOR EACH ROW
BEGIN 
		WHILE (SELECT CarID
				FROM CAR_ORDER
				WHERE DeliveryDate < ADDDATE(OrderDate,15)
				LIMIT 1) IS NOT NULL DO
					DELETE FROM CAR_ORDER 
					WHERE DeliveryDate < ADDDATE(OrderDate,15);
		END WHILE;
 END;
 //
DELIMITER ;
DROP TRIGGER VALID_DATE;
INSERT INTO CUSTOMER (Name,Phone,Email,Address,Note) VALUES ('HAYONGYA',12032131,'HAYONGYANET@gmail.com','203 STREET 1023 ROAD 533','VALUES'),
('sakdjalw',04912965,'sakdjalw@gmail.com','513 STREET 125 ROAD 213','UNK'),
('1srha2',1235272,'1srha2@gmail.com','24214 STREET 521 ROAD 421','421'),
('y2regeq',12032131,'y2regeq@gmail.com','203 STREET 1023 ROAD 533','533'),
('srtrthr54',12032131,'srtrthr54@gmail.com','203 STREET 1023 ROAD 533','1023');
INSERT INTO CAR(Maker,Model,Year,Color,Note) VALUES ('NISSAN','20ek3',2020,'RED','GOOD'),
 ('HONDA','@%!@G',2019,'BLUE','GOOD'),
  ('TOYOTA','GSDNOE',2008,'BLACK','GOOD'),
   ('NISSAN','t13t',2010,'YELLOW','GOOD'),
    ('TOYOTA','gwagw43',2015,'WHITE','GOOD');
INSERT INTO CAR_ORDER(CustomerID,CarID,Amount,SalePrice,OrderDate,DeliveryDate,DeliveryAddress,Status,Note)
VALUES				(1,1,3,20000,'2020/12/20','2020/10/10','203 STREET 1023 ROAD 533',1,'NONE'),
					(2,2,1,15000,'2019/12/20','2020/10/10','513 STREET 125 ROAD 213',0,'NONE'),
					(3,5,2,20506,'2018/12/20','2020/10/10','203 STREET 1023 ROAD 533',2,'NONE'),
					(4,4,4,20012,'2019/12/20','2020/10/10','203 STREET 1023 ROAD 533',1,'NONE'),
					(5,2,2,10000,'2010/12/20','2020/10/10','203 STREET 1023 ROAD 533',2,'NONE')
