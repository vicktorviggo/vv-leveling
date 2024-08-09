CREATE TABLE IF NOT EXISTS `leveling` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `license` VARCHAR(255) NOT NULL,
  `citizenid` VARCHAR(50) NOT NULL,
  `experience` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_citizen_license` (`citizenid`, `license`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=1;