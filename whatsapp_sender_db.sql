-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: whatsapp_sender_db
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `whatsapp_sender_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `whatsapp_sender_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `whatsapp_sender_db`;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add customer',7,'add_customer'),(26,'Can change customer',7,'change_customer'),(27,'Can delete customer',7,'delete_customer'),(28,'Can view customer',7,'view_customer'),(29,'Can add message log',8,'add_messagelog'),(30,'Can change message log',8,'change_messagelog'),(31,'Can delete message log',8,'delete_messagelog'),(32,'Can view message log',8,'view_messagelog'),(33,'Can add customer reply',9,'add_customerreply'),(34,'Can change customer reply',9,'change_customerreply'),(35,'Can delete customer reply',9,'delete_customerreply'),(36,'Can view customer reply',9,'view_customerreply'),(37,'Can add outgoing reply',10,'add_outgoingreply'),(38,'Can change outgoing reply',10,'change_outgoingreply'),(39,'Can delete outgoing reply',10,'delete_outgoingreply'),(40,'Can view outgoing reply',10,'view_outgoingreply');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1200000$hPDUGBDVUdz0p3vHfUj2D1$AJ0zL3nNRSUnVAzXwGq+UecW+SOfASxc8SN+tEJGnd8=','2026-07-15 10:56:20.222655',1,'raj','','','raj@gmail.com',1,1,'2026-07-15 10:55:26.561310');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2026-07-15 10:56:39.014166','1','Bharat singh - 916398592039',1,'[{\"added\": {}}]',7,1),(2,'2026-07-15 10:57:04.173735','2','Raj Kumar - 919759998032',1,'[{\"added\": {}}]',7,1),(3,'2026-07-15 11:03:02.925407','23','Amit Kumar - 919876543210',3,'',7,1),(4,'2026-07-15 11:03:41.486450','24','Neha Sharma - 919812345678',3,'',7,1),(5,'2026-07-15 11:03:58.928452','25','Rohit Verma - 919900001111',3,'',7,1),(6,'2026-07-15 11:04:10.566189','26','Priya Gupta - 919811112222',3,'',7,1),(7,'2026-07-15 11:04:15.342721','27','Sandeep Yadav - 919822223333',3,'',7,1),(8,'2026-07-15 11:04:19.553809','28','Anjali Singh - 919833334444',3,'',7,1),(9,'2026-07-15 11:04:23.950865','29','Vikas Kumar - 919844445555',3,'',7,1),(10,'2026-07-15 11:04:27.702303','30','Mohit Chauhan - 919855556666',3,'',7,1),(11,'2026-07-15 11:04:30.862081','31','Pooja Sharma - 919866667777',3,'',7,1),(12,'2026-07-15 11:05:27.813487','49','Pooja Sharma - 919866667777',3,'',7,1),(13,'2026-07-15 11:05:27.813543','48','Mohit Chauhan - 919855556666',3,'',7,1),(14,'2026-07-15 11:05:27.813579','47','Vikas Kumar - 919844445555',3,'',7,1),(15,'2026-07-15 11:05:27.813614','46','Anjali Singh - 919833334444',3,'',7,1),(16,'2026-07-15 11:05:27.813647','45','Sandeep Yadav - 919822223333',3,'',7,1),(17,'2026-07-15 11:05:27.813681','44','Priya Gupta - 919811112222',3,'',7,1),(18,'2026-07-15 11:05:27.813714','43','Rohit Verma - 919900001111',3,'',7,1),(19,'2026-07-15 11:05:27.813748','42','Neha Sharma - 919812345678',3,'',7,1),(20,'2026-07-15 11:05:27.813781','41','Amit Kumar - 919876543210',3,'',7,1),(21,'2026-07-15 11:07:14.979514','50','Neha Singh - 915586947852',1,'[{\"added\": {}}]',7,1),(22,'2026-07-17 12:48:10.798844','60','test user name - 16315551181',3,'',7,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(7,'myapp','customer'),(9,'myapp','customerreply'),(8,'myapp','messagelog'),(10,'myapp','outgoingreply'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-07-15 10:50:15.562827'),(2,'auth','0001_initial','2026-07-15 10:50:16.750132'),(3,'admin','0001_initial','2026-07-15 10:50:17.044252'),(4,'admin','0002_logentry_remove_auto_add','2026-07-15 10:50:17.058764'),(5,'admin','0003_logentry_add_action_flag_choices','2026-07-15 10:50:17.075085'),(6,'contenttypes','0002_remove_content_type_name','2026-07-15 10:50:17.397171'),(7,'auth','0002_alter_permission_name_max_length','2026-07-15 10:50:17.540908'),(8,'auth','0003_alter_user_email_max_length','2026-07-15 10:50:17.586653'),(9,'auth','0004_alter_user_username_opts','2026-07-15 10:50:17.605223'),(10,'auth','0005_alter_user_last_login_null','2026-07-15 10:50:17.731862'),(11,'auth','0006_require_contenttypes_0002','2026-07-15 10:50:17.736368'),(12,'auth','0007_alter_validators_add_error_messages','2026-07-15 10:50:17.748769'),(13,'auth','0008_alter_user_username_max_length','2026-07-15 10:50:17.946010'),(14,'auth','0009_alter_user_last_name_max_length','2026-07-15 10:50:18.198776'),(15,'auth','0010_alter_group_name_max_length','2026-07-15 10:50:18.245483'),(16,'auth','0011_update_proxy_permissions','2026-07-15 10:50:18.263449'),(17,'auth','0012_alter_user_first_name_max_length','2026-07-15 10:50:18.460226'),(18,'myapp','0001_initial','2026-07-15 10:50:18.562351'),(19,'sessions','0001_initial','2026-07-15 10:50:18.658749'),(20,'myapp','0002_messagelog','2026-07-16 05:34:13.438227'),(21,'myapp','0003_messagelog_delivered_at_messagelog_failed_at_and_more','2026-07-16 10:44:35.213295'),(22,'myapp','0004_outgoingreply','2026-07-17 09:20:30.068233');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('s97sezv1zbnx5tx89kgkb6ajdh0kidsh','.eJxVjEEOwiAQAP-yZ0NKW7bQo3ffQHZZkKqBpLQn499Nkx70OjOZN3jat-z3Fle_CMyg4fLLmMIzlkPIg8q9qlDLti6sjkSdtqlblfi6nu3fIFPLMINhpjBZGpKE0CUXZdTJCSKjsSYhjUIYWSeOaMVxMoYny0OPqEPfOfh8ASQ_OQQ:1wjxHo:4EHhhaec4b8Ms-MwgLUT38j_k_rhriT4dVEbrNP7jr0','2026-07-29 10:56:20.228230');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_customer`
--

DROP TABLE IF EXISTS `myapp_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_customer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `city` varchar(100) NOT NULL,
  `pin_code` varchar(10) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_customer`
--

LOCK TABLES `myapp_customer` WRITE;
/*!40000 ALTER TABLE `myapp_customer` DISABLE KEYS */;
INSERT INTO `myapp_customer` VALUES (1,'Bharat singh','916398592039','Etah','207248','2026-07-15 10:56:39.013352'),(2,'Raj Kumar','919759998032','Agra','282002','2026-07-15 10:57:04.173014'),(50,'Neha Singh','915586947852','Agra','282001','2026-07-15 11:07:14.978577'),(51,'Amit Kumar','919876543210','Agra','282001','2026-07-15 16:37:49.000000'),(52,'Neha Sharma','919812345678','Noida','201301','2026-07-15 16:37:49.000000'),(53,'Rohit Verma','919900001111','Delhi','110001','2026-07-15 16:37:49.000000'),(54,'Priya Gupta','919811112222','Mathura','281001','2026-07-15 16:37:49.000000'),(55,'Sandeep Yadav','919822223333','Aligarh','202001','2026-07-15 16:37:49.000000'),(56,'Anjali Singh','919833334444','Lucknow','226001','2026-07-15 16:37:49.000000'),(57,'Vikas Kumar','919844445555','Ghaziabad','201001','2026-07-15 16:37:49.000000'),(58,'Mohit Chauhan','919855556666','Firozabad','283203','2026-07-15 16:37:49.000000'),(59,'Pooja Sharma','919866667777','Kanpur','208001','2026-07-15 16:37:49.000000');
/*!40000 ALTER TABLE `myapp_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_customerreply`
--

DROP TABLE IF EXISTS `myapp_customerreply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_customerreply` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `whatsapp_message_id` varchar(255) NOT NULL,
  `reply_type` varchar(50) NOT NULL,
  `reply_text` longtext NOT NULL,
  `received_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `customer_id` bigint NOT NULL,
  `message_log_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `whatsapp_message_id` (`whatsapp_message_id`),
  KEY `myapp_customerreply_customer_id_97b0ca03_fk_myapp_customer_id` (`customer_id`),
  KEY `myapp_customerreply_message_log_id_52541587_fk_myapp_mes` (`message_log_id`),
  CONSTRAINT `myapp_customerreply_customer_id_97b0ca03_fk_myapp_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `myapp_customer` (`id`),
  CONSTRAINT `myapp_customerreply_message_log_id_52541587_fk_myapp_mes` FOREIGN KEY (`message_log_id`) REFERENCES `myapp_messagelog` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_customerreply`
--

LOCK TABLES `myapp_customerreply` WRITE;
/*!40000 ALTER TABLE `myapp_customerreply` DISABLE KEYS */;
INSERT INTO `myapp_customerreply` VALUES (2,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNCODgwNjY4MjY3RjE5Mjc1NTEwMjY4QjhCRTQ2N0IA','text','Hi','2026-07-16 11:39:44.000000','2026-07-16 11:39:44.535589',1,39),(3,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM3MEI3RkYyNTVEMDVDMEQxNDNBQjg0RTZGM0IwQkEA','button','yes','2026-07-16 11:43:02.000000','2026-07-16 11:43:02.040835',1,42),(4,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNFNUU0QTlCQjNBQzFDNTRCMjMwMDI3ODJEMTM4NTQA','button','yes','2026-07-16 11:57:38.000000','2026-07-16 11:57:39.055545',1,45),(5,'wamid.HBgMOTE5NzU5OTk4MDMyFQIAEhggQUM4NTQ5NzM4NTFCMjA3OThBRURGMUM0M0MxMTRFMEMA','text','Hlo','2026-07-16 11:59:04.000000','2026-07-16 11:59:04.535015',2,54),(6,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM2MDc5Q0E3NjEyNEJGMzExODhDQzIxQjEzRENFQTIA','text','Hi','2026-07-16 12:05:59.000000','2026-07-16 12:05:59.779631',1,56),(7,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM4MzkyRDQ5NzkwMzQxQUI5NzMxMTFFMkI4MTNCOTAA','text','Hlo','2026-07-16 12:08:40.000000','2026-07-16 12:08:40.743302',1,56),(8,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNCMjJFRThDRkRCMjExNTcwMjc2RkY0NEEyNDVFREEA','text','H','2026-07-16 12:09:49.000000','2026-07-16 12:09:49.162287',1,56),(9,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNCOEEwOUQ1RUYwMEI1NjFDMzQ1ODZDMjNGRjI3QUEA','button','yes','2026-07-16 12:11:33.000000','2026-07-16 12:11:33.732579',1,57),(10,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNBQTg0QkZCNUFBRENERDZBRTM0MDlCOTA5Q0REMTEA','button','No','2026-07-16 13:15:24.000000','2026-07-16 13:15:24.876215',1,69),(11,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNEQzY0QUVGMDVEQjk1NjhGOUE2NDI1MzU1RkVGNTYA','button','yes','2026-07-17 04:51:53.000000','2026-07-17 04:51:53.300088',1,72),(12,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNGNTA0NTZGMUUwODg1MTQ5NzA5RURGN0VGNzM3RDQA','text','Hlo','2026-07-17 04:53:56.000000','2026-07-17 04:53:55.635906',1,73),(13,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNDODZGQjJEMkUwNUIxNjExMjBCMDgwNTE5NjQ5QUIA','button','Yes','2026-07-17 05:03:38.000000','2026-07-17 05:03:37.924288',1,74),(14,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUMzMTE4RUMxMEExNjUxMzcxMjJCMkZGNzE0MjkzNkMA','text','Hlo','2026-07-17 05:10:19.000000','2026-07-17 05:10:19.315063',1,75),(15,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM0RDM0NTZBNTI0MzExNTYxMDE2OUFDQUM1NUZGRkYA','button','yes','2026-07-17 07:52:25.000000','2026-07-17 07:52:25.830598',1,82),(16,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNGQjVFQkNFNEQ0MjMxMDI0ODQ3OTYyRUNBQUFGMDUA','button','No','2026-07-17 07:52:52.000000','2026-07-17 07:52:52.185211',1,72),(17,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNCNzFEMTNENzA4NDgxQ0Q4MkRGMEEyQzg3ODA1ODgA','text','Hlo','2026-07-17 07:53:08.000000','2026-07-17 07:53:08.270261',1,83),(18,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUMzOThFMEI1REUyRkM0MkYyQkQ4NDhEMzM5RTM0MDEA','button','Yes','2026-07-17 07:53:16.000000','2026-07-17 07:53:16.449335',1,69),(19,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNCODQ0RTcxRUQ5NjRBNkQ3MjI4RERFNjlGQUMzQ0UA','button','No','2026-07-17 07:53:37.000000','2026-07-17 07:53:37.000961',1,74),(20,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUMwOEYxM0RGMTBDODExODVEREM3QjAwMUE5ODVEODkA','text','Hlo','2026-07-17 07:54:18.000000','2026-07-17 07:54:18.736586',1,75),(21,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNCODQ2QUI0OTk2RkNGMDE5MTYzQkZCRTFEMDcwQ0MA','text','Ho','2026-07-17 07:54:35.000000','2026-07-17 07:54:35.314703',1,83),(22,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM0MjIwMkJCQzVCREZFRTAwOTlDMjQ4QTEwNDIzNzMA','button','No','2026-07-17 07:54:43.000000','2026-07-17 07:54:43.499140',1,82),(23,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM0ODRFNkFDRUU3NTkyOUVDN0RDMTMyOTI5MTg1MzYA','text','Hi','2026-07-17 09:56:35.000000','2026-07-17 09:56:36.409302',1,94),(24,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM2RTE0Mzg0NzA3Q0MyNkE1NDdBMjNCMzZERjE5MjkA','text','Hlo','2026-07-17 10:02:19.000000','2026-07-17 10:02:20.559152',1,94),(25,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUMyRkNDQ0E4QjFFOTNGRkY5RkREQUYxMkFFQzYzNzAA','text','Yes','2026-07-17 10:14:31.000000','2026-07-17 10:14:32.565867',1,94),(26,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNFQ0FGNDYxQTUzNjE2NEIyRTY2RjU0RDFGNDEwNzgA','text','Hello sir','2026-07-17 10:15:31.000000','2026-07-17 10:15:33.169633',1,94),(27,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM5MEU1NDUwNTVDQUQ3RTUyNDA2MjE3ODc1QzM0NjIA','text','Hi','2026-07-17 10:57:04.000000','2026-07-17 10:57:05.869114',1,95),(28,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNBRkQ5NzIxRjJBNDI1NjRDQkIyQjQzOTc3Mzc2RjMA','text','Mujhe ek help chahiye','2026-07-17 10:57:54.000000','2026-07-17 10:57:56.401438',1,95),(29,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM3NzRBMTMyNDI4QzQ2RDE2QzNCNEMwQjI4RDM3QTEA','text','Hi','2026-07-17 11:23:52.000000','2026-07-17 11:23:53.809414',1,95),(30,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM4M0NBRjM1NjdDREI0RDE2NjVDOUUzNTc1MUFBRDcA','text','Hlo','2026-07-17 11:47:40.000000','2026-07-17 11:47:41.658559',1,95),(31,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNDQTBBQzc5RUNCMEQyNkQ0Q0NCMzhDQTVGMEZFRTkA','text','Gh','2026-07-17 11:47:58.000000','2026-07-17 11:48:00.003706',1,95),(32,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM1ODkwNzQwNTJCNDUxN0E3NzU4MUEwNUUwQTc0NzUA','text','Hi','2026-07-17 12:36:29.000000','2026-07-17 12:36:30.809130',1,95),(33,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM2OUE4QzdENkFGOTFDNUU5MjdEQUY2MUQ0NzBGMzIA','text','Hi','2026-07-17 12:36:49.000000','2026-07-17 12:36:50.766369',1,95),(34,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNDNDk5ODYyQzMwNTM0ODlFQkFBMTkyRjJFM0FFNzMA','text','Hlo','2026-07-17 12:41:27.000000','2026-07-17 12:41:29.417885',1,95),(35,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUMzMEI1MTI3NjFCNDUzOTJDQUJFM0Q1M0U4MzA5NzEA','text','Yes','2026-07-17 12:48:40.000000','2026-07-17 12:48:42.135017',1,98),(36,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNERDY3N0Q1QjhEOTBBRDFFOTgxMjYzRDI4NjExODMA','text','Yes','2026-07-17 13:23:05.000000','2026-07-17 13:23:06.791753',1,100),(37,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUMxNDA5QUE5OTFENDQwQjM3Q0EyRkNGNEU1QzA1MjAA','text','Acha','2026-07-17 13:43:04.000000','2026-07-17 13:43:06.000025',1,103),(38,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNBMDU1REI0RjI5N0E3NzZDQkFEOTdEMEM0RkE5QzgA','text','Ok','2026-07-17 13:43:27.000000','2026-07-17 13:43:28.793932',1,103),(39,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUMwMDYwNUMxMDY3RTRGMjNDQTc2OEJFNDJGRjNDMTMA','text','Hlo','2026-07-18 04:50:13.000000','2026-07-18 04:50:14.470610',1,105),(40,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUNGMzY4QjMyRDlERDUxQkQ4OEJFMTgwNEJFREIwNDAA','text','Hi','2026-07-18 06:25:28.000000','2026-07-18 06:25:28.720214',1,114),(41,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM0NTMyQ0E3REEwQUY4MzFGMDRBQTY0QkRDRjBEMjUA','text','No','2026-07-18 06:27:51.000000','2026-07-18 06:27:52.461212',1,114),(42,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM1N0MwMkM3MzdCQjQwNkUzNkFCMzNDQzc4NTE2QjAA','text','Need','2026-07-18 06:27:55.000000','2026-07-18 06:27:56.235678',1,114),(43,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUMzMjkyMDM0MDIyN0E2OTIwODlFRkY0NkU4RDIyRDAA','text','Kaise ho','2026-07-18 06:29:23.000000','2026-07-18 06:29:24.155359',1,114),(44,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUM2OTY2NjcxMUNEODk3N0NCMEQ4RkQxNzUwOTBENzUA','text','thik hu','2026-07-18 06:29:28.000000','2026-07-18 06:29:29.596351',1,114),(45,'wamid.HBgMOTE2Mzk4NTkyMDM5FQIAEhggQUMxQkYxNzYzMTUwQkU3MDY2OEFEQUY5NDJDQThGRkUA','text','Okay','2026-07-18 06:29:56.000000','2026-07-18 06:29:57.644441',1,114);
/*!40000 ALTER TABLE `myapp_customerreply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_messagelog`
--

DROP TABLE IF EXISTS `myapp_messagelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_messagelog` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `template_name` varchar(150) NOT NULL,
  `template_language` varchar(20) NOT NULL,
  `meta_message_id` varchar(255) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `error_message` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `customer_id` bigint NOT NULL,
  `delivered_at` datetime(6) DEFAULT NULL,
  `failed_at` datetime(6) DEFAULT NULL,
  `read_at` datetime(6) DEFAULT NULL,
  `sent_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `meta_message_id` (`meta_message_id`),
  KEY `myapp_messagelog_customer_id_3adb1963_fk_myapp_customer_id` (`customer_id`),
  CONSTRAINT `myapp_messagelog_customer_id_3adb1963_fk_myapp_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `myapp_customer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_messagelog`
--

LOCK TABLES `myapp_messagelog` WRITE;
/*!40000 ALTER TABLE `myapp_messagelog` DISABLE KEYS */;
INSERT INTO `myapp_messagelog` VALUES (1,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQjJGQzExNjAxOUJDNkI2RjlCAA==','accepted','','2026-07-16 06:14:22.927804','2026-07-16 06:14:24.157398',1,NULL,NULL,NULL,NULL),(2,'sea_news_carousel','hi',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 06:15:39.184641','2026-07-16 06:15:41.052478',50,NULL,NULL,NULL,NULL),(3,'sea_news_carousel','hi',NULL,'failed','(#132012) Parameter format does not match format in the created template — header component parameter should not be empty','2026-07-16 06:15:58.706274','2026-07-16 06:15:59.176110',1,NULL,NULL,NULL,NULL),(4,'sea_news_carousel','hi',NULL,'failed','(#132012) Parameter format does not match format in the created template — header component parameter should not be empty','2026-07-16 06:30:45.301848','2026-07-16 06:30:47.591041',1,NULL,NULL,NULL,NULL),(5,'sea_news_carousel','hi',NULL,'failed','(#132012) Parameter format does not match format in the created template — header component parameter should not be empty','2026-07-16 06:30:47.713668','2026-07-16 06:30:48.239118',1,NULL,NULL,NULL,NULL),(6,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRkJFOTk3OTIwQjNBRTBEMDg1AA==','accepted','','2026-07-16 06:31:30.714588','2026-07-16 06:31:31.604533',1,NULL,NULL,NULL,NULL),(7,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSNjFDMjMzRUYyQUUwMjg0MkJFAA==','accepted','','2026-07-16 06:33:32.348848','2026-07-16 06:33:33.973046',2,NULL,NULL,NULL,NULL),(8,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNzA4NDRDNDI1REQyRUIyMkE3AA==','accepted','','2026-07-16 06:35:28.853733','2026-07-16 06:35:29.682010',1,NULL,NULL,NULL,NULL),(9,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSNzc1QTM0NkY5NzU0RDE5NDVGAA==','accepted','','2026-07-16 06:35:29.689538','2026-07-16 06:35:30.414020',2,NULL,NULL,NULL,NULL),(10,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSM0I4QzlGNDA0MjhCNjI4ODlCAA==','accepted','','2026-07-16 06:35:47.951932','2026-07-16 06:35:49.237441',1,NULL,NULL,NULL,NULL),(11,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSQjlEMUZCQjVBN0UzMDVBRTUwAA==','accepted','','2026-07-16 06:35:49.244528','2026-07-16 06:35:49.949248',2,NULL,NULL,NULL,NULL),(12,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 06:35:49.955659','2026-07-16 06:35:50.410166',50,NULL,NULL,NULL,NULL),(13,'jinvani_channel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRUNEQzc2OUI4REREQzU2RTFGAA==','accepted','','2026-07-16 06:59:20.079410','2026-07-16 06:59:21.474283',1,NULL,NULL,NULL,NULL),(14,'sea_news_channel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQzlGNkE3MzVBQ0QzRUQwRTgzAA==','accepted','','2026-07-16 06:59:48.029287','2026-07-16 06:59:49.276345',1,NULL,NULL,NULL,NULL),(15,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQUY4MUZGODI2MjJDMEM0QjA4AA==','accepted','','2026-07-16 07:00:04.735082','2026-07-16 07:00:06.194685',1,NULL,NULL,NULL,NULL),(16,'sea_news_carousel','hi',NULL,'failed','(#132012) Parameter format does not match format in the created template — header component parameter should not be empty','2026-07-16 07:00:22.601539','2026-07-16 07:00:23.708528',1,NULL,NULL,NULL,NULL),(17,'sea_news_update','en_US',NULL,'failed','(#132000) Number of parameters does not match the expected number of params — body: number of localizable_params (0) does not match the expected number of params (1)','2026-07-16 08:58:01.241731','2026-07-16 08:58:02.081879',1,NULL,NULL,NULL,NULL),(18,'sea_news_update','en_US',NULL,'failed','(#132000) Number of parameters does not match the expected number of params — body: number of localizable_params (0) does not match the expected number of params (1)','2026-07-16 08:58:01.756726','2026-07-16 08:58:02.220711',1,NULL,NULL,NULL,NULL),(19,'sea_news_update','en_US',NULL,'failed','(#132000) Number of parameters does not match the expected number of params — body: number of localizable_params (0) does not match the expected number of params (1)','2026-07-16 08:58:53.628385','2026-07-16 08:58:54.091698',1,NULL,NULL,NULL,NULL),(20,'sea_news_update','en_US',NULL,'failed','(#132000) Number of parameters does not match the expected number of params — body: number of localizable_params (0) does not match the expected number of params (1)','2026-07-16 09:01:23.387244','2026-07-16 09:01:23.847481',2,NULL,NULL,NULL,NULL),(21,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQkM3RjBGNjM4RjJGOUREQjMwAA==','accepted','','2026-07-16 09:01:43.808844','2026-07-16 09:01:44.609488',1,NULL,NULL,NULL,NULL),(22,'sea_news_update','en_US',NULL,'failed','(#132000) Number of parameters does not match the expected number of params — body: number of localizable_params (0) does not match the expected number of params (1)','2026-07-16 09:01:58.130871','2026-07-16 09:01:58.616071',1,NULL,NULL,NULL,NULL),(23,'sea_news_update','en_US',NULL,'failed','(#132000) Number of parameters does not match the expected number of params — body: number of localizable_params (0) does not match the expected number of params (1)','2026-07-16 09:10:03.943823','2026-07-16 09:10:04.403688',1,NULL,NULL,NULL,NULL),(24,'sea_news_update','en_US',NULL,'failed','(#132000) Number of parameters does not match the expected number of params — body: number of localizable_params (0) does not match the expected number of params (1)','2026-07-16 09:10:41.665694','2026-07-16 09:10:42.202533',1,NULL,NULL,NULL,NULL),(25,'sea_news_update','en_US',NULL,'failed','(#132000) Number of parameters does not match the expected number of params — body: number of localizable_params (0) does not match the expected number of params (1)','2026-07-16 09:13:05.220579','2026-07-16 09:13:06.725761',1,NULL,NULL,NULL,NULL),(26,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQUQ1NjE1NUE1NDRDNzI2RUUzAA==','accepted','','2026-07-16 09:18:16.939727','2026-07-16 09:18:17.456519',1,NULL,NULL,NULL,NULL),(27,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNzczMUM0ODZGNDYxOERGQjlBAA==','accepted','','2026-07-16 09:18:45.602141','2026-07-16 09:18:46.190452',1,NULL,NULL,NULL,NULL),(28,'payment_overdue_1','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSOThFRjkxMUMzMjQyRDAyQzM5AA==','accepted','','2026-07-16 09:19:37.102938','2026-07-16 09:19:37.713335',1,NULL,NULL,NULL,NULL),(29,'jinvani_channel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRjk2MTI1ODkzODA1QTU2QkZCAA==','accepted','','2026-07-16 09:21:33.038190','2026-07-16 09:21:34.770222',1,NULL,NULL,NULL,NULL),(30,'sea_news_channel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNjU2NTU2QTdGMUI5RUIzMEQxAA==','accepted','','2026-07-16 09:22:37.808313','2026-07-16 09:22:38.351451',1,NULL,NULL,NULL,NULL),(31,'sea_news_channel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNEEzMEQ5RjE3MzBGREFERTE2AA==','accepted','','2026-07-16 09:23:54.915897','2026-07-16 09:23:55.628585',1,NULL,NULL,NULL,NULL),(32,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMjIzMTYxODUzQzEwRDU5RkRGAA==','accepted','','2026-07-16 09:24:46.755029','2026-07-16 09:24:47.546276',1,NULL,NULL,NULL,NULL),(33,'sea_news_carousel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRUZCQ0Y1ODU0QUY3QzE1MkExAA==','accepted','','2026-07-16 09:25:57.239833','2026-07-16 09:25:58.842904',1,NULL,NULL,NULL,NULL),(34,'sea_news','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSOUM2Mzg5RDdEN0JDOTQyMDAxAA==','accepted','','2026-07-16 09:39:29.746054','2026-07-16 09:39:30.310226',1,NULL,NULL,NULL,NULL),(35,'sea_news','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMzBDRjUzRDkzREM1MjRGMkZEAA==','accepted','','2026-07-16 09:42:11.785899','2026-07-16 09:42:12.322011',1,NULL,NULL,NULL,NULL),(36,'hello_world','en_US','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSM0NGQkY2M0E3NDlDNDA2RDQ1AA==','read','','2026-07-16 09:51:28.217207','2026-07-16 11:58:35.912961',2,'2026-07-16 11:58:16.000000',NULL,'2026-07-16 11:58:35.000000',NULL),(37,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNDVFOTcwMjA1NzExM0QxQzVEAA==','accepted','','2026-07-16 09:52:15.655612','2026-07-16 09:52:16.512345',1,NULL,NULL,NULL,NULL),(38,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQzFGQkVBQjI2M0EyREVCMDYxAA==','accepted','','2026-07-16 11:04:01.989274','2026-07-16 11:04:02.872803',1,NULL,NULL,NULL,NULL),(39,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNzA4RjA0M0ZDODM5NDRDNzlEAA==','read','','2026-07-16 11:38:53.358561','2026-07-16 11:39:17.041719',1,'2026-07-16 11:39:04.000000',NULL,'2026-07-16 11:39:17.000000','2026-07-16 11:39:02.000000'),(40,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSM0MwOTQ3MzUzRjY5Qjk1RjUxAA==','read','','2026-07-16 11:40:20.448280','2026-07-16 11:40:23.476251',1,NULL,NULL,'2026-07-16 11:40:23.000000','2026-07-16 11:40:23.000000'),(41,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSMzJGRkNEREVFOUI2M0YzRjk1AA==','failed','This message was not delivered to maintain healthy ecosystem engagement. — In order to maintain a healthy ecosystem engagement, the message failed to be delivered.','2026-07-16 11:40:21.906712','2026-07-16 11:40:24.432338',2,NULL,'2026-07-16 11:40:24.000000',NULL,NULL),(42,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSREFEQjZDQTBCQzgzREUwMEQwAA==','read','','2026-07-16 11:41:59.927663','2026-07-16 11:42:29.444281',1,'2026-07-16 11:42:03.000000',NULL,'2026-07-16 11:42:29.000000','2026-07-16 11:42:02.000000'),(43,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSMzcwNjYxRjc3RkQ4OTUyRkNBAA==','failed','This message was not delivered to maintain healthy ecosystem engagement. — In order to maintain a healthy ecosystem engagement, the message failed to be delivered.','2026-07-16 11:42:00.879484','2026-07-16 11:42:02.541140',2,NULL,'2026-07-16 11:42:02.000000',NULL,NULL),(44,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 11:42:01.844039','2026-07-16 11:42:02.473059',50,NULL,NULL,NULL,NULL),(45,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSOTNDOEJERjMzMzRCREQ2NTQ3AA==','read','','2026-07-16 11:45:05.298353','2026-07-16 11:56:33.342325',1,'2026-07-16 11:45:09.000000',NULL,'2026-07-16 11:56:33.000000','2026-07-16 11:45:07.000000'),(46,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSODg0RENEMzVFQzhCNThDQ0MxAA==','failed','This message was not delivered to maintain healthy ecosystem engagement. — In order to maintain a healthy ecosystem engagement, the message failed to be delivered.','2026-07-16 11:45:06.444388','2026-07-16 11:45:08.030921',2,NULL,'2026-07-16 11:45:08.000000',NULL,NULL),(47,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 11:45:07.392048','2026-07-16 11:45:08.057790',51,NULL,NULL,NULL,NULL),(48,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSMTZGQkI2MUZCODZFMzc5QjQ1AA==','failed','This message was not delivered to maintain healthy ecosystem engagement. — In order to maintain a healthy ecosystem engagement, the message failed to be delivered.','2026-07-16 11:45:46.589217','2026-07-16 11:45:48.644316',2,NULL,'2026-07-16 11:45:49.000000',NULL,NULL),(49,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSMjgxNUMwODUyRUExN0M0NjMyAA==','failed','This message was not delivered to maintain healthy ecosystem engagement. — In order to maintain a healthy ecosystem engagement, the message failed to be delivered.','2026-07-16 11:46:14.555178','2026-07-16 11:46:16.461294',2,NULL,'2026-07-16 11:46:16.000000',NULL,NULL),(50,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSOEE4NjlFOEM3ODUwOERGMDFDAA==','failed','This message was not delivered to maintain healthy ecosystem engagement. — In order to maintain a healthy ecosystem engagement, the message failed to be delivered.','2026-07-16 11:48:13.886048','2026-07-16 11:48:15.730444',2,NULL,'2026-07-16 11:48:16.000000',NULL,NULL),(51,'sea_news','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSMDczODRGMEY5NkYwNjVFN0RCAA==','failed','This message was not delivered to maintain healthy ecosystem engagement. — In order to maintain a healthy ecosystem engagement, the message failed to be delivered.','2026-07-16 11:54:28.522610','2026-07-16 11:54:44.102164',2,NULL,'2026-07-16 11:54:44.000000',NULL,NULL),(52,'hello_world','en_US','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSRTZFRjRFNjlBNEQxQTY0QTYzAA==','read','','2026-07-16 11:55:47.397181','2026-07-16 11:58:35.775057',2,'2026-07-16 11:58:17.000000',NULL,'2026-07-16 11:58:35.000000','2026-07-16 11:55:49.000000'),(53,'hello_world','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQkRCNTk1REM1RjdEMjNEQUZGAA==','read','','2026-07-16 11:56:11.472140','2026-07-16 11:56:33.185721',1,'2026-07-16 11:56:16.000000',NULL,'2026-07-16 11:56:33.000000','2026-07-16 11:56:14.000000'),(54,'hello_world','en_US','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSNjdCRTNGMzlBMzEyMTkwQkI4AA==','read','','2026-07-16 11:56:12.565746','2026-07-16 11:58:35.770019',2,'2026-07-16 11:58:17.000000',NULL,'2026-07-16 11:58:35.000000','2026-07-16 11:56:14.000000'),(55,'hello_world','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 11:56:13.572666','2026-07-16 11:56:14.241683',50,NULL,NULL,NULL,NULL),(56,'sea_news','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNTMyQjBFQzRERTMyODNCMEU1AA==','read','','2026-07-16 12:05:07.708456','2026-07-16 12:05:34.097371',1,'2026-07-16 12:05:20.000000',NULL,'2026-07-16 12:05:34.000000','2026-07-16 12:05:16.000000'),(57,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRDY4MUY2ODAxRkQwRDQyNjA2AA==','read','','2026-07-16 12:10:35.761461','2026-07-16 12:10:38.979146',1,NULL,NULL,'2026-07-16 12:10:39.000000','2026-07-16 12:10:38.000000'),(58,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSM0JEODAzODBBQUZBQjVCMTA4AA==','read','','2026-07-16 12:10:37.119148','2026-07-16 12:30:10.445788',2,'2026-07-16 12:30:06.000000',NULL,'2026-07-16 12:30:10.000000','2026-07-16 12:10:39.000000'),(59,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 12:10:38.209301','2026-07-16 12:10:38.856140',50,NULL,NULL,NULL,NULL),(60,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 12:10:38.865686','2026-07-16 12:10:39.574845',51,NULL,NULL,NULL,NULL),(61,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 12:10:39.584586','2026-07-16 12:10:40.283822',52,NULL,NULL,NULL,NULL),(62,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 12:10:40.294323','2026-07-16 12:10:40.943045',53,NULL,NULL,NULL,NULL),(63,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 12:10:40.952995','2026-07-16 12:10:42.025711',54,NULL,NULL,NULL,NULL),(64,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 12:10:42.035028','2026-07-16 12:10:42.731570',55,NULL,NULL,NULL,NULL),(65,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 12:10:42.740837','2026-07-16 12:10:43.410463',56,NULL,NULL,NULL,NULL),(66,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-16 12:10:43.420523','2026-07-16 12:10:44.095398',57,NULL,NULL,NULL,NULL),(67,'hello_world','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNjI4RkI0NDlEODZFRkM1QzkyAA==','read','','2026-07-16 12:21:55.856516','2026-07-16 12:26:02.173583',1,'2026-07-16 12:22:01.000000',NULL,'2026-07-16 12:26:02.000000','2026-07-16 12:21:58.000000'),(68,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRjY0Qzg2OTFBN0U5N0IxRDREAA==','read','','2026-07-16 12:29:21.724995','2026-07-16 12:29:58.486359',1,'2026-07-16 12:29:34.000000',NULL,'2026-07-16 12:29:58.000000','2026-07-16 12:29:31.000000'),(69,'sea_news_channel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSOTY0OUNGRTI0RjgzMTY4RTVDAA==','read','','2026-07-16 13:14:35.186432','2026-07-16 13:15:12.005736',1,'2026-07-16 13:14:45.000000',NULL,'2026-07-16 13:15:11.000000','2026-07-16 13:14:44.000000'),(70,'sea_news_carousel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRUE1RjM4NDQ3QjUyMjJDNjE3AA==','read','','2026-07-16 13:20:24.606768','2026-07-16 13:20:57.652691',1,'2026-07-16 13:20:27.000000',NULL,'2026-07-16 13:20:57.000000','2026-07-16 13:20:27.000000'),(71,'hello_world','en_US',NULL,'failed','WhatsApp API request timeout ho gayi.','2026-07-17 04:47:07.303009','2026-07-17 04:47:28.355225',1,NULL,NULL,NULL,NULL),(72,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSODAzQjNBMzg0Q0E0Q0REQUI5AA==','read','','2026-07-17 04:49:02.376274','2026-07-17 06:30:47.008144',1,'2026-07-17 04:49:18.000000',NULL,'2026-07-17 04:51:03.000000','2026-07-17 04:49:17.000000'),(73,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRjAyNTk1NjEyMTM4ODA0MkQzAA==','read','','2026-07-17 04:52:46.669171','2026-07-17 04:53:34.087097',1,'2026-07-17 04:53:11.000000',NULL,'2026-07-17 04:53:34.000000','2026-07-17 04:53:11.000000'),(74,'sea_news_channel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMEE5NjEyNDMzMkFGMDNBRTJDAA==','read','','2026-07-17 05:02:29.304269','2026-07-17 05:03:27.370571',1,'2026-07-17 05:02:41.000000',NULL,'2026-07-17 05:03:27.000000','2026-07-17 05:02:40.000000'),(75,'payment_overdue_1','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNDI4MUQ5MzZCMDNBQUNDMTMzAA==','read','','2026-07-17 05:09:33.391963','2026-07-17 05:10:12.772982',1,'2026-07-17 05:09:55.000000',NULL,'2026-07-17 05:10:13.000000','2026-07-17 05:09:43.000000'),(76,'hello_world','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMkEwNjlGNkFDMkI0REE5RkQ1AA==','read','','2026-07-17 07:20:35.447708','2026-07-17 07:52:23.434980',1,'2026-07-17 07:20:41.000000',NULL,'2026-07-17 07:52:23.000000','2026-07-17 07:20:40.000000'),(77,'jinvani_channel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMTY5QkVCNTVCNjQwNkRCMDNBAA==','read','','2026-07-17 07:29:48.884018','2026-07-17 07:52:23.333311',1,'2026-07-17 07:30:08.000000',NULL,'2026-07-17 07:52:23.000000','2026-07-17 07:30:07.000000'),(78,'sea_news_carousel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNkMxNjdERTkwRDgwODQ5NkU3AA==','read','','2026-07-17 07:30:48.734272','2026-07-17 07:52:23.511331',1,'2026-07-17 07:30:53.000000',NULL,'2026-07-17 07:52:23.000000','2026-07-17 07:30:52.000000'),(79,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQ0QzMzk1QUE2MDQyRDUzM0RFAA==','read','','2026-07-17 07:33:19.857762','2026-07-17 07:52:23.201502',1,'2026-07-17 07:33:28.000000',NULL,'2026-07-17 07:52:23.000000','2026-07-17 07:33:25.000000'),(80,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSNzQyOTdDMjdFOUJGRDA0NTk2AA==','read','','2026-07-17 07:33:23.710422','2026-07-17 07:33:27.467620',2,'2026-07-17 10:16:46.000000',NULL,'2026-07-17 10:16:53.000000','2026-07-17 07:33:27.000000'),(81,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 07:33:26.223273','2026-07-17 07:33:26.223307',50,NULL,NULL,NULL,NULL),(82,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMjRGQzlERDZBQUY4Q0E5Qjg3AA==','read','','2026-07-17 07:42:13.911980','2026-07-17 07:52:23.094300',1,'2026-07-17 07:42:20.000000',NULL,'2026-07-17 07:52:23.000000','2026-07-17 07:42:19.000000'),(83,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMENGRDlGMThENEVCOTI5NEZCAA==','read','','2026-07-17 07:51:04.388310','2026-07-17 07:52:23.090162',1,'2026-07-17 07:51:17.000000',NULL,'2026-07-17 07:52:23.000000','2026-07-17 07:51:16.000000'),(84,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 07:57:07.807532','2026-07-17 07:57:07.807567',51,NULL,NULL,NULL,NULL),(85,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 07:57:11.584810','2026-07-17 07:57:11.584873',52,NULL,NULL,NULL,NULL),(86,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 07:57:12.672799','2026-07-17 07:57:12.672859',53,NULL,NULL,NULL,NULL),(87,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 07:57:13.702238','2026-07-17 07:57:13.702300',54,NULL,NULL,NULL,NULL),(88,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 07:57:14.387920','2026-07-17 07:57:14.387988',55,NULL,NULL,NULL,NULL),(89,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 07:57:17.654172','2026-07-17 07:57:17.654239',56,NULL,NULL,NULL,NULL),(90,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 07:57:19.071544','2026-07-17 07:57:19.071607',57,NULL,NULL,NULL,NULL),(91,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 07:57:23.843515','2026-07-17 07:57:23.843577',58,NULL,NULL,NULL,NULL),(92,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 07:57:24.747310','2026-07-17 07:57:24.747349',59,NULL,NULL,NULL,NULL),(94,'sea_news','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNzE5N0JFQkY2OTQyRDgwMjJDAA==','read','','2026-07-17 07:58:29.164124','2026-07-17 07:58:44.568197',1,'2026-07-17 07:58:44.000000',NULL,'2026-07-17 09:56:26.000000','2026-07-17 07:58:41.000000'),(95,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMzcyQkUxRDUyMkJGRjQzNjAwAA==','read','','2026-07-17 10:25:42.603592','2026-07-17 10:25:42.603620',1,'2026-07-17 10:41:00.000000',NULL,'2026-07-17 10:56:49.000000','2026-07-17 10:25:51.000000'),(96,'sea_news_update','en_US','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSRERCMzQ4RkFGQTE3MDAzOUIxAA==','delivered','','2026-07-17 10:25:45.944885','2026-07-17 10:25:45.944951',2,'2026-07-17 10:26:01.000000',NULL,NULL,'2026-07-17 10:26:01.000000'),(97,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 10:25:54.519683','2026-07-17 10:25:54.519746',50,NULL,NULL,NULL,NULL),(98,'payment_overdue_1','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSREVBQ0JFOUQ5OUI4NUYyRERDAA==','read','','2026-07-17 12:42:22.038193','2026-07-17 12:42:22.038226',1,'2026-07-17 12:42:32.000000',NULL,'2026-07-17 12:48:40.000000','2026-07-17 12:42:31.000000'),(99,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-17 13:20:54.259564','2026-07-17 13:20:54.259603',52,NULL,NULL,NULL,NULL),(100,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSOTE5M0Y3RThEQTExMkI0RjhFAA==','read','','2026-07-17 13:21:03.159142','2026-07-17 13:21:03.159170',1,'2026-07-17 13:21:15.000000',NULL,'2026-07-17 13:23:04.000000','2026-07-17 13:21:12.000000'),(101,'hello_world','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRTJBRUVCOTc1MjY5NUYyOEI4AA==','read','','2026-07-17 13:30:41.257087','2026-07-17 13:30:41.257119',1,'2026-07-17 13:30:44.000000',NULL,'2026-07-17 13:32:34.000000','2026-07-17 13:30:43.000000'),(102,'jinvani_channel','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQzU4RTFFN0VENDU4Q0Y4QkQ5AA==','read','','2026-07-17 13:41:24.715060','2026-07-17 13:41:24.715139',1,'2026-07-17 13:41:36.000000',NULL,'2026-07-17 13:42:48.000000','2026-07-17 13:41:32.000000'),(103,'latest_news_video','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRDE1NTZGRTI2Mzg0MUQxMDQxAA==','read','','2026-07-17 13:42:11.517311','2026-07-17 13:42:11.517422',1,'2026-07-17 13:42:20.000000',NULL,'2026-07-17 13:42:48.000000','2026-07-17 13:42:20.000000'),(104,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNEEzOURDQUFFNkU4RTU5RUQ1AA==','read','','2026-07-17 13:44:42.501271','2026-07-17 13:44:42.501310',1,NULL,NULL,'2026-07-17 13:44:50.000000','2026-07-17 13:44:50.000000'),(105,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRjlFREYxRDVFQkQ0RjE4QTVBAA==','read','','2026-07-18 04:49:38.312448','2026-07-18 04:49:38.312488',1,'2026-07-18 04:49:48.000000',NULL,'2026-07-18 04:50:13.000000','2026-07-18 04:49:48.000000'),(106,'sea_news_join','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSREY1MTJCMzgxN0M3RjU4MDA2AA==','read','','2026-07-18 04:52:19.857668','2026-07-18 04:52:19.857714',1,'2026-07-18 04:52:23.000000',NULL,'2026-07-18 06:25:24.000000','2026-07-18 04:52:22.000000'),(107,'sea_news_join','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSQjNDQTk5QzMwOEIzMTk5MEU1AA==','sent','','2026-07-18 04:52:20.998351','2026-07-18 04:52:20.998414',2,NULL,NULL,NULL,'2026-07-18 04:52:23.000000'),(108,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-18 04:52:23.720419','2026-07-18 04:52:23.720446',50,NULL,NULL,NULL,NULL),(109,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-18 04:52:25.079059','2026-07-18 04:52:25.079122',51,NULL,NULL,NULL,NULL),(110,'sea_news_join','en',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-18 04:52:39.739571','2026-07-18 04:52:39.739637',52,NULL,NULL,NULL,NULL),(111,'latest_news_video','hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMTY1NzI3MjZGNDEwRDQ0RTFCAA==','read','','2026-07-18 05:12:11.822722','2026-07-18 05:12:11.822797',1,'2026-07-18 05:12:23.000000',NULL,'2026-07-18 06:25:24.000000','2026-07-18 05:12:22.000000'),(112,'sea_news_join','en',NULL,'failed','(#131005) Access denied — There was a problem with the access token or permissions you are using for the API call.','2026-07-18 05:56:33.765742','2026-07-18 05:56:33.765785',1,NULL,NULL,NULL,NULL),(113,'sea_news_join','en',NULL,'failed','(#131005) Access denied — There was a problem with the access token or permissions you are using for the API call.','2026-07-18 05:57:01.092054','2026-07-18 05:57:01.092086',2,NULL,NULL,NULL,NULL),(114,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMEI5QkQ1QTQ0NTNBMkEyQ0EwAA==','read','','2026-07-18 06:25:01.510270','2026-07-18 06:25:01.510308',1,'2026-07-18 06:25:13.000000',NULL,'2026-07-18 06:25:24.000000','2026-07-18 06:25:12.000000'),(115,'sea_news_update','en_US',NULL,'failed','(#131030) Recipient phone number not in allowed list — Recipient phone number not in allowed list: Add recipient phone number to recipient list and try again.','2026-07-18 06:25:04.606956','2026-07-18 06:25:04.607020',50,NULL,NULL,NULL,NULL),(116,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMUU4Mjc0RUE2NDYwODM4N0JGAA==','read','','2026-07-18 06:47:23.166382','2026-07-18 06:47:23.166424',1,'2026-07-18 06:47:33.000000',NULL,'2026-07-18 06:59:46.000000','2026-07-18 06:47:31.000000'),(117,'document','en','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNjVCNjZBNzA1QkYyMjhCQjQyAA==','read','','2026-07-18 06:59:06.228020','2026-07-18 06:59:06.228052',1,'2026-07-18 06:59:24.000000',NULL,'2026-07-18 06:59:46.000000','2026-07-18 06:59:23.000000'),(118,'sea_news_update','en_US','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNjVEQzExRDc1QzExQ0Y0Mjg3AA==','delivered','','2026-07-18 07:56:15.458894','2026-07-18 07:56:15.459152',1,'2026-07-18 07:56:25.000000',NULL,NULL,'2026-07-18 07:56:24.000000'),(119,'sea_news','en','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSRTUwRjI1RTE2NEIwNkUwQTIzAA==','failed','Application does not have permission for this action [Meta code: 10] — Application does not have permission for this action','2026-07-18 07:57:35.644675','2026-07-18 07:57:35.645005',2,NULL,'2026-07-18 07:57:42.000000',NULL,NULL);
/*!40000 ALTER TABLE `myapp_messagelog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_outgoingreply`
--

DROP TABLE IF EXISTS `myapp_outgoingreply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_outgoingreply` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `reply_text` longtext NOT NULL,
  `meta_message_id` varchar(255) NOT NULL,
  `status` varchar(20) NOT NULL,
  `error_message` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `sent_at` datetime(6) DEFAULT NULL,
  `delivered_at` datetime(6) DEFAULT NULL,
  `read_at` datetime(6) DEFAULT NULL,
  `failed_at` datetime(6) DEFAULT NULL,
  `customer_id` bigint NOT NULL,
  `reply_to_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_outgoingreply_customer_id_e020b12e_fk_myapp_customer_id` (`customer_id`),
  KEY `myapp_outgoingreply_reply_to_id_61ae5033_fk_myapp_cus` (`reply_to_id`),
  KEY `myapp_outgoingreply_meta_message_id_8ebaf6c9` (`meta_message_id`),
  KEY `myapp_outgoingreply_status_39aa531f` (`status`),
  CONSTRAINT `myapp_outgoingreply_customer_id_e020b12e_fk_myapp_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `myapp_customer` (`id`),
  CONSTRAINT `myapp_outgoingreply_reply_to_id_61ae5033_fk_myapp_cus` FOREIGN KEY (`reply_to_id`) REFERENCES `myapp_customerreply` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_outgoingreply`
--

LOCK TABLES `myapp_outgoingreply` WRITE;
/*!40000 ALTER TABLE `myapp_outgoingreply` DISABLE KEYS */;
INSERT INTO `myapp_outgoingreply` VALUES (1,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:46.557782',NULL,NULL,NULL,'2026-07-17 09:49:46.568309',1,22),(2,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:48.675851',NULL,NULL,NULL,'2026-07-17 09:49:48.680470',1,22),(3,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:51.148485',NULL,NULL,NULL,'2026-07-17 09:49:51.152645',1,22),(4,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:51.396220',NULL,NULL,NULL,'2026-07-17 09:49:51.400772',1,22),(5,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:54.836439',NULL,NULL,NULL,'2026-07-17 09:49:54.842651',1,22),(6,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:55.555943',NULL,NULL,NULL,'2026-07-17 09:49:55.560080',1,22),(7,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:55.787889',NULL,NULL,NULL,'2026-07-17 09:49:55.792435',1,22),(8,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:55.979515',NULL,NULL,NULL,'2026-07-17 09:49:55.983424',1,22),(9,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:56.171747',NULL,NULL,NULL,'2026-07-17 09:49:56.176709',1,22),(10,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:56.364115',NULL,NULL,NULL,'2026-07-17 09:49:56.368565',1,22),(11,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:56.572853',NULL,NULL,NULL,'2026-07-17 09:49:56.577594',1,22),(12,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:56.771789',NULL,NULL,NULL,'2026-07-17 09:49:56.776012',1,22),(13,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:56.988023',NULL,NULL,NULL,'2026-07-17 09:49:56.992038',1,22),(14,'HLO','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:49:58.340016',NULL,NULL,NULL,'2026-07-17 09:49:58.344742',1,22),(15,'HI','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:56:50.332998',NULL,NULL,NULL,'2026-07-17 09:56:50.338609',1,23),(16,'HI','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:56:53.451934',NULL,NULL,NULL,'2026-07-17 09:56:53.456648',1,23),(17,'HI','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:56:53.667028',NULL,NULL,NULL,'2026-07-17 09:56:53.671650',1,23),(18,'HI','','failed','WHATSAPP_PHONE_NUMBER_ID settings me nahi mila.','2026-07-17 09:56:53.867360',NULL,NULL,NULL,'2026-07-17 09:56:53.871734',1,23),(19,'batayeyi me apki kya help kr skta hu','','failed','Authentication Error [Meta code: 190]','2026-07-17 10:01:54.956655',NULL,NULL,NULL,'2026-07-17 10:01:59.817449',1,23),(20,'hi','','failed','WhatsApp reply request timeout ho gayi.','2026-07-17 10:02:48.733333',NULL,NULL,NULL,'2026-07-17 10:03:03.090660',1,24),(21,'hi','','failed','Authentication Error [Meta code: 190]','2026-07-17 10:03:42.059205',NULL,NULL,NULL,'2026-07-17 10:03:44.038514',1,24),(22,'ki','','failed','Authentication Error [Meta code: 190]','2026-07-17 10:11:16.628650',NULL,NULL,NULL,'2026-07-17 10:11:19.373255',1,24),(23,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRjQ4NjA5MkY3QTUxMjUwMjQzAA==','read','','2026-07-17 10:13:59.547883',NULL,'2026-07-17 10:14:04.000000','2026-07-17 10:14:21.000000',NULL,1,24),(24,'batayiye me apki kya help kr skta hu','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQkIwRUM2QTM1RTlEODlDOENGAA==','read','','2026-07-17 10:14:51.725408','2026-07-17 10:14:55.000000',NULL,'2026-07-17 10:14:55.000000',NULL,1,25),(25,'yes sir ,how can i help uh','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMUFCNEUzMjg5ODdEQTVEOUYxAA==','read','','2026-07-17 10:15:54.795386','2026-07-17 10:15:56.000000',NULL,'2026-07-17 10:15:57.000000',NULL,1,26),(26,'hi','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSQ0MzNDY3Q0YyMDUxODVFMjYxAA==','read','','2026-07-17 10:16:19.162794','2026-07-17 10:16:21.000000','2026-07-17 10:16:46.000000','2026-07-17 10:16:53.000000',NULL,2,5),(27,'how can i help you?','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSMjc4QjRBNDc5MEQ5OUVGOUFEAA==','delivered','','2026-07-17 10:19:38.369869','2026-07-17 10:19:39.000000','2026-07-17 10:19:40.000000',NULL,NULL,2,5),(28,'yes sir','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMTQyQjc1QkU1OEMzOThBNEE4AA==','read','','2026-07-17 10:57:21.895211','2026-07-17 10:57:25.000000',NULL,'2026-07-17 10:57:27.000000',NULL,1,27),(29,'Yes tell me , how can i help you','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRDY5MkRFMjc3NkI4QkRDQkVFAA==','read','','2026-07-17 10:58:26.039881','2026-07-17 10:58:29.000000',NULL,'2026-07-17 10:58:29.000000',NULL,1,28),(30,'hi','wamid.HBgMOTE5NzU5OTk4MDMyFQIAERgSODBEQTNDQzI1NkE5RUQ3MjhCAA==','sent','','2026-07-17 11:13:42.725407','2026-07-17 11:13:45.000000',NULL,NULL,NULL,2,5),(31,'hello','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSOTVGQUQ0OTg1RkY4MDFDQzAwAA==','read','','2026-07-17 11:18:31.932635','2026-07-17 11:18:35.000000','2026-07-17 11:18:36.000000','2026-07-17 11:23:49.000000',NULL,1,28),(32,'hi','','failed','WhatsApp reply request timeout ho gayi.','2026-07-17 11:50:38.762378',NULL,NULL,NULL,'2026-07-17 11:50:48.832294',1,31),(33,'hi','','failed','WhatsApp reply request timeout ho gayi.','2026-07-17 11:51:08.770293',NULL,NULL,NULL,'2026-07-17 11:51:26.799465',1,31),(34,'hi','','failed','WhatsApp reply request timeout ho gayi.','2026-07-17 11:52:33.881994',NULL,NULL,NULL,'2026-07-17 11:52:44.030077',1,31),(35,'hi','','failed','WhatsApp reply request timeout ho gayi.','2026-07-17 11:52:57.145714',NULL,NULL,NULL,'2026-07-17 11:53:13.323704',2,5),(36,'hlo','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSODAzMjI3NkRDNzY3QTg2Q0QzAA==','read','','2026-07-17 11:53:41.042061','2026-07-17 11:53:45.000000','2026-07-17 11:53:48.000000','2026-07-17 12:36:19.000000',NULL,1,31),(37,'ji','','failed','WhatsApp reply request timeout ho gayi.','2026-07-17 12:18:09.784401',NULL,NULL,NULL,'2026-07-17 12:18:24.798897',1,31),(38,'hlo','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMjc0MEQ2NEE4QzhFMUU0MUNCAA==','read','','2026-07-17 12:18:42.999770','2026-07-17 12:18:54.000000','2026-07-17 12:18:56.000000','2026-07-17 12:36:19.000000',NULL,1,31),(39,'hlo','','failed','WhatsApp reply request timeout ho gayi.','2026-07-17 12:19:21.595946',NULL,NULL,NULL,'2026-07-17 12:19:40.983808',1,31),(40,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSREI2Qzg2RDVBOUNGQjNBMkZDAA==','read','','2026-07-17 12:30:02.546212','2026-07-17 12:30:20.000000','2026-07-17 12:30:20.000000','2026-07-17 12:36:19.000000',NULL,1,31),(41,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNjNEOTNENzI0MUQ1NUIzNDY4AA==','read','','2026-07-17 12:35:39.616272','2026-07-17 12:35:41.000000','2026-07-17 12:35:46.000000','2026-07-17 12:36:19.000000',NULL,1,31),(42,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMkNFNjc2QzNFRDRCRDYzRjlFAA==','read','','2026-07-17 12:36:56.013329','2026-07-17 12:37:00.000000',NULL,'2026-07-17 12:37:00.000000',NULL,1,33),(43,'h','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRTA2MTVFQTgwMEE0QjVDMUE3AA==','read','','2026-07-17 12:41:14.189717','2026-07-17 12:41:15.000000','2026-07-17 12:41:17.000000','2026-07-17 12:41:23.000000',NULL,1,33),(44,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQzhENkQ3NUQ4OEUzNjRFM0ZDAA==','read','','2026-07-17 12:45:52.973329','2026-07-17 12:45:54.000000','2026-07-17 12:45:58.000000','2026-07-17 12:48:40.000000',NULL,1,34),(45,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRTc2MUU2NzNFODJDOTk2MDQ1AA==','read','','2026-07-17 12:58:58.213402','2026-07-17 12:58:59.000000','2026-07-17 12:59:03.000000','2026-07-17 13:23:04.000000',NULL,1,35),(46,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSOTdFNjcwRkYyRjdDNEY0MEZGAA==','read','','2026-07-17 13:21:38.306620','2026-07-17 13:21:39.000000','2026-07-17 13:21:40.000000','2026-07-17 13:23:04.000000',NULL,1,35),(47,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMDMyMjM2OEFDQ0FGQzQzNzUwAA==','read','','2026-07-17 13:29:25.498945','2026-07-17 13:29:26.000000','2026-07-17 13:29:29.000000','2026-07-17 13:32:34.000000',NULL,1,36),(48,'yes','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNDI4QjYxRTYxQzg0RDg2ODg2AA==','read','','2026-07-17 13:43:18.856864','2026-07-17 13:43:20.000000',NULL,'2026-07-17 13:43:20.000000',NULL,1,37),(49,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSNDY2RjJBNzZENTlFQjhCMDA3AA==','read','','2026-07-18 04:50:22.102753','2026-07-18 04:50:24.000000','2026-07-18 04:50:24.000000','2026-07-18 06:25:24.000000',NULL,1,39),(50,'hlo','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMzVENUU4MkU2NDRDRjQ3RTE1AA==','read','','2026-07-18 04:55:19.030342','2026-07-18 04:55:21.000000','2026-07-18 04:55:21.000000','2026-07-18 06:25:24.000000',NULL,1,39),(51,'yes','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMjJGRkE3NkFENUUzNUUxNEI2AA==','sent','','2026-07-18 06:27:02.774166','2026-07-18 06:27:04.000000',NULL,'2026-07-18 06:27:05.000000',NULL,1,40),(52,'how can i help you','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRThEQ0UwMjNEM0Q0MTdDNDEzAA==','read','','2026-07-18 06:27:35.173140','2026-07-18 06:27:37.000000',NULL,'2026-07-18 06:27:37.000000',NULL,1,40),(53,'okey sir','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSOTIwMEE0OTg3MjI4MjJGMkUwAA==','sent','','2026-07-18 06:28:04.357390','2026-07-18 06:28:06.000000',NULL,'2026-07-18 06:28:06.000000',NULL,1,42),(54,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRjJEQjkyNEI4NjEwNEEzNEFGAA==','sent','','2026-07-18 06:28:22.053127','2026-07-18 06:28:24.000000',NULL,'2026-07-18 06:28:24.000000',NULL,1,42),(55,'hi','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSMzQ4NUI5MDkzQjEzQkJCMDY3AA==','read','','2026-07-18 06:28:56.788229','2026-07-18 06:28:58.000000',NULL,'2026-07-18 06:28:59.000000',NULL,1,42),(56,'jlo','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSQ0NBRjQ2QjBDMTQxQjQ5RDY2AA==','read','','2026-07-18 06:29:06.925023','2026-07-18 06:29:09.000000',NULL,'2026-07-18 06:29:09.000000',NULL,1,42),(57,'hlo','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSOTY0RUM3QTdENzU5NTFFRUQ4AA==','read','','2026-07-18 06:29:15.228820','2026-07-18 06:29:17.000000',NULL,'2026-07-18 06:29:17.000000',NULL,1,42),(58,'thik hu','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSN0Q0RDlGQ0ZGMkIxQjlBQTg2AA==','read','','2026-07-18 06:29:43.412774','2026-07-18 06:29:45.000000',NULL,'2026-07-18 06:29:45.000000',NULL,1,44),(59,'hm','wamid.HBgMOTE2Mzk4NTkyMDM5FQIAERgSRTlEOTUwN0I4RUJEQjg2MzI3AA==','read','','2026-07-18 06:30:05.372660','2026-07-18 06:30:10.000000','2026-07-18 06:30:10.000000','2026-07-18 06:30:14.000000',NULL,1,45);
/*!40000 ALTER TABLE `myapp_outgoingreply` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-18 15:55:56
