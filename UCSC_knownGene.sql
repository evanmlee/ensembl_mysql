-- Host: localhost   
-- Database: UCSC_knownGene
-- ------------------------------------------------------
-- Server version	8.0.19

-- /*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
-- /*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
-- /*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
-- /*!40101 SET NAMES utf8 */;
-- /*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
-- /*!40103 SET TIME_ZONE='+00:00' */;
-- /*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
-- /*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
-- /*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
-- /*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for UCSC_transcript, data loading from text file.
--

DROP TABLE IF EXISTS `UCSC_transcript`;
CREATE TABLE `UCSC_transcript`(
	`UCSC_transcript_index` INT(10) unsigned NOT NULL AUTO_INCREMENT,
	`UCSC_transcript_id` VARCHAR(128) DEFAULT NULL,
	`transcript_stable_id` VARCHAR(128) DEFAULT NULL,
	`UCSC_version` smallint(5) unsigned DEFAULT NULL,
	PRIMARY KEY (`UCSC_transcript_index`)
);
LOAD DATA LOCAL INFILE '~/desktop/malab/conv_evo/ucsc/reorganized_data/knownGene_transcript_table.tsv'
INTO TABLE `UCSC_transcript`
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';

--
-- Table structure and intiialization for transcript/ gene ID mapping 
--


DROP TABLE IF EXISTS `UCSC_gene`;

CREATE TABLE `UCSC_gene`(
	`UCSC_transcript_index` INT(10) unsigned NOT NULL,
	`transcript_id` INT(10) unsigned NOT NULL, 
	`transcript_stable_id` VARCHAR(128) DEFAULT NULL,
	`gene_id` INT(10) unsigned NOT NULL,
	`gene_stable_id` VARCHAR(128) DEFAULT NULL
	)

SELECT UCSC_transcript_index, transcript.transcript_id, transcript.stable_id AS transcript_stable_id, 
		transcript.gene_id, gene.stable_id AS gene_stable_id 
FROM UCSC_transcript
INNER JOIN homo_sapiens_core_99_38.transcript AS transcript
-- ON transcript.stable_id = UCSC_transcript.transcript_stable_id
ON UCSC_transcript.transcript_stable_id = transcript.stable_id
INNER JOIN homo_sapiens_core_99_38.gene AS gene
ON transcript.gene_id = gene.gene_id
ORDER BY `UCSC_transcript_index`;

CREATE TABLE `UCSC_archive_transcript`(
	`UCSC_transcript_index` INT(10) unsigned NOT NULL,
	`UCSC_transcript_id` VARCHAR(128) DEFAULT NULL,
	`transcript_stable_id` VARCHAR(128) DEFAULT NULL,
	`version` smallint(5) unsigned DEFAULT NULL,
	PRIMARY KEY (`UCSC_transcript_index`)
)
SELECT * FROM `UCSC_transcript`
WHERE `UCSC_transcript_index` NOT IN (SELECT `UCSC_transcript_index` from `UCSC_gene`);

CREATE TABLE `UCSC_archive_gene`(
	`UCSC_transcript_index` INT(10) unsigned NOT NULL,
	`transcript_id` INT(10) unsigned NOT NULL, 
	`transcript_stable_id` VARCHAR(128) DEFAULT NULL,
	`gene_id` INT(10) unsigned NOT NULL,
	`gene_stable_id` VARCHAR(128) DEFAULT NULL
	)