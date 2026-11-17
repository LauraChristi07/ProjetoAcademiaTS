-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: academia
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `exercicios`
--

DROP TABLE IF EXISTS `exercicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exercicios` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `usuario_id` int unsigned NOT NULL,
  `nome` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_exercicios_usuario_nome` (`usuario_id`,`nome`),
  CONSTRAINT `fk_exercicios_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercicios`
--

LOCK TABLES `exercicios` WRITE;
/*!40000 ALTER TABLE `exercicios` DISABLE KEYS */;
INSERT INTO `exercicios` VALUES (1,1,'Agachamento livre'),(3,1,'Cadeira extensora'),(2,1,'Leg press'),(10,1,'Rosca direta'),(12,1,'Rosca martelo'),(11,1,'Tríceps com barra'),(5,2,'Agachamento búlgaro'),(14,2,'Crucifixo'),(6,2,'Elevação pélvica'),(15,2,'Pullover'),(4,2,'Stiff'),(13,2,'Supino'),(8,3,'Bicicleta'),(7,3,'Corrida'),(9,3,'Esteira'),(18,3,'Puxada alta'),(17,3,'Remada baixa'),(16,3,'Remada curvada');
/*!40000 ALTER TABLE `exercicios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarefa_exercicio`
--

DROP TABLE IF EXISTS `tarefa_exercicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarefa_exercicio` (
  `tarefa_id` int unsigned NOT NULL,
  `exercicio_id` int unsigned NOT NULL,
  PRIMARY KEY (`tarefa_id`,`exercicio_id`),
  KEY `fk_tarefa_exercicio_exercicio` (`exercicio_id`),
  CONSTRAINT `fk_tarefa_exercicio_exercicio` FOREIGN KEY (`exercicio_id`) REFERENCES `exercicios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tarefa_exercicio_tarefa` FOREIGN KEY (`tarefa_id`) REFERENCES `tarefas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarefa_exercicio`
--

LOCK TABLES `tarefa_exercicio` WRITE;
/*!40000 ALTER TABLE `tarefa_exercicio` DISABLE KEYS */;
INSERT INTO `tarefa_exercicio` VALUES (1,1),(2,2),(3,3);
/*!40000 ALTER TABLE `tarefa_exercicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarefas`
--

DROP TABLE IF EXISTS `tarefas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarefas` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `usuario_id` int unsigned NOT NULL,
  `titulo` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descricao` text COLLATE utf8mb4_unicode_ci,
  `nivel` enum('facil','medio','dificil') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medio',
  `status` enum('planejado','feito','pulado') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planejado',
  `prazo` date DEFAULT NULL,
  `criada_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizada_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `concluida_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tarefas_usuario` (`usuario_id`),
  CONSTRAINT `fk_tarefas_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ck_tarefas_titulo` CHECK ((char_length(trim(`titulo`)) >= 3))
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarefas`
--

LOCK TABLES `tarefas` WRITE;
/*!40000 ALTER TABLE `tarefas` DISABLE KEYS */;
INSERT INTO `tarefas` VALUES (26,2,'Treino de glúteos',NULL,'facil','feito',NULL,'2026-11-17 17:49:12','2026-11-17 18:44:12','2026-11-17 18:44:12'),(27,3,'Treino de cardio','PR #42','medio','feito',NULL,'2026-11-17 17:49:12','2026-11-17 18:28:09','2026-11-17 18:28:09'),(28,4,'Treino de braços',NULL,'facil','feito',NULL,'2026-11-17 17:49:12','2026-11-17 18:28:14','2026-11-17 18:28:14'),(29,5,'Treino de peito',NULL,'medio','pulado',NULL,'2026-11-17 17:49:12','2026-11-17 18:25:37',NULL),(30,6,'Treino de costas',NULL,'dificil','planejado',NULL,'2026-11-17 17:49:12','2026-11-17 17:49:12',NULL),(32,10,'Treino de pernas','PR #42','medio','planejado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(33,12,'Treino de pernas','PR #42','medio','planejado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(34,3,'Treino de pernas','PR #42','medio','planejado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(35,2,'Treino de pernas','PR #42','medio','planejado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(36,10,'Treino de glúteos',NULL,'facil','feito',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(37,12,'Treino de glúteos',NULL,'facil','feito',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(38,3,'Treino de glúteos',NULL,'facil','feito',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(40,10,'Treino de cardio','PR #42','medio','feito',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(41,12,'Treino de cardio','PR #42','medio','feito',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(42,2,'Treino de cardio','PR #42','medio','feito',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(44,10,'Treino de braços',NULL,'facil','feito',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(45,12,'Treino de braços',NULL,'facil','feito',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(46,3,'Treino de braços',NULL,'facil','feito',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(47,2,'Treino de braços',NULL,'facil','feito',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(49,10,'Treino de peito',NULL,'medio','pulado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(50,12,'Treino de peito',NULL,'medio','pulado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(51,3,'Treino de peito',NULL,'medio','pulado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(52,2,'Treino de peito',NULL,'medio','pulado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(54,10,'Treino de costas',NULL,'dificil','planejado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(55,12,'Treino de costas',NULL,'dificil','planejado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(56,3,'Treino de costas',NULL,'dificil','planejado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(57,2,'Treino de costas',NULL,'dificil','planejado',NULL,'2026-11-17 19:31:28','2026-11-17 19:31:28',NULL),(63,13,'Treino de pernas','PR #42','medio','planejado',NULL,'2026-11-17 19:35:57','2026-11-17 19:35:57',NULL),(64,13,'Treino de glúteos','','facil','feito',NULL,'2026-11-17 19:35:57','2026-11-17 19:35:57',NULL),(65,13,'Treino de cardio','PR #42','medio','feito',NULL,'2026-11-17 19:35:57','2026-11-17 19:35:57',NULL),(66,13,'Treino de braços','','facil','feito',NULL,'2026-11-17 19:35:57','2026-11-17 19:35:57',NULL),(67,13,'Treino de peito','','medio','pulado',NULL,'2026-11-17 19:35:57','2026-11-17 19:35:57',NULL),(68,13,'Treino de costas','','dificil','planejado',NULL,'2026-11-17 19:35:57','2026-11-17 19:35:57',NULL),(69,1,'Treino de Perna',NULL,'medio','planejado',NULL,'2026-11-17 20:15:50','2026-11-17 20:15:50',NULL),(70,1,'Treino de Glúteos',NULL,'medio','pulado',NULL,'2026-11-17 20:16:08','2026-11-17 20:17:09',NULL),(71,1,'Treino de Braços',NULL,'medio','feito',NULL,'2026-11-17 20:16:19','2026-11-17 20:17:13','2026-11-17 20:17:13'),(72,1,'Treino de Cardio',NULL,'dificil','feito',NULL,'2026-11-17 20:16:30','2026-11-17 20:17:12','2026-11-17 20:17:12'),(73,1,'Treino de Abdomen',NULL,'dificil','planejado',NULL,'2026-11-17 20:16:40','2026-11-17 20:16:40',NULL),(74,1,'Treino de Peito',NULL,'dificil','planejado',NULL,'2026-11-17 20:17:06','2026-11-17 20:17:06',NULL);
/*!40000 ALTER TABLE `tarefas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `senha_hash` char(60) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'hash bcrypt, NUNCA a senha',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_usuarios_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Ana','ana@email.com','$2b$10$WbRjyIfWyb6.tcLH86.rcu3UGVLHFlwvjrU1JiQHfdcM.NsOgxWry','2026-11-17 17:47:45'),(2,'Bruno','bruno@email.com','$2b$10$qK9qxGEoKLWoBwSTYOzsj.rhQklyIu9ELY8ccxBik1TRWru/bpvNi','2026-11-17 17:47:45'),(3,'Carla','carla@email.com','$2b$10$lGSgVuubpR/mIFr5YMKp9uM92.MVVMBz96SgGqCiffas65aayOpc2','2026-11-17 17:47:45'),(10,'laura','laura@email.com','$2b$10$wis7xaQe6ALaZOOdEcjr/ulqrcRcAIyJ3tDDk3lZvfQPRbM8hk/7W','2026-11-17 17:50:35'),(12,'julia','julia@email.com','$2b$10$qAqCgQzHLJqthum9hvVp8.R662mxZaI0rogKHm1rV3zmztWJR1m.i','2026-11-17 18:33:44'),(13,'diogo','diogo@email.com','$2b$10$9tyOs7afQda765S0w.ozCeEXElZg5t5wE0iQJo9k.ZdvQdljT8iZ.','2026-11-17 19:35:57');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-17 20:25:30
