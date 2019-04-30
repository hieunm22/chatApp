-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 09, 2018 at 05:55 PM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 7.2.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `chatapp`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `createConversion` (IN `uid` INT(11), IN `fid` INT(11))  INSERT INTO conversion (`id`, `name`, `list_users`, `message_color`)
SELECT * FROM (SELECT max(`id`) + 1, null, concat(uid, ',', fid), 34047 from conversion) AS tmp
WHERE NOT EXISTS (
    SELECT 1
    From conversion_users As C1
    inner join conversion_users As C2 On C1.conversion_id = C2.conversion_id
    Where C1.user_id = uid And C2.user_id = fid
) LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createConversionUsers` (IN `uid` INT(11), IN `fid` INT(11))  NO SQL
insert into conversion_users(conversion_id, user_id, display_name)
select * from
(
	SELECT max(`id`), uid as user_id, (select alias from users where id=uid) as alias from conversion
	union
	SELECT max(`id`), fid as user_id, (select alias from users where id=fid) as alias from conversion
) as tmp
where not exists (
    SELECT 1
    From conversion_users As C1
    inner join conversion_users As C2 On C1.conversion_id = C2.conversion_id
    Where C1.user_id = uid And C2.user_id = fid
)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `displayMessage` (IN `uid` INT(11), IN `fid` INT(11))  select 
    m.conversion_id,
    m.message_content,
    m.message_type,
    m.sender_id,
    u.NAME,
    u.alias,
    u.gender,
	u.avatar_url,
    u.current_connect,
    CASE
    	WHEN DATEDIFF(NOW(), m.time) = 0 THEN date_format(m.time, '%H:%i')
        WHEN DATEDIFF(NOW(), m.time) = 1 THEN date_format(m.time, 'Hôm qua, %H:%i')
        WHEN DATEDIFF(NOW(), m.time) < 7 and DATEDIFF(NOW(), m.time) > 1 THEN date_format(m.time, '%W %H:%i')
        WHEN YEAR(m.time) - YEAR(now()) = 0 THEN date_format(m.time, '%d %M %H:%i')
        ELSE date_format(time, '%d %M %Y %H:%i')
	END as sent_time,
    CASE
    	WHEN DATEDIFF(NOW(), m.time) = 0 THEN date_format(m.read_time, '%H:%i')
        WHEN DATEDIFF(NOW(), m.time) = 1 THEN date_format(m.read_time, 'Hôm qua, %H:%i')
        WHEN DATEDIFF(NOW(), m.time) < 7 and DATEDIFF(NOW(), m.time) > 1 THEN date_format(m.read_time, '%W %H:%i')
        WHEN YEAR(m.time) - YEAR(now()) = 0 THEN date_format(m.read_time, '%d %M %H:%i')
        ELSE date_format(read_time, '%d %M %Y %H:%i')
	END as read_time,
    c.message_color,
    m.`status`,
    cu.display_name
from message m
inner JOIN users u on m.sender_id=u.id
inner JOIN conversion c on m.conversion_id=c.id
inner JOIN conversion_users cu on cu.conversion_id=m.conversion_id and cu.user_id = m.sender_id
where m.conversion_id = getConversionID(uid, fid)
order by m.time$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getFriendInfo` (IN `uid` INT(11), IN `fid` INT(11))  NO SQL
select u.*, cu.display_name 
	from conversion_users cu 
	inner join users u on cu.user_id = u.id
	where u.id=fid
	and cu.conversion_id in (Select C1.`conversion_id`
		From conversion_users As C1
		inner join conversion_users As C2 On C1.`conversion_id` = C2.`conversion_id`
		Where C1.`user_id` = uid And C2.`user_id` = fid)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertMessage` (IN `uid` INT(11), IN `msg` VARCHAR(20000) CHARSET utf8, IN `fid` INT(11))  NO SQL
INSERT INTO `message`(`conversion_id`, `message_content`, `sender_id`, `time`, `status`, `message_type`)
    SELECT `id`, msg, uid, now(), 1, 0 FROM `conversion`
    WHERE `id` in (
        select `conversion_id`
        from conversion_users
        where `user_id` in (uid, fid)
        group by `conversion_id`
        having count(`user_id`)=2
    )$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUser` (IN `usr` VARCHAR(255) CHARSET utf8, IN `pwd` VARCHAR(50), IN `eml` VARCHAR(255) CHARSET utf8, IN `ali` VARCHAR(255) CHARSET utf8, IN `gen` INT(1) UNSIGNED, IN `pho` VARCHAR(15))  NO SQL
INSERT INTO `users`(`name`, `password`, `email`, `alias`, `gender`, `avatar_url`, `phone`) 
select 	usr, 
		pwd, 
        eml,
        ali,
        gen,
        case gen
            WHEN 1 THEN 'images/2Q==.jpg'
            ELSE 'images/9k=.jpg' END, 
        pho$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `loginVertification` (IN `usr` VARCHAR(50), IN `pwd` VARCHAR(50))  NO SQL
SELECT `id`, `name`, `email`, `alias`, `phone`, `status`, `gender`, `current_connect`
    FROM users
    where (`id`=usr or `name`=usr or `email`=usr or `phone`=usr) and `password`=md5(pwd)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `markAsRead` (IN `uid` INT(11), IN `fid` INT(11))  NO SQL
UPDATE `message`
SET `status` = 3
WHERE
    1=1
    #AND `status` = 2
    AND conversion_id = getConversionID(uid, fid)
    and sender_id != uid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `markAsReceived` (IN `uid` INT(11))  NO SQL
UPDATE `message`
SET `status` = 2
WHERE
    `status` < 2
    AND conversion_id IN (
        SELECT conversion_id
        FROM conversion_users
        WHERE user_id = uid	)
    AND sender_id != uid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `openChat` (IN `uid` INT(11), IN `fid` INT(11))  NO SQL
BEGIN
	CALL setReadTime(uid, fid);
	CALL markAsRead(uid, fid);
    update users set current_connect = fid where id = uid;
	CALL displayMessage(uid, fid);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchUsers` (IN `uid` INT(11))  NO SQL
SELECT a.*, u2.avatar_url as avatar_lastsender FROM 
(
	SELECT
		m.message_content,
		m.read_time,
		m.message_type,
		m.status as msgstatus,
		CASE
			WHEN DATEDIFF(NOW(), m.time) = 0 THEN DATE_FORMAT(m.time, '%H:%i')
			WHEN DATEDIFF(NOW(), m.time) < 7 THEN DATE_FORMAT(m.time, '%W')
			ELSE DATE_FORMAT(m.time, '%d %M')
		END AS sent_time,
		CASE
			WHEN DATEDIFF(NOW(), m.time) = 0 THEN 'Today'
			WHEN DATEDIFF(NOW(), m.time) < 7 THEN DATE_FORMAT(m.time, '%W')
			ELSE DATE_FORMAT(m.time, '%d %M')
		END AS sent_date,
		m.time AS realtime,
		m.sender_id as friend_id,
		u.avatar_url as avatar_friend,
		u.alias,
    	u.gender,
		u.status as usrstatus,
		cu.display_name,    
		m.last_sender_id
	FROM
		(
		# select cac message cuoi cung cua cac conversion
		SELECT
			message_content,
			TIME,
			STATUS,
			read_time,
			message_type,
			# luc nao cung phai la id cua friend dang chat de lay duoc avatar trong bang users
			CASE
				WHEN sender_id=uid THEN (select user_id from conversion_users c_u where c_u.conversion_id = message.conversion_id and c_u.user_id != uid)
				ELSE sender_id
			END as sender_id,
			sender_id as last_sender_id,
			conversion_id
		FROM message
		WHERE id IN(
			SELECT MAX(id)
			FROM message
			WHERE conversion_id IN (
				#conversions user dang dang nhap tham gia
				SELECT conversion_id FROM conversion_users
				WHERE user_id = uid
			)
			GROUP BY
				conversion_id
		)
		) m
	# join voi users de lay avatar va alias
	INNER JOIN users u ON m.sender_id = u.id
	# join voi conversion_users de lay display name in conversion
	left JOIN conversion_users cu ON
		cu.user_id = m.sender_id AND m.conversion_id = cu.conversion_id
) a
INNER JOIN users u2 ON a.last_sender_id = u2.id
order by a.realtime DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchUsersText` (IN `txt` TEXT, IN `uid` INT(11))  NO SQL
select id as friend_id, name, alias, phone, email, status, avatar_url
from users
where (name like concat('%',txt,'%')
or alias like concat('%',txt,'%')
or email like concat('%',txt,'%')
or phone like concat('%',txt,'%'))
and id != uid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sendMessage` (IN `uid` INT(11), IN `fid` INT(11), IN `msg` VARCHAR(20000) CHARSET utf8)  BEGIN
  call createConversion(uid, fid);
  call createConversionUsers(uid, fid);
  call insertMessage(uid, msg, fid);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `setConversionAction` (IN `msgtype` INT(1), IN `uid` INT(9), IN `fid` INT(9))  NO SQL
insert into message(message_type, sender_id, time, status, conversion_id) 
values (msgtype, uid, now(), 1, getConversionID(uid, fid))$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `setConversionColor` (IN `uid` INT(11), IN `fid` INT(11), IN `col` INT(11))  NO SQL
update conversion
set `message_color` = col
where `id` in (getConversionID(uid, fid))$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `setNickName` (IN `uid` INT(11), IN `fid` INT(11), IN `nick` VARCHAR(255) CHARSET utf8)  NO SQL
update conversion_users
set `display_name` = nick
where `conversion_id` in (getConversionID(uid, fid))
and user_id = uid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `setNickNames` (IN `uid` INT(11), IN `fid` INT(11), IN `nick1` VARCHAR(255) CHARSET utf8, IN `nick2` VARCHAR(255) CHARSET utf8)  NO SQL
BEGIN
	call setNickName(uid, fid, nick1);
    call setNickName(fid, uid, nick2);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `setReadTime` (IN `uid` INT(11), IN `fid` INT(11))  NO SQL
update message
set read_time=now()
where status=2
and conversion_id = getConversionID(uid, fid)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUser` (IN `usr` VARCHAR(255) CHARSET utf8, IN `pwd` VARCHAR(50), IN `eml` VARCHAR(255) CHARSET utf8, IN `ali` VARCHAR(255) CHARSET utf8, IN `pho` VARCHAR(15), IN `uid` INT(11))  NO SQL
UPDATE
    `users`
SET
    `name` = usr,
    `password` = pwd,
    `email` = eml,
    `alias` = ali,
    `phone` = pho,
    `status` = 1
WHERE
    `id`=uid$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getConversionID` (`uid` INT, `fid` INT) RETURNS INT(11) BEGIN
	DECLARE cid int;

	#SELECT `id` INTO new_username FROM `users` WHERE `ID` = uid;
	#Select C1.conversion_id INTO new_username
	#From conversion_users C1
	#inner join conversion_users C2 On C1.conversion_id = C2.conversion_id
	#Where C1.user_id = uid And C2.user_id = fid;
    
    select `conversion_id` INTO cid
    from conversion_users
    where `user_id` in (uid, fid)
    group by `conversion_id`
    having count(`user_id`)=2;

	RETURN cid;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `rownum` () RETURNS INT(11) BEGIN
  set @prvrownum=if(@ranklastrun=CURTIME(6),@prvrownum+1,1);
  set @ranklastrun=CURTIME(6);
  RETURN @prvrownum;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `conversion`
--

CREATE TABLE `conversion` (
  `id` int(11) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `list_users` varchar(255) DEFAULT NULL,
  `message_color` int(11) DEFAULT '34047'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `conversion`
--

INSERT INTO `conversion` (`id`, `name`, `list_users`, `message_color`) VALUES
(25, NULL, '1,2', 6797416),
(31, NULL, '1,8', 34047),
(32, NULL, '6,1', 34047),
(33, NULL, '3,1', 16743592),
(34, NULL, '1,5', 4505287),
(35, NULL, '9,1', 6724044),
(37, NULL, '1,17', 34047),
(38, NULL, '11,1', 34047),
(39, NULL, '10,1', 34047),
(40, NULL, '1,29', 34047),
(41, NULL, '12,1', 34047),
(42, NULL, '6,2', 34047),
(43, NULL, '1,34', 34047),
(44, NULL, '1,45', 34047),
(59, NULL, '1,32', 34047),
(60, NULL, '1,13', 34047),
(61, NULL, '1,30', 34047),
(62, NULL, '1,42', 34047),
(63, NULL, '1,18', 34047),
(64, NULL, '1,7', 34047),
(65, NULL, '1,43', 34047),
(66, NULL, '1,50', 34047),
(67, NULL, '1,32', 34047),
(68, NULL, '1,59', 34047),
(69, NULL, '1,60', 34047),
(70, NULL, '1,60', 34047),
(71, NULL, '1,60', 34047),
(72, NULL, '62,1', 6724044),
(73, NULL, '11,63', 34047);

-- --------------------------------------------------------

--
-- Table structure for table `conversion_users`
--

CREATE TABLE `conversion_users` (
  `id` int(11) NOT NULL,
  `conversion_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `display_name` text CHARACTER SET utf8 COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `conversion_users`
--

INSERT INTO `conversion_users` (`id`, `conversion_id`, `user_id`, `display_name`) VALUES
(1, 25, 1, 'Anh cả'),
(2, 25, 2, '012820288'),
(3, 31, 1, 'Ming Hieu'),
(4, 31, 8, 'Phạm Trung Thành'),
(5, 32, 6, 'Thanh Thao Nguyen'),
(6, 32, 1, 'Ming Hieu'),
(7, 33, 3, 'Phuong Khanh'),
(8, 33, 1, 'Ming Hieu'),
(9, 34, 1, 'Ming Hieu'),
(10, 34, 5, 'Vu Tran'),
(11, 35, 9, 'Phan Son'),
(12, 35, 1, 'Ming Hieu'),
(13, 37, 1, 'Ming Hieu'),
(14, 37, 17, 'To Van Ba'),
(15, 38, 11, 'Hương cute'),
(16, 38, 1, 'Hieu baby'),
(17, 39, 10, 'John Vu Nam'),
(18, 39, 1, 'Ming Hieu'),
(19, 40, 1, 'Ming Hieu'),
(20, 40, 29, 'Ha Dac Duong'),
(21, 41, 12, 'Trung Nguyen Tien'),
(22, 41, 1, 'Ming Hieu'),
(23, 42, 6, 'Thanh Thao Nguyen'),
(24, 42, 2, 'Thuy Hoa Pham'),
(25, 43, 1, 'Ming Hieu'),
(26, 43, 34, 'Kim Anh Bé'),
(27, 44, 1, 'Ming Hieu'),
(28, 44, 45, 'Bảo Bảo Vui Vẻ'),
(45, 60, 1, 'Ming Hieu'),
(46, 60, 13, 'Le Bao Nam'),
(63, 61, 1, 'Ming Hieu'),
(64, 61, 30, 'Hoàng Ngọc Minh'),
(66, 62, 1, 'Ming Hieu'),
(67, 62, 42, 'Tuyen Ngo'),
(69, 63, 1, 'Ming Hieu'),
(70, 63, 18, 'Vu Duc Ba'),
(72, 64, 1, 'Ming Hieu'),
(73, 64, 7, 'Do Nam'),
(74, 65, 1, 'Ming Hieu'),
(75, 65, 43, 'Hanh su'),
(76, 66, 1, 'Ming Hieu'),
(77, 66, 50, 'Thùy Dung'),
(79, 67, 1, 'Ming Hieu'),
(80, 67, 32, 'Nam Cung'),
(81, 68, 1, 'Ming Hieu'),
(82, 68, 59, 'Trịnh Văn Tiến Dũng'),
(83, 71, 1, 'Ming Hieu'),
(84, 71, 60, 'Sơn Tùng'),
(85, 72, 62, 'Nga Đếch'),
(86, 72, 1, 'Ming Hieu'),
(88, 73, 11, 'Hoàng Hương'),
(89, 73, 63, 'Quynh Nguyen');

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE `message` (
  `id` int(11) NOT NULL,
  `conversion_id` int(11) DEFAULT NULL,
  `message_content` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `sender_id` int(11) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `status` int(11) DEFAULT '0' COMMENT '0: sending, 1: sent, 2: received, 3: seen',
  `read_time` datetime DEFAULT NULL,
  `message_type` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `message`
--

INSERT INTO `message` (`id`, `conversion_id`, `message_content`, `sender_id`, `time`, `status`, `read_time`, `message_type`) VALUES
(15, 25, 'toi a ve muon', 1, '2018-04-16 16:43:13', 3, '2018-04-16 16:43:13', b'0'),
(16, 25, 'danh aoe', 1, '2018-04-17 16:43:15', 3, '2018-04-17 16:43:15', b'0'),
(20, 25, 'nho ve som', 2, '2018-04-17 16:47:18', 3, '2018-04-17 16:47:18', b'0'),
(27, 25, 'cho lac di vien chua', 1, '2018-04-18 08:59:52', 3, '2018-04-18 08:59:52', b'0'),
(28, 31, 'chu tach cmnr =))', 1, '2018-04-18 09:00:31', 3, '2018-04-18 09:00:31', b'0'),
(29, 32, 'toi co ve lo duc khong', 1, '2018-04-18 09:00:40', 3, '2018-04-18 09:00:40', b'0'),
(32, 34, 'luon khonggggggggggg', 1, '2018-04-18 09:00:57', 3, '2018-04-18 09:00:57', b'0'),
(33, 25, 'dang o vien roi nhe', 2, '2018-04-18 09:48:51', 3, '2018-04-18 09:48:51', b'0'),
(34, 25, 'vua khi dung xong', 2, '2018-04-18 09:48:56', 3, '2018-04-18 09:48:56', b'0'),
(35, 25, 'khí dung', 2, '2018-04-18 09:49:04', 3, '2018-04-18 09:49:04', b'0'),
(37, 33, 'fifaaaaaaaaaaa', 1, '2018-04-18 10:30:40', 3, '2018-04-18 10:30:40', b'0'),
(38, 25, 'ba ve chua', 1, '2018-04-18 11:20:28', 3, '2018-04-18 11:20:28', b'0'),
(39, 25, 'alo', 1, '2018-04-18 11:22:05', 3, '2018-04-18 11:22:05', b'0'),
(40, 33, 'dang o sg', 3, '2018-04-18 11:22:51', 3, '2018-04-18 11:22:51', b'0'),
(41, 35, 'fifa de', 9, '2018-04-18 11:26:32', 3, '2018-04-18 11:26:32', b'0'),
(42, 35, 'goi deo co song deo goi duoc', 9, '2018-04-18 11:26:40', 3, '2018-04-18 11:26:40', b'0'),
(43, 25, 'bo no an com chua', 1, '2018-04-18 12:29:07', 3, '2018-04-18 12:29:07', b'0'),
(44, 25, 'roi` nhe', 2, '2018-04-18 12:29:38', 3, '2018-04-18 12:29:38', b'0'),
(45, 25, 'vua xong', 2, '2018-04-18 12:29:40', 3, '2018-04-18 12:29:40', b'0'),
(57, 25, 'đang thi bánh trôi nước', 1, '2018-04-18 15:57:57', 3, '2018-04-18 15:57:57', b'0'),
(58, 25, 'Theo quy định của hợp đồng, Bảo hiểm đồng ý thanh toán những chi phí khám và thuốc hợp lý, cần thiết về mặt y tế, theo chỉ định của bác sĩ điều trị, phát sinh khi người được bảo hiểm phải điều trị bệnh mà việc điều trị được bảo hiểm, không thanh toán chi phí mua mỹ phẩm, thực phẩm chức năng, vật tư y tế. Do đó rất tiếc bảo hiểm từ chối thanh toán các chi phí sau vì không thuộc phạm vi bảo hiểm: <br />- Gạc phãu thuật bằng 7.800 vnd <br />- Mỹ phẩm \'\' Avene <br />- Ciacalfate \'\' bằng 409.882 vnd đồng thời sản phẩm được kê trên phiếu tư vấn, không phải đơn thuốc.', 1, '2018-04-18 16:53:56', 3, '2018-04-18 16:53:56', b'0'),
(59, 25, '- Chính sách trẻ em tại khách sạn: Miễn phí cho 2 trẻ em dưới 12 tuổi ngủ chung phòng. Ăn sáng phụ thu theo chiều cao. Dưới 1m miễn phí. Từ 1m đến 1.2m tính 60k. Từ 1.3m trở lên tính 120k <br />- Extra bed: 300k/giường. <br />- Công ty chỉ tài trợ chi phí Gala Dinner cho các FISer và người thân là Vợ/chồng và con. <br />Trong TH là CB đưa bố mẹ, anh chị em đi nghỉ mát cùng, vui lòng confirm lại giúp em về số lượng tham gia. BTC sẽ tính phí tương đương 500k/người.', 1, '2018-04-18 17:02:40', 3, '2018-04-18 17:02:40', b'0'),
(60, 25, 'abc', 1, '2018-04-19 08:34:45', 3, '2018-04-19 08:34:45', b'0'),
(62, 25, ':v', 1, '2018-04-19 08:35:53', 3, '2018-04-19 08:35:53', b'0'),
(64, 37, 'uong nuoc de', 1, '2018-04-19 09:13:04', 3, '2018-04-19 09:13:04', b'0'),
(65, 38, 'dao nay lam an the nao roi', 1, '2018-04-19 10:17:06', 3, '2018-04-19 10:17:06', b'0'),
(67, 31, 'chan vai dai', 1, '2018-04-19 10:55:33', 3, '2018-04-19 10:55:33', b'0'),
(68, 32, 'a', 1, '2018-04-19 10:56:41', 3, '2018-04-19 10:56:41', b'0'),
(70, 34, 'lam an the nao roi', 1, '2018-04-19 11:08:52', 3, '2018-04-19 11:08:52', b'0'),
(71, 37, 'toi di duoc khong', 1, '2018-04-19 11:12:11', 2, '2018-12-02 01:48:39', b'0'),
(72, 33, 'lanh qua\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'', 1, '2018-04-19 11:36:17', 3, '2018-11-10 10:14:08', b'0'),
(73, 39, 'alo', 1, '2018-04-19 11:43:46', 3, '2018-04-19 11:43:46', b'0'),
(74, 39, 'co tien chua', 1, '2018-04-19 11:43:48', 3, '2018-10-25 17:15:17', b'0'),
(75, 40, 'dao nay lam an the nao roi`', 1, '2018-04-19 11:44:00', 3, '2018-04-19 11:44:00', b'0'),
(76, 41, 'trung bua', 1, '2018-04-19 11:45:32', 3, '2018-04-19 11:45:32', b'0'),
(77, 25, 'mẹ mày', 1, '2018-04-19 15:01:42', 3, '2018-04-19 15:01:42', b'0'),
(78, 31, 'vang e cung du doan tu truoc roi`', 8, '2018-04-20 09:08:28', 3, '2018-04-20 09:08:28', b'0'),
(79, 31, '=))', 8, '2018-04-20 09:09:41', 3, '2018-04-20 09:09:41', b'0'),
(80, 25, 'lac tiem chua', 1, '2018-04-20 09:24:39', 3, '2018-04-20 09:24:39', b'0'),
(81, 25, 'tiem roi', 2, '2018-04-20 09:24:54', 3, '2018-04-20 09:24:54', b'0'),
(82, 25, 'dang ngu nhe', 2, '2018-04-20 09:24:56', 3, '2018-04-20 09:24:56', b'0'),
(84, 25, 'mẹ mày mang ipad vào viện à', 1, '2018-04-20 14:02:30', 3, '2018-04-20 14:02:30', b'0'),
(85, 25, 'lac dang kham them o phong kham ngoai nhe', 2, '2018-04-20 16:51:02', 3, '2018-04-20 16:51:02', b'0'),
(87, 25, 'ke cai me', 1, '2018-04-20 16:58:09', 3, '2018-04-20 16:58:09', b'0'),
(88, 32, 'co\'', 6, '2018-04-20 17:08:46', 3, '2018-04-20 17:08:46', b'0'),
(89, 42, 'lac hom nay di tiem co khoc khong', 6, '2018-04-20 17:09:53', 3, '2018-04-20 17:09:53', b'0'),
(90, 42, 'khong', 2, '2018-04-20 17:10:08', 3, '2018-04-20 17:10:08', b'0'),
(91, 42, 'hom nay chi cho no di kham ngoai`', 2, '2018-04-20 17:10:13', 3, '2018-04-20 17:10:13', b'0'),
(92, 25, 'xin chuyen vien chua', 1, '2018-04-23 09:06:18', 3, '2018-04-23 09:06:18', b'0'),
(93, 25, 'đang bảo nó rồi', 2, '2018-04-23 09:14:04', 3, '2018-04-23 09:14:04', b'0'),
(97, 25, 'me may`', 1, '2018-04-23 10:57:05', 3, '2018-04-23 10:57:05', b'0'),
(98, 25, 'xin chuyen vien chua', 1, '2018-04-23 10:57:13', 3, '2018-04-23 10:57:13', b'0'),
(99, 25, 've nha roi`', 2, '2018-04-26 09:56:17', 3, '2018-04-26 09:56:17', b'0'),
(111, 32, 'abc', 1, '2018-05-02 17:06:21', 3, '2018-05-02 17:06:21', b'0'),
(112, 32, 'uh', 1, '2018-05-03 08:16:55', 3, '2018-05-03 08:16:55', b'0'),
(114, 41, 'o thang nay lao nhi', 12, '2018-05-03 08:59:34', 3, '2018-05-03 08:59:34', b'0'),
(115, 41, 'dao nay lam an the nao roi', 12, '2018-05-03 08:59:39', 3, '2018-05-03 08:59:39', b'0'),
(116, 41, 'sap toi di an cuoi son nhe', 12, '2018-05-03 08:59:42', 3, '2018-05-03 08:59:42', b'0'),
(117, 40, 'e van o teca', 29, '2018-05-03 08:59:55', 3, '2018-05-03 08:59:55', b'0'),
(118, 40, 'chua thoat duoc dự án giám định', 29, '2018-05-03 09:00:04', 3, '2018-05-03 09:00:04', b'0'),
(119, 25, 'mẹ mày', 1, '2018-05-03 09:04:56', 3, '2018-05-03 09:04:56', b'0'),
(123, 25, 'not seen?', 1, '2018-05-03 09:15:46', 3, '2018-05-03 09:15:46', b'0'),
(125, 44, 'anh hieu', 45, '2018-05-03 10:40:33', 3, '2018-05-03 10:40:33', b'0'),
(126, 44, 'sao ko di an cuoi em', 45, '2018-05-03 10:40:39', 3, '2018-05-03 10:40:39', b'0'),
(128, 44, 'a nam vien', 1, '2018-05-03 10:53:13', 3, '2018-05-03 10:53:13', b'0'),
(129, 44, 'a bi sao the', 45, '2018-05-03 10:58:00', 3, '2018-05-03 10:58:00', b'0'),
(130, 34, 'abc', 1, '2018-05-06 03:12:52', 3, '2018-05-06 03:12:52', b'0'),
(131, 34, 'dcm goi deo tra loi a', 1, '2018-05-06 03:16:05', 3, '2018-05-06 03:16:05', b'0'),
(132, 34, 'bo deo tra loi day lam lol gi nhau', 5, '2018-05-06 03:23:11', 3, '2018-05-06 03:23:11', b'0'),
(133, 34, 'vang a', 1, '2018-05-06 03:28:58', 3, '2018-05-06 03:28:58', b'0'),
(134, 34, 'NGU', 5, '2018-05-06 03:29:08', 3, '2018-05-06 03:29:08', b'0'),
(136, 38, 'em sắp hết hợp đồng rồi', 11, '2018-05-08 09:12:30', 3, '2018-05-08 09:12:30', b'0'),
(137, 38, 'chả biết được ký tiếp không nữa', 11, '2018-05-08 09:12:37', 3, '2018-05-08 09:12:37', b'0'),
(138, 38, 'huhu', 11, '2018-05-08 09:12:39', 3, '2018-05-08 09:12:39', b'0'),
(139, 38, 'bi quan the\'', 1, '2018-05-08 14:21:26', 3, '2018-05-08 14:21:26', b'0'),
(141, 31, 'dm nhầm', 1, '2018-05-08 14:54:56', 3, '2018-06-27 15:35:48', b'0'),
(142, 25, 'trong gio lam viec thi chat chit gi', 2, '2018-05-08 22:28:01', 3, '2018-05-08 22:28:01', b'0'),
(148, 60, 'alo', 1, '2018-05-09 08:18:53', 3, '2018-05-09 08:18:53', b'0'),
(149, 61, 'giờ dùng số nào thế', 1, '2018-05-09 09:29:24', 2, '2018-12-02 01:48:35', b'0'),
(150, 62, 'giờ làm đâu rồi', 1, '2018-05-09 09:34:12', 3, '2018-05-09 09:34:12', b'0'),
(151, 62, 'hẹn mây thằng đi nhậu đi', 1, '2018-05-09 09:34:23', 3, '2018-05-09 09:34:23', b'0'),
(152, 63, 'rảnh không chỉ tao vài bí kíp oracle', 1, '2018-05-09 09:35:05', 2, '2018-11-25 00:10:16', b'0'),
(153, 64, 'mày có số minh gà không', 7, '2018-05-09 09:52:36', 3, '2018-05-09 09:52:36', b'0'),
(154, 64, 'tao gọi toàn thuê bao', 7, '2018-05-09 09:52:42', 3, '2018-05-09 09:52:42', b'0'),
(155, 64, 'không', 1, '2018-05-09 09:53:08', 3, '2018-05-09 09:53:08', b'0'),
(156, 64, 'vẫn số cũ', 1, '2018-05-09 09:53:12', 3, '2018-05-09 09:53:12', b'0'),
(157, 64, 'để tao hỏi xem', 1, '2018-05-09 09:53:16', 3, '2018-05-09 09:53:16', b'0'),
(158, 60, 'sorry nhầm', 1, '2018-05-09 09:54:18', 2, '2018-12-05 23:38:38', b'0'),
(159, 25, 'bo no', 2, '2018-05-09 14:18:51', 3, '2018-05-09 14:18:51', b'0'),
(160, 25, 'bao hh di an voi hoi off', 2, '2018-05-09 14:18:59', 3, '2018-05-09 14:18:59', b'0'),
(161, 25, 'mẹ mày thì ở nhà', 1, '2018-05-10 16:29:09', 3, '2018-05-10 16:29:09', b'0'),
(162, 25, 'đi đâu', 1, '2018-05-10 16:29:12', 3, '2018-05-10 16:29:12', b'0'),
(163, 25, 'the nhe\'', 1, '2018-05-10 17:17:43', 3, '2018-05-10 17:17:43', b'0'),
(166, 35, 'NGU', 1, '2018-05-11 08:28:34', 3, '2018-10-23 09:09:28', b'0'),
(167, 64, 'nay đến lấy máy lúc mấy giờ', 1, '2018-05-11 09:43:45', 3, '2018-05-11 09:43:45', b'0'),
(194, 25, '?????', 1, '2018-05-16 23:46:25', 3, '2018-05-16 23:46:25', b'0'),
(195, 62, 'lai ve fpt a`', 1, '2018-05-16 23:59:32', 3, '2018-05-16 23:59:32', b'0'),
(196, 62, 'hh lam dau roi`', 1, '2018-05-16 23:59:39', 2, '2018-12-01 00:06:58', b'0'),
(197, 64, '8g', 7, '2018-05-17 00:04:54', 3, '2018-05-17 00:04:54', b'0'),
(198, 64, '8h', 7, '2018-05-17 00:04:57', 3, '2018-05-17 00:04:57', b'0'),
(199, 40, 'chac cung phai duoc 2 nam roi nhi', 1, '2018-05-17 00:05:19', 3, '2018-05-17 00:05:19', b'0'),
(208, 62, 'lai fsoft duy tan a`', 1, '2018-05-17 22:38:52', 1, NULL, b'0'),
(211, 32, 'hết mì cốc rồi', 1, '2018-05-19 13:37:49', 3, '2018-05-19 13:37:49', b'0'),
(212, 32, 'tối có về đây thì mua nhé', 1, '2018-05-19 13:38:05', 3, '2018-05-19 13:38:05', b'0'),
(213, 32, 'ok', 6, '2018-05-19 17:57:07', 3, '2018-05-19 17:57:07', b'0'),
(214, 32, 'toi ve day an chia tay co an khong', 1, '2018-05-19 17:57:30', 3, '2018-05-19 17:57:30', b'0'),
(215, 32, 'co an moi`', 1, '2018-05-19 17:57:33', 3, '2018-05-19 17:57:33', b'0'),
(216, 66, 'chi gio lam dau roi`', 1, '2018-05-19 22:59:38', 3, '2018-10-23 09:07:39', b'0'),
(217, 67, 'gio dang o viet nam hay nhat', 1, '2018-05-19 23:00:19', 3, '2018-05-19 23:00:19', b'0'),
(218, 38, 'e duoc ky\' roi`', 11, '2018-05-20 00:06:44', 3, '2018-05-20 00:06:44', b'0'),
(219, 38, 'hihi', 11, '2018-05-20 00:06:47', 3, '2018-05-20 00:06:47', b'0'),
(221, 38, 'chuc mung`', 1, '2018-05-20 00:23:31', 3, '2018-05-20 00:23:31', b'0'),
(223, 38, 'hom nao an khao thoi nhi?', 1, '2018-05-20 01:29:54', 3, '2018-05-20 01:29:54', b'0'),
(224, 67, 'alo', 1, '2018-05-22 22:29:31', 3, '2018-10-25 10:24:37', b'0'),
(225, 35, '????', 1, '2018-05-22 22:48:08', 3, '2018-10-23 09:09:28', b'0'),
(226, 25, 'mai di kham rang nhe bo no', 2, '2018-05-26 20:31:03', 3, '2018-05-26 20:31:03', b'0'),
(227, 68, 'beo\'', 1, '2018-05-29 00:13:32', 3, '2018-10-25 10:24:14', b'0'),
(228, 68, 'dang lam o cho nao day', 1, '2018-05-29 00:13:35', 2, '2018-12-02 18:33:45', b'0'),
(230, 71, 'thau`', 1, '2018-05-29 22:16:02', 3, '2018-05-29 22:16:02', b'0'),
(231, 71, 'lam an the nao roi', 1, '2018-05-29 22:16:15', 3, '2018-05-29 22:16:15', b'0'),
(232, 71, 'sap len truong phong chua', 1, '2018-05-29 22:16:21', 3, '2018-05-29 22:16:21', b'0'),
(233, 71, 'alo', 1, '2018-05-29 22:35:04', 3, '2018-05-29 22:35:04', b'0'),
(235, 71, 'e van the', 60, '2018-05-29 22:57:05', 3, '2018-05-29 22:57:05', b'0'),
(236, 71, 'vẫn là xếp xó thôi', 60, '2018-05-31 09:05:05', 3, '2018-05-31 09:05:05', b'0'),
(241, 38, 'e dang hoc tieng nhat de chuan bi di nhat', 11, '2018-06-01 21:50:30', 3, '2018-06-01 21:50:30', b'0'),
(245, 31, 'chú giờ sang cmc rồi à', 1, '2018-06-27 15:34:25', 3, '2018-06-27 15:35:48', b'0'),
(246, 31, 'ngon vãi', 1, '2018-06-27 15:34:29', 3, '2018-06-27 15:35:48', b'0'),
(247, 31, 'hồi đấy mà trúng fis chắc đéo gì đã được 12', 1, '2018-06-27 15:34:40', 3, '2018-06-27 15:35:48', b'0'),
(248, 31, '12 củ', 1, '2018-06-27 15:34:48', 3, '2018-06-27 15:35:48', b'0'),
(249, 31, 'vâng', 8, '2018-06-27 15:35:59', 3, '2018-06-27 15:36:19', b'0'),
(250, 31, 'hên vãi đái', 8, '2018-06-27 15:36:04', 3, '2018-06-27 15:36:19', b'0'),
(251, 31, '=))', 8, '2018-06-27 15:36:06', 3, '2018-06-27 15:36:19', b'0'),
(252, 72, 'alo', 62, '2018-10-22 14:55:26', 3, '2018-10-22 22:13:05', b'0'),
(253, 72, 'xem hộ e cái thay màn hình 8 plus ở fpt giá bao nhiêu', 62, '2018-10-22 14:55:47', 3, '2018-10-22 22:13:05', b'0'),
(254, 73, 'dao nay khoe khong anh', 11, '2018-10-22 15:31:35', 3, '2018-10-22 15:32:56', b'0'),
(255, 72, '1860000 nhaaaaaaaaa', 1, '2018-10-22 22:27:37', 3, '2018-10-23 09:03:34', b'0'),
(256, 66, 'chị ở nhà', 50, '2018-10-23 09:07:45', 3, '2018-10-23 09:08:18', b'0'),
(257, 66, 'có đi làm đâu', 50, '2018-10-23 09:07:49', 3, '2018-10-23 09:08:18', b'0'),
(258, 66, 'trông con', 50, '2018-10-23 09:07:53', 3, '2018-10-23 09:08:18', b'0'),
(259, 66, 'khi nào chúng nó cứng cáp chị mới đi làm', 50, '2018-10-23 09:08:03', 3, '2018-10-23 09:08:18', b'0'),
(260, 35, 'ngu vcllllll', 9, '2018-10-23 09:09:50', 3, '2018-10-23 09:09:59', b'0'),
(261, 35, 'cut', 1, '2018-10-24 17:17:51', 3, '2018-10-24 17:34:51', b'0'),
(262, 72, 'alo hỏi hộ a bên đấy tuyển back office không', 1, '2018-10-25 08:56:44', 3, '2018-10-25 08:58:19', b'0'),
(263, 72, 'hỏi hộ cho con em', 1, '2018-10-25 08:56:48', 3, '2018-10-25 08:58:19', b'0'),
(264, 72, 'khối back office hiện đang tuyển comtor tiếng nhật', 62, '2018-10-25 10:20:04', 3, '2018-10-25 10:20:48', b'0'),
(265, 72, 'lễ tân (girl xinh)', 62, '2018-10-25 10:20:07', 3, '2018-10-25 10:20:48', b'0'),
(266, 72, 'trưởng phòng marketting', 62, '2018-10-25 10:20:18', 3, '2018-10-25 10:20:48', b'0'),
(267, 72, 'nhưng mà làm lễ tân làm méo j', 62, '2018-10-25 10:20:37', 3, '2018-10-25 10:20:48', b'0'),
(268, 72, 'ở hn thiếu j', 62, '2018-10-25 10:21:08', 3, '2018-10-25 10:23:41', b'0'),
(269, 67, 'vẫn ở trung kính', 32, '2018-10-25 10:24:47', 3, '2018-10-25 10:25:10', b'0'),
(270, 72, 'ok done rồi', 1, '2018-10-26 13:55:06', 3, '2018-10-26 13:55:31', b'0'),
(271, 72, 'ngon', 62, '2018-10-27 10:00:25', 3, '2018-10-27 10:03:03', b'0'),
(272, 72, 'luong bn', 62, '2018-10-27 10:00:28', 3, '2018-10-27 10:03:03', b'0'),
(273, 72, '7.000.000', 1, '2018-10-27 10:03:24', 3, '2018-10-27 10:03:43', b'0'),
(274, 72, 'day cu nghe em co phai ngon khong', 62, '2018-10-27 10:03:33', 3, '2018-10-27 10:03:51', b'0'),
(277, 35, NULL, 1, '2018-10-29 00:06:21', 3, '2018-10-29 12:26:32', b'1'),
(278, 35, NULL, 9, '2018-10-29 14:04:38', 3, '2018-10-29 14:05:43', b'1'),
(279, 35, NULL, 1, '2018-10-29 14:06:05', 3, '2018-10-31 14:57:39', b'1'),
(280, 73, 'thay anh di phuot suot', 11, '2018-10-29 17:02:55', 2, '2018-11-01 09:08:43', b'0'),
(281, 38, NULL, 11, '2018-10-29 17:03:46', 3, '2018-10-29 17:16:08', b'1'),
(285, 38, 'lại đổi nick linh tinh rồi :D', 1, '2018-10-29 17:22:55', 3, '2018-11-01 09:03:33', b'0'),
(286, 35, 'change cái l`', 1, '2018-10-30 09:10:00', 3, '2018-10-31 14:57:39', b'0'),
(287, 72, 'teca goi di phong van chua', 62, '2018-10-30 15:33:50', 3, '2018-10-30 15:33:57', b'0'),
(288, 72, 'chua', 1, '2018-10-30 15:34:13', 3, '2018-10-30 15:34:14', b'0'),
(289, 72, 'moi nop cv thoi', 1, '2018-10-30 15:34:20', 3, '2018-10-30 15:34:22', b'0'),
(290, 72, 'lau the', 62, '2018-10-30 15:34:29', 3, '2018-10-30 15:34:39', b'0'),
(291, 72, 'do nó chuẩn bị cv lâu ý chứ', 1, '2018-10-30 16:04:40', 3, '2018-10-30 16:04:50', b'0'),
(292, 39, 'đợt này e bí quá', 10, '2018-10-31 14:55:31', 3, '2018-10-31 14:57:00', b'0'),
(293, 39, 'e mới quay lại nhật cường', 10, '2018-10-31 14:55:49', 3, '2018-10-31 14:57:00', b'0'),
(294, 39, 'cuối tháng này e trả nhé', 10, '2018-10-31 14:56:49', 3, '2018-10-31 14:57:00', b'0'),
(295, 39, 'ok', 1, '2018-10-31 14:57:04', 1, NULL, b'0'),
(296, 35, 'cục súc vl', 9, '2018-10-31 14:57:49', 3, '2018-10-31 14:58:02', b'0'),
(297, 35, 'dm', 9, '2018-10-31 14:58:09', 3, '2018-10-31 14:58:20', b'0'),
(298, 35, 'thằng đầu khấc kia về rồi đấy anh', 9, '2018-10-31 15:05:01', 3, '2018-10-31 15:13:04', b'0'),
(299, 35, NULL, 1, '2018-10-31 15:22:27', 3, '2018-11-01 09:02:55', b'1'),
(304, 35, NULL, 9, '2018-11-01 09:11:00', 3, '2018-11-01 09:11:07', b'1'),
(308, 33, 'thằng đầu khấc kia sang tuần tao đèo đi làm nhé', 3, '2018-11-10 09:58:07', 3, '2018-11-10 10:23:39', b'0'),
(309, 33, 'tao về hn chỉ để làm việc này thôi', 3, '2018-11-10 09:58:18', 3, '2018-11-10 10:23:39', b'0'),
(310, 33, 'vẫn quanh quẩn cái khu kengnam củ buồi :))', 3, '2018-11-10 10:24:09', 3, '2018-11-10 11:41:16', b'0'),
(311, 33, 'làm ở đâu anh', 1, '2018-11-11 23:46:30', 3, '2018-11-11 23:46:41', b'0'),
(312, 33, 'trung kính', 3, '2018-11-11 23:47:19', 3, '2018-11-11 23:47:29', b'0'),
(313, 33, 'ngay sau PVI', 3, '2018-11-11 23:47:23', 3, '2018-11-11 23:47:29', b'0'),
(314, 33, 'đèo đến đấy xong vứt đấy à', 1, '2018-11-11 23:48:04', 3, '2018-11-11 23:48:20', b'0'),
(315, 33, 'xong đi bộ đến keangnam à', 1, '2018-11-11 23:48:10', 3, '2018-11-11 23:48:20', b'0'),
(316, 33, ':v', 1, '2018-11-11 23:48:11', 3, '2018-11-11 23:48:20', b'0'),
(317, 33, 'đúng cmnr', 3, '2018-11-11 23:48:26', 3, '2018-11-11 23:49:01', b'0'),
(318, 33, 'đi bộ cho đỡ trĩ con ạ', 3, '2018-11-11 23:48:33', 3, '2018-11-11 23:49:01', b'0'),
(319, 33, 'à vâng', 1, '2018-11-11 23:49:10', 3, '2018-11-11 23:49:24', b'0'),
(320, 33, 'anh', 3, '2018-11-18 10:24:28', 3, '2018-11-18 10:24:51', b'0'),
(321, 33, 'ra huy tự chứng kiến cho em với thằng mậu cái', 3, '2018-11-18 10:24:39', 3, '2018-11-18 10:24:51', b'0'),
(322, 33, 'tí nữa', 1, '2018-11-18 10:25:17', 3, '2018-11-18 10:28:52', b'0'),
(323, 33, '10h nhééééééééééééééééé', 1, '2018-11-18 10:29:06', 3, '2018-11-18 10:29:35', b'0'),
(324, 33, 'ssh vào server để deploy là thế nào', 1, '2018-11-18 15:04:14', 3, '2018-11-18 15:05:25', b'0'),
(327, 33, 'đang đâu đấy', 3, '2018-11-18 17:49:53', 3, '2018-11-18 17:49:59', b'0'),
(328, 33, 'dcm thằng kia ra ngay võ thị sáu', 3, '2018-11-18 17:49:55', 3, '2018-11-18 17:49:59', b'0'),
(329, 33, 'nhanh', 3, '2018-11-18 17:56:28', 3, '2018-11-18 17:56:43', b'0'),
(330, 33, 'đang cho con đi tiêm', 1, '2018-11-18 17:57:00', 3, '2018-11-18 17:57:17', b'0'),
(331, 33, 'mấy giờ xong', 3, '2018-11-18 18:01:52', 3, '2018-11-18 18:03:33', b'0'),
(332, 33, 'ít nhất là 5h', 1, '2018-11-18 18:03:39', 3, '2018-11-18 18:04:31', b'0'),
(334, 72, 'con thảo nhà a mới đi pv ở teca hôm qua', 1, '2018-11-20 23:05:17', 3, '2018-11-20 23:05:31', b'0'),
(335, 72, 'sơn pv', 1, '2018-11-20 23:05:21', 3, '2018-11-20 23:05:31', b'0'),
(336, 72, '4 củ', 1, '2018-11-20 23:05:23', 3, '2018-11-20 23:05:31', b'0'),
(338, 72, 'sao thấp thế', 62, '2018-11-20 23:05:53', 3, '2018-11-20 23:12:24', b'0'),
(339, 72, 'bảo thái chưa', 62, '2018-11-20 23:14:56', 3, '2018-11-25 00:20:32', b'0'),
(340, 72, 'roi`', 1, '2018-11-27 23:49:52', 3, '2018-11-27 23:49:52', b'0'),
(341, 72, 'dang mail lai a phong', 1, '2018-11-27 23:50:32', 3, '2018-11-28 01:15:59', b'0'),
(342, 72, 'có kết quả chưa', 62, '2018-11-29 00:03:10', 3, '2018-11-29 00:03:49', b'0'),
(343, 72, 'trúng rồi', 1, '2018-11-29 00:12:37', 3, '2018-11-29 00:12:37', b'0'),
(344, 72, '2/12 đi làm', 1, '2018-11-29 00:12:42', 3, '2018-11-29 00:12:42', b'0'),
(345, 72, 'ngon', 62, '2018-11-29 00:12:54', 3, '2018-11-29 00:12:58', b'0'),
(355, 42, 'mẹ bảo sang tuần cho lạc lên cụ cai sữa đấy', 2, '2018-11-29 00:35:09', 2, '2018-11-29 00:35:09', b'0'),
(356, 33, 'dm mai đi làm không', 3, '2018-11-29 23:27:34', 3, '2018-11-29 23:32:41', b'0'),
(359, 35, 'a sắp về', 9, '2018-11-30 00:33:04', 3, '2018-11-30 00:33:04', b'0'),
(360, 35, 'a sẽ dạy dỗ 2 chú bài học tử tế', 9, '2018-11-30 00:33:29', 3, '2018-11-30 00:33:29', b'0'),
(361, 72, 'insert du lieu tu excel vao csdl kieu gi', 62, '2018-11-30 21:36:20', 3, '2018-11-30 21:36:27', b'0'),
(362, 33, 'láo vcl', 3, '2018-12-01 00:22:01', 3, '2018-12-01 11:30:25', b'0'),
(363, 72, 'thì dùng chính excel viết câu lệnh sql rồi phệt vào thôi', 1, '2018-12-01 11:27:02', 3, '2018-12-01 11:27:02', b'0'),
(364, 72, 'thế hả', 62, '2018-12-01 11:28:00', 3, '2018-12-01 11:28:55', b'0'),
(375, 33, 'láo cl', 1, '2018-12-04 00:33:29', 3, '2018-12-05 23:39:16', b'0'),
(378, 33, 'tự khôngggg?????', 3, '2018-12-09 14:54:09', 3, '2018-12-09 14:54:17', b'0'),
(379, 33, 'buồn ngủ lắm', 1, '2018-12-09 14:54:30', 3, '2018-12-09 14:54:30', b'0'),
(380, 33, 'tối đi anh', 1, '2018-12-09 14:54:33', 3, '2018-12-09 14:54:33', b'0'),
(382, 72, 'thấy bảo hồng sắp nghỉ à', 62, '2018-12-09 14:55:21', 3, '2018-12-09 14:55:21', b'0'),
(383, 72, 'uh', 1, '2018-12-09 14:55:41', 3, '2018-12-09 14:55:42', b'0'),
(384, 72, 'bảo ở đây OT nhiều mà lương thấp', 1, '2018-12-09 14:55:52', 3, '2018-12-09 14:55:53', b'0'),
(385, 72, 'không có tiền OT', 1, '2018-12-09 14:55:56', 3, '2018-12-09 14:55:56', b'0'),
(386, 72, 'định biến', 1, '2018-12-09 14:56:00', 3, '2018-12-09 14:56:00', b'0'),
(387, 72, 'a đang suggest cho nó sang VNPT', 1, '2018-12-09 14:56:09', 3, '2018-12-09 14:56:09', b'0'),
(388, 33, 'tối cc', 3, '2018-12-09 14:56:26', 3, '2018-12-09 14:57:22', b'0'),
(389, 33, 'ngay', 3, '2018-12-09 14:56:28', 3, '2018-12-09 14:57:22', b'0'),
(390, 33, 'có anh sơn đang chờ', 3, '2018-12-09 14:56:34', 3, '2018-12-09 14:57:22', b'0'),
(391, 33, 'ra ngay', 3, '2018-12-09 14:56:40', 3, '2018-12-09 14:57:22', b'0'),
(394, 33, 'khẩn trương', 3, '2018-12-09 14:57:07', 3, '2018-12-09 14:57:22', b'0'),
(395, 33, 'cút', 3, '2018-12-09 14:57:27', 3, '2018-12-09 14:57:27', b'0'),
(396, 33, 'ngay', 3, '2018-12-09 14:57:31', 3, '2018-12-09 14:57:31', b'0'),
(397, 72, 'ngon', 62, '2018-12-09 20:40:43', 3, '2018-12-09 20:41:36', b'0'),
(400, 72, 'sang đây có khi ae mình lại hội ngộ ý chứ', 62, '2018-12-09 23:46:32', 3, '2018-12-09 23:47:03', b'0'),
(401, 72, 'a thì sang tết mới tính chuyện này', 1, '2018-12-09 23:47:34', 3, '2018-12-09 23:47:34', b'0'),
(402, 72, 'giờ sang chết đói', 1, '2018-12-09 23:47:43', 3, '2018-12-09 23:47:44', b'0'),
(403, 72, 'uh', 62, '2018-12-09 23:48:03', 3, '2018-12-09 23:48:04', b'0'),
(404, 72, 'khi nào sang bảo e', 62, '2018-12-09 23:49:34', 3, '2018-12-09 23:49:35', b'0'),
(405, 72, 'e gửi cv cho', 62, '2018-12-09 23:49:38', 3, '2018-12-09 23:49:39', b'0');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `password` varchar(50) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `alias` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `avatar_url` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `current_connect` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `password`, `email`, `alias`, `phone`, `gender`, `avatar_url`, `status`, `current_connect`) VALUES
(1, 'ming.hieu.1312', 'c4ca4238a0b923820dcc509a6f75849b', 'hieuami@gmail.com', 'Ming Hieu', '0904694872', 1, 'images/1.jpg', 1, 62),
(2, 'thuyhoa.pham.313', 'c4ca4238a0b923820dcc509a6f75849b', 'thuyhoapham91@gmail.com', 'Thuy Hoa Pham', '01693301691', 0, 'images/2.jpg', 1, 6),
(3, 'vutr47', 'c4ca4238a0b923820dcc509a6f75849b', 'elderaine@gmail.com', 'Phuong Khanh', NULL, 1, 'images/3.jpg', 1, 1),
(5, 'elderaine', 'c4ca4238a0b923820dcc509a6f75849b', 'vutran47@gmail.com', 'Vu Tran', '0947101987', 1, 'images/5.jpg', 1, NULL),
(6, 'nguyenthanh.thao.73', 'c4ca4238a0b923820dcc509a6f75849b', 'thanhthao8495@gmail.com', 'Thanh Thao Nguyen', '01639925591', 0, 'images/6.jpg', 1, 1),
(7, 'dothanhnam87', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Do Nam', '0976684616', 1, 'images/7.jpg', 1, NULL),
(8, 'thanhpt.0102', 'c4ca4238a0b923820dcc509a6f75849b', 'thanhpt@tecapro.com.vn', 'Phạm Trung Thành', '01639579813', 1, 'images/8.jpg', 1, NULL),
(9, 'phan.son.31', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Phan Son', '0983916346', 1, 'images/9.jpg', 1, 1),
(10, 'johnvunam', 'c4ca4238a0b923820dcc509a6f75849b', 'namvd@onenet.vn', 'John Vu Nam', '01662355402', 1, 'images/10.jpg', 1, NULL),
(11, 'hoang.huong.7503314', 'c4ca4238a0b923820dcc509a6f75849b', 'huonght4@fsoft.com.vn', 'Hoàng Hương', NULL, 1, 'images/11.jpg', 1, NULL),
(12, 'tientrungbk', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Trung Nguyen Tien', '0984833201', 1, 'images/12.jpg', 1, NULL),
(13, 'kuonglv', 'c4ca4238a0b923820dcc509a6f75849b', 'cuonglv8@fpt.com.vn', 'Le Bao Nam', '0942066299', 1, 'images/13.jpg', 1, NULL),
(17, 'tovan.ba', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'To Van Ba', '0966669333', 1, 'images/17.jpg', 1, NULL),
(18, 'vuduc.ba', 'c4ca4238a0b923820dcc509a6f75849b', 'bavd5@fpt.com.vn', 'Vu Duc Ba', '0975042378', 1, 'images/18.jpg', 1, NULL),
(29, 'hadacduong', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Ha Dac Duong', NULL, 1, 'images/29.jpg', 1, NULL),
(30, 'ngocminh.hoang.397', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Hoàng Ngọc Minh', '01239310618', 1, 'images/30.jpg', 1, NULL),
(31, 'QVu.Trieu', 'c4ca4238a0b923820dcc509a6f75849b', 'vutq5@fpt.com.vn', 'Triệu Quang Vũ', '0989932398', 1, 'images/31.jpg', 1, NULL),
(32, 'namcvi', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Nam Cung', '0934435050', 1, 'images/32.jpg', 1, NULL),
(34, 'sutet1992', 'c4ca4238a0b923820dcc509a6f75849b', 'anhpk@tecapro.com.vn', 'Kim Anh Bé', NULL, 0, 'images/34.jpg', 1, NULL),
(42, 'minhtuyen.ngo.96', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Tuyen Ngo', '0973654331', 1, 'images/42.jpg', 1, NULL),
(43, 'hanh.su.9212', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Hanh su', '0902557728', 0, 'images/43.jpg', 1, NULL),
(44, 'hakhaccuong', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Cường Khắc Hà', '0985090099', 1, 'images/2Q==.jpg', 1, NULL),
(45, 'nguyen.quang.mui.2912', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Bảo Bảo Vui Vẻ', NULL, 1, 'images/45.jpg', 1, NULL),
(46, 'NamDaiKa686', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Nguyễn Nam', '0971303133', 1, 'images/2Q==.jpg', 0, NULL),
(47, 'tuan.pro.583', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Tuan Tit', NULL, 1, 'images/47.jpg', 1, NULL),
(48, 'khoa.nt1988', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Nguyễn Thanh Khoa', '0945970090', 1, 'images/48.jpg', 1, NULL),
(49, 'dvtruong.bk', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Đặng Văn Trường', '01695462258', 1, 'images/2Q==.jpg', 1, NULL),
(50, 'dung.thuy.33', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Thùy Dung', '0984248833', 0, 'images/50.jpg', 1, NULL),
(51, 'hiep.bar', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Nguyễn Tiến Hiệp', '0983756601', 1, 'images/51.jpg', 1, NULL),
(52, 'HNHNTD', 'c4ca4238a0b923820dcc509a6f75849b', 'diemdt@tecapro.com.vn', 'Boe Deng', '0965578631', 0, 'images/52.jpg', 1, NULL),
(53, 'thuyan.luong.3', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'An Thúy Lương', '01659899834', 0, 'images/9k=.jpg', 1, NULL),
(54, 'huylq2988', 'c4ca4238a0b923820dcc509a6f75849b', 'huylq@onenet.vn', 'Hehe Huy', '0936102988', 1, 'images/54.jpg', 1, NULL),
(55, 'chieunm', 'c4ca4238a0b923820dcc509a6f75849b', 'chieunm@onenet.vn', 'Nguyễn Mạnh Chiều', '0983449219', 1, 'images/55.jpg', 1, NULL),
(56, 'xuanhuy.nghiem', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Nghiêm Xuân Huy', '0977778735', 1, 'images/56.jpg', 1, NULL),
(58, 'nowforever.coppers', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Nguyễn Văn Đồng', NULL, 1, 'images/58.jpg', 1, NULL),
(59, 'trinhvan.tiendung', 'c4ca4238a0b923820dcc509a6f75849b', 'dungtvt1@fsoft.com.vn', 'Trịnh Văn Tiến Dũng', NULL, 1, 'images/59.jpg', 1, NULL),
(60, 'sontung304', 'c4ca4238a0b923820dcc509a6f75849b', 'tungns@tecapro.com.vn', 'Sơn Tùng', '0968121151', 1, 'images/60.jpg', 1, NULL),
(61, 'codon.cungcongio', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Codon Cungcongio', '01688748703', 1, 'images/61.jpg', 1, NULL),
(62, 'nga.dech', 'c4ca4238a0b923820dcc509a6f75849b', 'ngadtt6@fsoft.com.vn', 'Nga Đếch', '0985704265', 0, 'images/62.jpg', 1, 1),
(63, 'guyloselove', 'c4ca4238a0b923820dcc509a6f75849b', 'quynhnh@tecapro.com.vn', 'Quynh Nguyen', '0988632841', 1, 'images/63.jpg', 1, NULL),
(74, 'junny.an.14', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'An An', NULL, 0, 'images/9k=.jpg', 1, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `conversion`
--
ALTER TABLE `conversion`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `conversion_users`
--
ALTER TABLE `conversion_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `conversion_users_ibfk_1` (`conversion_id`),
  ADD KEY `conversion_users_ibfk_2` (`user_id`);

--
-- Indexes for table `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `conversion_ibfk_2` (`conversion_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_ibfk_1` (`current_connect`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `conversion`
--
ALTER TABLE `conversion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `conversion_users`
--
ALTER TABLE `conversion_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT for table `message`
--
ALTER TABLE `message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=407;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `conversion_users`
--
ALTER TABLE `conversion_users`
  ADD CONSTRAINT `conversion_users_ibfk_1` FOREIGN KEY (`conversion_id`) REFERENCES `conversion` (`id`),
  ADD CONSTRAINT `conversion_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `message_ibfk_2` FOREIGN KEY (`conversion_id`) REFERENCES `conversion` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`current_connect`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
