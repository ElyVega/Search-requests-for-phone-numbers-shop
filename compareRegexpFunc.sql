DELIMITER $$
USE _databaseName$$

DROP FUNCTION IF EXISTS `CompareNumbersByRegExp`$$

CREATE FUNCTION `CompareNumbersByRegExp`(extendedNumber VARCHAR(255), searchRequestRegExp VARCHAR(255)) RETURNS TINYINT
BEGIN
	
DECLARE compareResult TINYINT DEFAULT 0;
DECLARE iterPointer INT DEFAULT 0;
DECLARE extNumberPointer INT DEFAULT 1;
DECLARE extNumberPart VARCHAR(255);

WHILE (LENGTH(extendedNumber) >= extNumberPointer * 10)
DO
	SET extNumberPart = SUBSTRING(extendedNumber, 1 + ((extNumberPointer - 1) * 10), 10);    
	IF (extNumberPart LIKE searchRequestRegExp)
	THEN
	SET compareResult = 1;
	END IF;
	SET extNumberPointer = extNumberPointer + 1;
END WHILE;

RETURN compareResult;

END$$

DELIMITER ;