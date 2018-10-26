-- MySQL dump 10.13  Distrib 5.7.19, for Win64 (x86_64)
--
-- Host: localhost    Database: questionnaire
-- ------------------------------------------------------
-- Server version	5.7.19-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `answer_status`
--

DROP TABLE IF EXISTS `answer_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answer_status` (
  `id` int(11) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `quest_id` int(11) DEFAULT NULL,
  `option_answered` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT '0',
  `ip_user` varchar(150) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(150) DEFAULT 'NULL',
  `modified_at` datetime DEFAULT NULL,
  `modified_by` varchar(150) DEFAULT 'NULL',
  PRIMARY KEY (`id`),
  KEY `questId_idx` (`quest_id`),
  CONSTRAINT `questId` FOREIGN KEY (`quest_id`) REFERENCES `question_answer` (`quest_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answer_status`
--

LOCK TABLES `answer_status` WRITE;
/*!40000 ALTER TABLE `answer_status` DISABLE KEYS */;
INSERT INTO `answer_status` VALUES (00000000001,1,2,0,'192.168.10.112','2017-01-01 00:00:00','NULL','2017-01-01 00:00:00','NULL'),(00000000002,1,1,0,'192.168.10.124','2017-01-01 00:00:00','NULL','2017-01-01 00:00:00','NULL'),(00000000003,1,1,0,'192.168.11.10','2017-01-01 00:00:00','NULL','2017-01-01 00:00:00','NULL'),(00000000004,1,1,0,'192.168.9.123','2017-01-01 00:00:00','NULL','2017-01-01 00:00:00','NULL'),(00000000005,1,4,1,'192.89.98.123','2018-09-04 18:23:50',NULL,'2018-09-04 18:23:50',NULL),(00000000006,1,3,1,'192.80.98.123','2018-09-04 18:29:14',NULL,'2018-09-04 18:29:14',NULL),(00000000007,1,3,2,'192.80.98.125','2018-09-04 18:41:54',NULL,'2018-09-04 18:41:54',NULL),(00000000008,1,3,2,'192.80.98.125','2018-09-05 20:19:35',NULL,'2018-09-05 20:19:35',NULL),(00000000009,2,1,0,'192.90.09.123','2018-01-12 00:00:00',NULL,'2018-01-12 00:00:00',NULL),(00000000010,2,2,0,'192.19.80.121','2018-01-12 00:00:00',NULL,'2018-01-12 00:00:00',NULL),(00000000011,3,1,0,'192.09.89.100','2018-01-12 00:00:00',NULL,'2018-01-12 00:00:00',NULL),(00000000012,3,2,0,'192.11.10.11','2018-01-12 00:00:00',NULL,'2018-01-12 00:00:00',NULL),(00000000013,3,1,0,'192.11.10.12','2018-01-12 00:00:00',NULL,'2018-01-12 00:00:00',NULL),(00000000014,4,1,0,'192.12.10.13','2018-01-12 00:00:00',NULL,'2018-01-12 00:00:00',NULL),(00000000015,4,1,0,'192.19.11.10','2018-01-12 00:00:00',NULL,'2018-01-12 00:00:00',NULL),(00000000016,4,2,0,'192.11.09.12','2018-01-12 00:00:00',NULL,'2018-01-12 00:00:00',NULL),(00000000017,1,3,2,'192.80.98.125','2018-09-21 11:11:29',NULL,'2018-09-21 11:11:29',NULL),(00000000018,2,3,2,'192.80.98.125','2018-09-21 11:23:31',NULL,'2018-09-21 11:23:31',NULL),(00000000019,1,6,2,'192.80.98.125','2018-09-21 11:32:56',NULL,'2018-09-21 11:32:56',NULL),(00000000020,1,3,2,'192.80.98.125','2018-09-21 11:35:21',NULL,'2018-09-21 11:35:21',NULL),(00000000021,1,3,2,'192.80.98.125','2018-09-21 11:36:54',NULL,'2018-09-21 11:36:54',NULL);
/*!40000 ALTER TABLE `answer_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `options_table`
--

DROP TABLE IF EXISTS `options_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `options_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questId` int(11) NOT NULL,
  `option_no` int(11) DEFAULT NULL,
  `option_desc` varchar(200) NOT NULL,
  `option_count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(45) DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL,
  `modified_by` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `quest_id_idx` (`questId`),
  CONSTRAINT `quest_id` FOREIGN KEY (`questId`) REFERENCES `question_answer` (`quest_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `options_table`
--

LOCK TABLES `options_table` WRITE;
/*!40000 ALTER TABLE `options_table` DISABLE KEYS */;
INSERT INTO `options_table` VALUES (1,1,1,'Safety',6,'2018-09-01 00:00:00',NULL,'2018-09-01 00:00:00',NULL),(2,1,2,'Performance',8,'2018-09-01 00:00:00',NULL,'2018-09-01 00:00:00',NULL),(3,1,3,'Mileage',2,'2018-09-01 00:00:00',NULL,'2018-01-11 00:00:00',NULL),(4,1,4,'After sales',0,'2018-09-01 00:00:00',NULL,'2018-09-01 00:00:00',NULL),(5,1,5,'Look and styling',0,'2018-09-01 00:00:00',NULL,'2018-09-01 00:00:00',NULL),(6,2,1,'Hatchback',0,'2018-09-01 00:00:00',NULL,'2018-09-01 00:00:00',NULL),(7,2,2,'Compact SUV',0,'2018-09-01 00:00:00',NULL,'2018-09-01 00:00:00',NULL),(8,2,3,'Sedan',0,'2018-09-01 00:00:00',NULL,'2018-09-01 00:00:00',NULL),(9,2,4,'MPV',0,'2018-09-01 00:00:00',NULL,'2018-09-01 00:00:00',NULL),(10,2,5,'SUV',0,NULL,NULL,NULL,NULL),(11,3,1,'Space',0,NULL,NULL,NULL,NULL),(12,3,2,'Price',0,NULL,NULL,NULL,NULL),(13,3,3,'Mileage',0,NULL,NULL,NULL,NULL),(14,3,4,'Service cost',0,NULL,NULL,NULL,NULL),(18,4,1,'Maruti Ertiga',0,NULL,NULL,NULL,NULL),(19,4,2,'Mahindra Marazzo',0,NULL,NULL,NULL,NULL),(20,4,3,'Toyota Innova',0,NULL,NULL,NULL,NULL),(21,4,4,'Honda BRV',0,NULL,NULL,NULL,NULL),(22,4,5,'Renault Lodgy',0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `options_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_answer`
--

DROP TABLE IF EXISTS `question_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question_answer` (
  `quest_id` int(11) NOT NULL,
  `quest_desc` varchar(200) NOT NULL,
  `count_ques_attemp` int(11) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `created_by` varchar(100) DEFAULT 'NULL',
  `modified_at` datetime DEFAULT NULL,
  `modified_by` varchar(200) DEFAULT 'NULL',
  PRIMARY KEY (`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_answer`
--

LOCK TABLES `question_answer` WRITE;
/*!40000 ALTER TABLE `question_answer` DISABLE KEYS */;
INSERT INTO `question_answer` VALUES (1,'What is your top priority while buying any car?',0,'2017-01-01 00:00:00','NULL','2017-01-01 00:00:00','NULL'),(2,'What kind of car will you buy most likely?',1,'2018-01-11 00:00:00',NULL,'2018-01-11 00:00:00',NULL),(3,'What is the key reason for your selection?',7,'2018-01-12 00:00:00',NULL,'2018-01-12 00:00:00',NULL),(4,'If given an option, which MPV would you buy?',2,'2018-01-12 00:00:00',NULL,'2018-01-12 00:00:00',NULL);
/*!40000 ALTER TABLE `question_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_info`
--

DROP TABLE IF EXISTS `session_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(125) DEFAULT NULL,
  `session_ip` varchar(125) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_info`
--

LOCK TABLES `session_info` WRITE;
/*!40000 ALTER TABLE `session_info` DISABLE KEYS */;
INSERT INTO `session_info` VALUES (1,'637287384873474374774','198.21.09.19',1,'2018-09-17 19:35:46','2018-09-17 19:35:46');
/*!40000 ALTER TABLE `session_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-10-25 15:13:37
