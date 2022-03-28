-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 28, 2022 at 08:52 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 7.4.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `book_now`
--

-- --------------------------------------------------------

--
-- Table structure for table `book_now_log`
--

CREATE TABLE `book_now_log` (
  `id` int(11) NOT NULL,
  `record_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `book_now_log`
--

INSERT INTO `book_now_log` (`id`, `record_id`, `action`, `table_name`, `date`) VALUES
(1, 1, 'inserted', 'people', '2022-03-28 16:06:04'),
(2, 2, 'inserted', 'people', '2022-03-28 16:22:28'),
(3, 1, 'updated', 'people', '2022-03-28 16:22:43'),
(4, 1, 'updated', 'people', '2022-03-28 16:22:51'),
(5, 1, 'updated', 'people', '2022-03-28 16:22:53'),
(6, 1, 'updated', 'people', '2022-03-28 16:27:17'),
(7, 1, 'updated', 'people', '2022-03-28 16:30:17'),
(8, 1, 'updated', 'people', '2022-03-28 16:33:27'),
(9, 1, 'updated', 'people', '2022-03-28 16:36:19'),
(10, 1, 'updated', 'people', '2022-03-28 16:57:28'),
(11, 1, 'updated', 'people', '2022-03-28 17:06:59'),
(12, 1, 'updated', 'people', '2022-03-28 17:12:39'),
(13, 1, 'updated', 'people', '2022-03-28 17:12:53'),
(14, 3, 'inserted', 'people', '2022-03-28 17:16:06'),
(15, 4, 'inserted', 'people', '2022-03-28 17:16:27'),
(16, 5, 'inserted', 'people', '2022-03-28 17:16:28'),
(17, 1, 'inserted', 'people', '2022-03-28 17:20:15');

-- --------------------------------------------------------

--
-- Table structure for table `book_now_rel_log`
--

CREATE TABLE `book_now_rel_log` (
  `id` int(11) NOT NULL,
  `record_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `floor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `houses`
--

INSERT INTO `houses` (`id`, `name`, `floor`) VALUES
(1, 'House 1', 3),
(2, 'House 2', 2);

-- --------------------------------------------------------

--
-- Table structure for table `people`
--

CREATE TABLE `people` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `tel` bigint(20) NOT NULL,
  `city` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `people`
--

INSERT INTO `people` (`id`, `name`, `tel`, `city`) VALUES
(1, 'Peo', 15, 'ry'),
(2, 'peo 1', 335, 're'),
(3, 'urt', 265, 'dy'),
(4, 'rew', 432, 'fd');

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

CREATE TABLE `project` (
  `id` int(11) NOT NULL,
  `project_name` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `end_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `rel_people`
--

CREATE TABLE `rel_people` (
  `id` int(11) NOT NULL,
  `people_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `paid` int(11) NOT NULL,
  `support` int(11) NOT NULL,
  `travel_id` int(11) NOT NULL,
  `coupons` tinyint(1) NOT NULL,
  `house_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `note` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `name` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `floor` int(11) NOT NULL,
  `numbers_of_bed` int(11) NOT NULL,
  `bunk_bed` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `name`, `house_id`, `floor`, `numbers_of_bed`, `bunk_bed`) VALUES
(1, 2, 1, 1, 3, 1),
(2, 4, 1, 1, 3, 0),
(3, 1, 1, 1, 4, 0),
(4, 3, 1, 1, 3, 0),
(5, 1, 1, 2, 2, 1),
(6, 3, 1, 2, 2, 0),
(7, 2, 1, 2, 2, 0),
(8, 4, 1, 2, 2, 0),
(9, 5, 1, 1, 4, 0);

-- --------------------------------------------------------

--
-- Table structure for table `travel`
--

CREATE TABLE `travel` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `travel`
--
DELIMITER $$
CREATE TRIGGER `deleted_travel` BEFORE DELETE ON `travel` FOR EACH ROW INSERT INTO book_now_log VALUES(null, OLD.id , "deleted" , "travel",NOW() )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_travel` AFTER INSERT ON `travel` FOR EACH ROW INSERT INTO book_now_log VALUES(null, NEW.id , "inserted" , "travel",NOW() )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_travel` AFTER UPDATE ON `travel` FOR EACH ROW INSERT INTO book_now_log VALUES(null, NEW.id , "updated" , "travel" , NOW())
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `book_now_log`
--
ALTER TABLE `book_now_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_now_rel_log`
--
ALTER TABLE `book_now_rel_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `people`
--
ALTER TABLE `people`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `project`
--
ALTER TABLE `project`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `rel_people`
--
ALTER TABLE `rel_people`
  ADD PRIMARY KEY (`id`),
  ADD KEY `house_id` (`house_id`),
  ADD KEY `people_id` (`people_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `travel_id` (`travel_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `travel`
--
ALTER TABLE `travel`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `book_now_log`
--
ALTER TABLE `book_now_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `book_now_rel_log`
--
ALTER TABLE `book_now_rel_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `people`
--
ALTER TABLE `people`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `project`
--
ALTER TABLE `project`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rel_people`
--
ALTER TABLE `rel_people`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `travel`
--
ALTER TABLE `travel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
