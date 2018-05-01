-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 01, 2018 at 06:31 PM
-- Server version: 10.1.31-MariaDB
-- PHP Version: 7.2.3

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `createConversion` (IN `user_id` INT(11), IN `friendid` INT(11))  NO SQL
INSERT INTO `conversion`(`user1_id`, `user2_id`) 
SELECT * FROM (SELECT user_id, friendid) AS tmp
WHERE NOT EXISTS (
    SELECT * FROM `conversion` WHERE (user1_id = user_id AND user2_id=friendid) or (user1_id = friendid AND user2_id=user1_id)
) LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `displayMessage` (IN `user_id` INT(11), IN `friend_id` INT(11))  NO SQL
SELECT
    id,
    conversion_id,
    message_content,
    sender_id,
    NAME,
    alias,
    TIME,
    CASE  
    	WHEN differ=0 THEN date_format(time, '%H:%i') 
        WHEN differ=1 THEN date_format(time, 'Hôm qua, %H:%i')
        WHEN differ < 7 and differ > 1 THEN date_format(time, '%W %H:%i')
        WHEN yeardiff = 0 THEN date_format(time, '%d %M %H:%i')
        ELSE date_format(time, '%d %M %Y %H:%i')
	END as time,
    message_color
FROM
    (
    SELECT
        m.id,
        m.conversion_id,
        m.message_content,
        m.sender_id,
        m.time,
        DATEDIFF(NOW(), m.time) differ,
        YEAR(time) - YEAR(now()) as yeardiff,
        u.name,
        u.alias,
        c.message_color
    FROM
        `message` m,
        `conversion` c,
        `users` u
    WHERE
        m.conversion_id = c.id AND 
        m.sender_id = u.id AND `conversion_id` IN(
        SELECT
            id
        FROM
            `conversion`
        WHERE
            (`user1_id` = user_id AND `user2_id` = friend_id) OR(`user1_id` = friend_id AND `user2_id` = user_id)
    )
ORDER BY
    m.time) AS CONV$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertMessage` (IN `user_id` INT(11), IN `message` VARCHAR(20000) CHARSET utf8, IN `friendid` INT(11))  NO SQL
INSERT INTO `message`(`conversion_id`, `message_content`, `sender_id`, `time`) 
    SELECT `id`, message, user_id, now() FROM `conversion` WHERE (`user1_id`=user_id AND `user2_id`=friendid) or (`user1_id`=friendid AND `user2_id`=user_id)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUser` (IN `usr` VARCHAR(255) CHARSET utf8, IN `pwd` VARCHAR(50), IN `eml` VARCHAR(255) CHARSET utf8, IN `ali` VARCHAR(255) CHARSET utf8, IN `pho` VARCHAR(15))  NO SQL
INSERT INTO `users`(`name`, `password`, `email`, `alias`, `phone`) VALUES (usr, pwd, eml, ali, pho)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchUsers` (IN `uid` INT(11))  NO SQL
SELECT
        c.user1_id+c.user2_id - uid as id, # receiver_id
    	m.sender_id as last_sender_id,
        u.`name`,
        u.`email`,
        u.`alias`,
        u.`phone`,
        m.message_content,
    	case 
    	when diff = 0 THEN date_format(tmp.time, '%H:%i')
    	when diff < 7 THEN date_format(tmp.time, '%W')
    	else date_format(tmp.time, '%d %M')
    	END as time, 
    	tmp.time as realtime
    FROM
        (
            SELECT
            conversion_id,
            sender_id,
            MAX(id) AS id, 
            max(time) as time, 
            DATEDIFF(now(), max(time)) as diff
            FROM message
            GROUP BY conversion_id
        ) AS tmp
    INNER JOIN conversion c ON c.id = tmp.conversion_id
    INNER JOIN message m ON tmp.id = m.id and tmp.time=m.time
	INNER JOIN users u ON u.id = c.user1_id+c.user2_id - uid    
    WHERE (c.user1_id = uid OR c.user2_id = uid)
    ORDER BY tmp.time DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchUsers_bak` (IN `uid` INT(11), IN `txt` TEXT)  NO SQL
SELECT * FROM 
(
    SELECT
        c.user1_id+c.user2_id - uid as id, # receiver_id
    	m.sender_id, # last_sender_id,
        u.`name`,
    	u.`email`,
        u.`alias`,
    	u.`phone`,
        m.message_content,
    	case 
    	when diff = 0 THEN date_format(tmp.time, '%H:%i')
    	when diff < 7 THEN date_format(tmp.time, '%W')
    	else date_format(tmp.time, '%d %M')
    	END as time
    FROM
        (
        SELECT
            conversion_id,
			sender_id,
            MAX(id) AS id, 
            max(time) as time, 
        	DATEDIFF(now(), max(time)) as diff
        FROM message
        GROUP BY conversion_id
        ORDER BY TIME DESC
    ) AS tmp
    LEFT JOIN conversion c ON c.id = tmp.conversion_id
    LEFT JOIN message m ON tmp.id = m.id
	LEFT JOIN users u ON u.id = c.user1_id+c.user2_id - uid
    WHERE c.user1_id = uid OR c.user2_id = uid
    AND (
        u.`name` like concat('%',txt,'%')
        or u.`alias` like concat('%',txt,'%')
        or u.`email` like concat('%',txt,'%')
        or u.`phone`=txt
    )
    ORDER BY m.time DESC
) as t1
UNION
(
select
    u.`id`,
    null,
    u.`name`,
    u.`email`,
    u.`alias`,
    u.`phone`,
    '' as `message_content`,
    '' as time
from users u
where u.`id` not in (
    SELECT
        `user1_id` + `user2_id` - uid
    FROM
        `message` m,
        `conversion` c,
        `users` u
    WHERE
        m.`conversion_id` = c.`id`
        AND u.id = `user1_id` + `user2_id` - uid
        AND (c.`user1_id` = uid OR c.`user2_id` = uid)
    )
    and u.`id` != uid
    AND (
        u.`name` like concat('%',txt,'%')
        or u.`alias` like concat('%',txt,'%')
        or u.`email` like concat('%',txt,'%')
        or u.`phone`=txt
    )
)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `conversion`
--

CREATE TABLE `conversion` (
  `id` int(11) NOT NULL,
  `user1_id` int(11) DEFAULT NULL,
  `user2_id` int(11) DEFAULT NULL,
  `message_color` int(11) DEFAULT '34047'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `conversion`
--

INSERT INTO `conversion` (`id`, `user1_id`, `user2_id`, `message_color`) VALUES
(25, 1, 2, 6797416),
(31, 1, 8, 34047),
(32, 1, 6, 34047),
(33, 1, 3, 7751423),
(34, 1, 5, 4505287),
(35, 9, 1, 34047),
(37, 1, 17, 34047),
(38, 1, 11, 34047),
(39, 1, 10, 34047),
(40, 1, 29, 34047),
(41, 1, 12, 34047),
(42, 6, 2, 34047),
(43, 1, 34, 34047);

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE `message` (
  `id` int(11) NOT NULL,
  `conversion_id` int(11) DEFAULT NULL,
  `message_content` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `sender_id` int(11) DEFAULT NULL,
  `time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `message`
--

INSERT INTO `message` (`id`, `conversion_id`, `message_content`, `sender_id`, `time`) VALUES
(15, 25, 'toi a ve muon', 1, '2018-04-16 16:43:13'),
(16, 25, 'danh aoe', 1, '2018-04-17 16:43:15'),
(17, 25, 'okkkkkkkkk', 2, '2018-04-17 16:43:29'),
(20, 25, 'nho ve som', 2, '2018-04-17 16:47:18'),
(23, 25, 'okkkkk', 1, '2018-04-17 16:48:10'),
(27, 25, 'cho lac di vien chua', 1, '2018-04-18 08:59:52'),
(28, 31, 'chu tach cmnr =))', 1, '2018-04-18 09:00:31'),
(29, 32, 'toi co ve lo duc khong', 1, '2018-04-18 09:00:40'),
(32, 34, 'luon khonggggggggggg', 1, '2018-04-18 09:00:57'),
(33, 25, 'dang o vien roi nhe', 2, '2018-04-18 09:48:51'),
(34, 25, 'vua khi dung xong', 2, '2018-04-18 09:48:56'),
(35, 25, 'khí dung', 2, '2018-04-18 09:49:04'),
(37, 33, 'fifaaaaaaaaaaa', 1, '2018-04-18 10:30:40'),
(38, 25, 'ba ve chua', 1, '2018-04-18 11:20:28'),
(39, 25, 'alo', 1, '2018-04-18 11:22:05'),
(40, 33, 'dang o sg', 3, '2018-04-18 11:22:51'),
(41, 35, 'fifa de', 9, '2018-04-18 11:26:32'),
(42, 35, 'goi deo co song deo goi duoc', 9, '2018-04-18 11:26:40'),
(43, 25, 'bo no an com chua', 1, '2018-04-18 12:29:07'),
(44, 25, 'roi` nhe', 2, '2018-04-18 12:29:38'),
(45, 25, 'vua xong', 2, '2018-04-18 12:29:40'),
(57, 25, 'đang thi bánh trôi nước', 1, '2018-04-18 15:57:57'),
(58, 25, 'Theo quy định của hợp đồng, Bảo hiểm đồng ý thanh toán những chi phí khám và thuốc hợp lý, cần thiết về mặt y tế, theo chỉ định của bác sĩ điều trị, phát sinh khi người được bảo hiểm phải điều trị bệnh mà việc điều trị được bảo hiểm, không thanh toán chi phí mua mỹ phẩm, thực phẩm chức năng, vật tư y tế. Do đó rất tiếc bảo hiểm từ chối thanh toán các chi phí sau vì không thuộc phạm vi bảo hiểm: - Gạc phãu thuật bằng 7.800 vnd - Mỹ phẩm \'\' Avene - Ciacalfate \'\' bằng 409.882 vnd đồng thời sản phẩm được kê trên phiếu tư vấn, không phải đơn thuốc.', 1, '2018-04-18 16:53:56'),
(59, 25, '-          Chính sách trẻ em tại khách sạn: Miễn phí cho 2 trẻ em dưới 12 tuổi ngủ chung phòng.  Ăn sáng phụ thu theo chiều cao. Dưới 1m miễn phí. Từ 1m đến 1.2m tính 60k. Từ 1.3m trở lên tính 120k  -          Extra bed: 300k/giường.  -          Công ty chỉ tài trợ chi phí Gala Dinner cho các FISer và người thân là Vợ/chồng và con. Trong TH là CB đưa bố mẹ, anh chị em đi nghỉ mát cùng, vui lòng confirm lại giúp em về số lượng tham gia. BTC sẽ tính phí tương đương 500k/người.', 1, '2018-04-18 17:02:40'),
(60, 25, 'abc', 1, '2018-04-19 08:34:45'),
(61, 25, '???', 2, '2018-04-19 08:35:33'),
(62, 25, ':3', 1, '2018-04-19 08:35:53'),
(64, 37, 'uong nuoc de', 1, '2018-04-19 09:13:04'),
(65, 38, 'dao nay lam an the nao roi', 1, '2018-04-19 10:17:06'),
(67, 31, 'chan vai dai', 1, '2018-04-19 10:55:33'),
(68, 32, 'a', 1, '2018-04-19 10:56:41'),
(70, 34, 'lam an the nao roi', 1, '2018-04-19 11:08:52'),
(71, 37, 'toi di duoc khong', 1, '2018-04-19 11:12:11'),
(72, 33, 'lanh qua\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'', 1, '2018-04-19 11:36:17'),
(73, 39, 'alo', 1, '2018-04-19 11:43:46'),
(74, 39, 'co tien chua', 1, '2018-04-19 11:43:48'),
(75, 40, 'dao nay lam an the nao roi`', 1, '2018-04-19 11:44:00'),
(76, 41, 'trung bua', 1, '2018-04-19 11:45:32'),
(77, 25, 'mẹ mày', 1, '2018-04-19 15:01:42'),
(78, 31, 'vang e cung du doan tu truoc roi`', 8, '2018-04-20 09:08:28'),
(79, 31, '=))', 8, '2018-04-20 09:09:41'),
(80, 25, 'lac tiem chua', 1, '2018-04-20 09:24:39'),
(81, 25, 'tiem roi', 2, '2018-04-20 09:24:54'),
(82, 25, 'dang ngu nhe', 2, '2018-04-20 09:24:56'),
(83, 25, 'okkkkkkkkkkkkkkkk', 1, '2018-04-20 09:31:40'),
(84, 25, 'mẹ mày mang ipad vào viện à', 1, '2018-04-20 14:02:30'),
(85, 25, 'lac dang kham them o phong kham ngoai nhe', 2, '2018-04-20 16:51:02'),
(86, 25, 'okkkkkkkkkkk', 2, '2018-04-20 16:57:19'),
(87, 25, 'ke cai me', 1, '2018-04-20 16:58:09'),
(88, 32, 'co\'', 6, '2018-04-20 17:08:46'),
(89, 42, 'lac hom nay di tiem co khoc khong', 6, '2018-04-20 17:09:53'),
(90, 42, 'khong', 2, '2018-04-20 17:10:08'),
(91, 42, 'hom nay chi cho no di kham ngoai`', 2, '2018-04-20 17:10:13'),
(92, 25, 'xin chuyen vien chua', 1, '2018-04-23 09:06:18'),
(93, 25, 'đang bảo nó rồi', 2, '2018-04-23 09:14:04'),
(94, 25, 'okkkkkkkkkkkkkkkkkkkkkk', 1, '2018-04-23 09:14:20'),
(95, 25, 'lllllll', 2, '2018-04-23 09:14:27'),
(96, 25, '?????', 1, '2018-04-23 09:17:58'),
(97, 25, 'me may`', 1, '2018-04-23 10:57:05'),
(98, 25, 'xin chuyen vien chua', 1, '2018-04-23 10:57:13'),
(99, 25, 've nha roi`', 2, '2018-04-26 09:56:17'),
(110, 25, 'okkkkk', 1, '2018-04-30 22:57:34');

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
  `status` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `password`, `email`, `alias`, `phone`, `status`) VALUES
(1, 'ming.hieu.1312', 'c4ca4238a0b923820dcc509a6f75849b', 'hieunm1987@gmail.com', 'Ming Hieu', '0978054315', 1),
(2, 'thuyhoa.pham.313', 'c4ca4238a0b923820dcc509a6f75849b', 'thuyhoapham91@gmail.com', 'Thuy Hoa Pham', '01693301691', 1),
(3, 'elderaine', 'c4ca4238a0b923820dcc509a6f75849b', 'elderaine@gmail.com', 'Phuong Khanh', NULL, 1),
(5, 'vutran47', 'c4ca4238a0b923820dcc509a6f75849b', 'vutran47@gmail.com', 'Vu Tran', '0947101987', 1),
(6, 'nguyenthanh.thao.73', 'c4ca4238a0b923820dcc509a6f75849b', 'thanhthao8495@gmail.com', 'Thanh Thao Nguyen', '01639925591', 1),
(7, 'dothanhnam87', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Do Nam', '0976684616', 1),
(8, 'thanhpt.0102', 'c4ca4238a0b923820dcc509a6f75849b', 'thanhpt@tecapro.com.vn', 'Phạm Trung Thành', '01639579813', 1),
(9, 'phan.son.31', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Phan Son', '0983916346', 1),
(10, 'johnvunam', 'c4ca4238a0b923820dcc509a6f75849b', 'namvd@onenet.vn', 'John Vu Nam', '01662355402', 1),
(11, 'hoang.huong.7503314', 'c4ca4238a0b923820dcc509a6f75849b', 'huonght4@fsoft.com.vn', 'Hoang Huong', NULL, 1),
(12, 'tientrungbk', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Trung Nguyen Tien', '0984833201', 1),
(13, 'kuonglv', 'c4ca4238a0b923820dcc509a6f75849b', 'cuonglv8@fpt.com.vn', 'Le Bao Nam', '0942066299', 1),
(17, 'tovan.ba', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'To Van Ba', '0966669333', 1),
(18, 'vuduc.ba', 'c4ca4238a0b923820dcc509a6f75849b', 'bavd5@fpt.com.vn', 'Vu Duc Ba', '0975042378', 1),
(29, 'hadacduong', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Ha Dac Duong', NULL, 1),
(30, 'ngocminh.hoang.397', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Hoàng Ngọc Minh', '01239310618', 1),
(31, 'QVu.Trieu', 'c4ca4238a0b923820dcc509a6f75849b', 'vutq5@fpt.com.vn', 'Triệu Quang Vũ', '0989932398', 1),
(32, 'namcvi', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Nam Cung', '0934435050', 1),
(34, 'sutet1992', 'c4ca4238a0b923820dcc509a6f75849b', 'anhpk@tecapro.com.vn', 'Kim Anh Bé', '', 1),
(42, 'minhtuyen.ngo.96', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Tuyen Ngo', NULL, 1),
(43, 'hanh.su.9212', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Hanh su', '0902557728', 1),
(44, 'hakhaccuong', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Cường Khắc Hà', '0985090099', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `conversion`
--
ALTER TABLE `conversion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user1_id` (`user1_id`),
  ADD KEY `user2_id` (`user2_id`);

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
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `conversion`
--
ALTER TABLE `conversion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `message`
--
ALTER TABLE `message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=142;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `conversion`
--
ALTER TABLE `conversion`
  ADD CONSTRAINT `conversion_ibfk_1` FOREIGN KEY (`user1_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `conversion_ibfk_2` FOREIGN KEY (`user2_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `message_ibfk_2` FOREIGN KEY (`conversion_id`) REFERENCES `conversion` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
