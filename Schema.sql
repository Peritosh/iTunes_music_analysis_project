-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: itunes_analysis_db
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `album`
--

DROP TABLE IF EXISTS `album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `album` (
  `album_id` bigint NOT NULL,
  `title` text,
  `artist_id` bigint DEFAULT NULL,
  PRIMARY KEY (`album_id`),
  KEY `fk_album_artist` (`artist_id`),
  CONSTRAINT `fk_album_artist` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`artist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `artist`
--

DROP TABLE IF EXISTS `artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist` (
  `artist_id` bigint NOT NULL,
  `name` text,
  PRIMARY KEY (`artist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` bigint NOT NULL,
  `first_name` text,
  `last_name` text,
  `company` text,
  `address` text,
  `city` text,
  `state` text,
  `country` text,
  `postal_code` text,
  `phone` text,
  `fax` text,
  `email` text,
  `support_rep_id` bigint DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  KEY `fk_customer_employee` (`support_rep_id`),
  CONSTRAINT `fk_customer_employee` FOREIGN KEY (`support_rep_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `employee_id` bigint NOT NULL,
  `last_name` text,
  `first_name` text,
  `title` text,
  `reports_to` bigint DEFAULT NULL,
  `levels` text,
  `birthdate` date DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `address` text,
  `city` text,
  `state` text,
  `country` text,
  `postal_code` text,
  `phone` text,
  `fax` text,
  `email` text,
  PRIMARY KEY (`employee_id`),
  KEY `fk_employee_manager` (`reports_to`),
  CONSTRAINT `fk_employee_manager` FOREIGN KEY (`reports_to`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `genre_id` bigint NOT NULL,
  `name` text,
  PRIMARY KEY (`genre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `invoice_id` bigint NOT NULL,
  `customer_id` bigint DEFAULT NULL,
  `invoice_date` datetime DEFAULT NULL,
  `billing_address` text,
  `billing_city` text,
  `billing_state` text,
  `billing_country` text,
  `billing_postal_code` text,
  `total` double DEFAULT NULL,
  PRIMARY KEY (`invoice_id`),
  KEY `fk_invoice_customer` (`customer_id`),
  CONSTRAINT `fk_invoice_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_line`
--

DROP TABLE IF EXISTS `invoice_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_line` (
  `invoice_line_id` bigint NOT NULL,
  `invoice_id` bigint DEFAULT NULL,
  `track_id` bigint DEFAULT NULL,
  `unit_price` double DEFAULT NULL,
  `quantity` bigint DEFAULT NULL,
  PRIMARY KEY (`invoice_line_id`),
  KEY `fk_invoiceLine_invoice` (`invoice_id`),
  KEY `fk_invoiceLine_track` (`track_id`),
  CONSTRAINT `fk_invoiceLine_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoice` (`invoice_id`),
  CONSTRAINT `fk_invoiceLine_track` FOREIGN KEY (`track_id`) REFERENCES `track` (`track_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `media_type`
--

DROP TABLE IF EXISTS `media_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_type` (
  `media_type_id` bigint NOT NULL,
  `name` text,
  PRIMARY KEY (`media_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `playlist`
--

DROP TABLE IF EXISTS `playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist` (
  `playlist_id` bigint NOT NULL,
  `name` text,
  PRIMARY KEY (`playlist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `playlist_track`
--

DROP TABLE IF EXISTS `playlist_track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist_track` (
  `playlist_id` bigint NOT NULL,
  `track_id` bigint NOT NULL,
  PRIMARY KEY (`playlist_id`,`track_id`),
  KEY `fk_playlistTrack_track` (`track_id`),
  CONSTRAINT `fk_playlistTrack_playlist` FOREIGN KEY (`playlist_id`) REFERENCES `playlist` (`playlist_id`),
  CONSTRAINT `fk_playlistTrack_track` FOREIGN KEY (`track_id`) REFERENCES `track` (`track_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `track`
--

DROP TABLE IF EXISTS `track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `track` (
  `track_id` bigint NOT NULL,
  `name` text,
  `album_id` bigint DEFAULT NULL,
  `media_type_id` bigint DEFAULT NULL,
  `genre_id` bigint DEFAULT NULL,
  `composer` text,
  `milliseconds` bigint DEFAULT NULL,
  `bytes` bigint DEFAULT NULL,
  `unit_price` double DEFAULT NULL,
  PRIMARY KEY (`track_id`),
  KEY `fk_track_album` (`album_id`),
  KEY `fk_track_genre` (`genre_id`),
  KEY `fk_track_media` (`media_type_id`),
  CONSTRAINT `fk_track_album` FOREIGN KEY (`album_id`) REFERENCES `album` (`album_id`),
  CONSTRAINT `fk_track_genre` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`genre_id`),
  CONSTRAINT `fk_track_media` FOREIGN KEY (`media_type_id`) REFERENCES `media_type` (`media_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-21 15:44:00
