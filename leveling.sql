CREATE TABLE IF NOT EXISTS `leveling` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(255) NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `experience` text NOT NULL,
  PRIMARY KEY (`citizenid`),
  KEY `id` (`id`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=1;