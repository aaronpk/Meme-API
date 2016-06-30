CREATE TABLE `memes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `tz` varchar(50) DEFAULT NULL,
  `nick` varchar(50) DEFAULT NULL,
  `channel` varchar(50) DEFAULT NULL,
  `server` varchar(50) DEFAULT NULL,
  `filename` varchar(50) DEFAULT NULL,
  `text` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
