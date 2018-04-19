-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 19, 2018 at 05:08 PM
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
INSERT INTO `conversions_list`(`user1_id`, `user2_id`) 
SELECT * FROM (SELECT user_id, friendid) AS tmp
WHERE NOT EXISTS (
    SELECT * FROM conversions_list WHERE (user1_id = user_id AND user2_id=friendid) or (user1_id = friendid AND user2_id=user1_id)
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
    differ,
    CASE  
    	WHEN differ=0 THEN date_format(time, '%H:%i') 
        WHEN differ=1 THEN date_format(time, 'Hôm qua, %H:%i')
        WHEN differ < 7 and differ > 1 THEN CONCAT('Thứ ', DAYOFWEEK(time), date_format(time, ', %H:%i'))
                ELSE time
	END as time
FROM
    (
    SELECT
        c.id,
        c.conversion_id,
        c.message_content,
        c.sender_id,
        c.time,
        DATEDIFF(NOW(), c.time) differ,
        u.name,
        u.alias
    FROM
        `conversion` c,
        users u
    WHERE
        c.sender_id = u.id AND `conversion_id` IN(
        SELECT
            id
        FROM
            `conversions_list`
        WHERE
            (`user1_id` = user_id AND `user2_id` = friend_id) OR(`user1_id` = friend_id AND `user2_id` = user_id)
    )
ORDER BY
    c.time) AS CONV$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertMessage` (IN `user_id` INT(11), IN `message` VARCHAR(20000) CHARSET utf8, IN `friendid` INT(11))  NO SQL
INSERT INTO `conversion`(`conversion_id`, `message_content`, `sender_id`, `time`) 
    SELECT `id`, message, user_id, now() FROM `conversions_list` WHERE (`user1_id`=user_id AND `user2_id`=friendid) or (`user1_id`=friendid AND `user2_id`=user_id)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUser` (IN `usr` VARCHAR(255) CHARSET utf8, IN `pwd` VARCHAR(50), IN `eml` VARCHAR(255) CHARSET utf8, IN `ali` VARCHAR(255) CHARSET utf8, IN `pho` VARCHAR(15))  NO SQL
INSERT INTO `users`(`name`, `password`, `email`, `alias`, `phone`) VALUES (usr, pwd, eml, ali, pho)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchUsers` (IN `uid` INT(11))  NO SQL
SELECT * FROM 
(
    SELECT
        `user1_id` + `user2_id` - uid AS user_id,
        u.`alias`
    FROM
        conversion c,
        conversions_list l,
        users u
    WHERE
        c.`conversion_id` = l.`id`
        AND u.id = `user1_id` + `user2_id` - uid
        AND (l.`user1_id` = uid OR l.`user2_id` = uid)
    GROUP BY user_id
    ORDER BY MAX(c.`time`) DESC
) as t1
UNION
(
select u.`id`, u.alias
from users u
where u.`id` not in (
    SELECT
        `user1_id` + `user2_id` - uid
    FROM
        conversion c,
        conversions_list l
    WHERE
        c.`conversion_id` = l.`id`
        AND (l.`user1_id` = uid OR l.`user2_id` = uid)
    )
    and u.`id` != uid
)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `conversion`
--

CREATE TABLE `conversion` (
  `id` int(11) NOT NULL,
  `conversion_id` int(11) DEFAULT NULL,
  `message_content` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `sender_id` int(11) DEFAULT NULL,
  `time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `conversion`
--

INSERT INTO `conversion` (`id`, `conversion_id`, `message_content`, `sender_id`, `time`) VALUES
(14, 25, 'me may', 1, '2018-04-16 15:31:54'),
(15, 25, 'toi a ve muon', 1, '2018-04-17 16:43:13'),
(16, 25, 'danh aoe', 1, '2018-04-17 16:43:15'),
(17, 25, 'okkkkkkkkk', 2, '2018-04-17 16:43:29'),
(20, 25, 'nho ve som', 2, '2018-04-17 16:47:18'),
(23, 25, 'okkkkk', 1, '2018-04-17 16:48:10'),
(26, 25, 'me may`', 1, '2018-04-18 08:59:49'),
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
(61, 25, '123', 2, '2018-04-19 08:35:33'),
(62, 25, '456', 1, '2018-04-19 08:35:53'),
(63, 36, 'uong nuoc de<br />', 2, '2018-04-19 09:12:27'),
(64, 37, 'uong nuoc de<br />', 1, '2018-04-19 09:13:04'),
(65, 38, 'dao nay lam an the nao roi<br />', 1, '2018-04-19 10:17:06'),
(66, 25, 'me may`<br />', 1, '2018-04-19 10:39:01'),
(67, 31, 'chan vai dai', 1, '2018-04-19 10:55:33'),
(68, 32, 'a', 1, '2018-04-19 10:56:41'),
(69, 25, 'me may`', 1, '2018-04-19 11:00:05'),
(70, 34, 'lam an the nao roi', 1, '2018-04-19 11:08:52'),
(71, 37, 'toi di duoc khong', 1, '2018-04-19 11:12:11'),
(72, 33, 'lanh qua\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'', 1, '2018-04-19 11:36:17'),
(73, 39, 'alo', 1, '2018-04-19 11:43:46'),
(74, 39, 'co tien chua', 1, '2018-04-19 11:43:48'),
(75, 40, 'dao nay lam an the nao roi`', 1, '2018-04-19 11:44:00'),
(76, 41, 'trung bua', 1, '2018-04-19 11:45:32'),
(77, 31, 'e biet ma', 8, '2018-04-19 21:36:50'),
(78, 31, 'khong bat ngo', 8, '2018-04-19 21:36:53'),
(79, 42, 'NGU!!!!!!!', 9, '2018-04-19 22:04:30');

-- --------------------------------------------------------

--
-- Table structure for table `conversions_list`
--

CREATE TABLE `conversions_list` (
  `id` int(11) NOT NULL,
  `user1_id` int(11) DEFAULT NULL,
  `user2_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `conversions_list`
--

INSERT INTO `conversions_list` (`id`, `user1_id`, `user2_id`) VALUES
(25, 1, 2),
(31, 1, 8),
(32, 1, 6),
(33, 1, 3),
(34, 1, 5),
(35, 9, 1),
(36, 2, 17),
(37, 1, 17),
(38, 1, 11),
(39, 1, 10),
(40, 1, 29),
(41, 1, 12),
(42, 9, 3);

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
(34, 'sutet1992', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Kim Anh Bé', NULL, 1),
(42, 'minhtuyen.ngo.96', 'c4ca4238a0b923820dcc509a6f75849b', NULL, 'Tuyen Ngo', NULL, 1),
(43, 'hanh.su.9212', 'c4ca4238a0b923820dcc509a6f75849b', '', 'Hanh su', '0902557728', 1),
(44, 'hakhaccuong', 'c4ca4238a0b923820dcc509a6f75849b', '', 'Cường Khắc Hà', '0985090099', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `conversion`
--
ALTER TABLE `conversion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Indexes for table `conversions_list`
--
ALTER TABLE `conversions_list`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user1_id` (`user1_id`),
  ADD KEY `user2_id` (`user2_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `conversions_list`
--
ALTER TABLE `conversions_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

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
  ADD CONSTRAINT `conversion_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `conversions_list`
--
ALTER TABLE `conversions_list`
  ADD CONSTRAINT `conversions_list_ibfk_1` FOREIGN KEY (`user1_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `conversions_list_ibfk_2` FOREIGN KEY (`user2_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
