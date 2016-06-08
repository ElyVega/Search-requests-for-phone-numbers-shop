DELIMITER $$
USE _databaseName$$

DROP FUNCTION IF EXISTS `CompareNumbersByRegExp`$$

CREATE FUNCTION `CompareNumbersByRegExp`(extendedNumber VARCHAR(255), searchRequestRegExp VARCHAR(255)) RETURNS TINYINT
BEGIN

DECLARE iterPointer INT DEFAULT 0;
DECLARE extNumberPointer INT DEFAULT 1;
DECLARE extNumberPart VARCHAR(255);
/*cycle for products that includes a phone numbers sets where '10' is digits count for 1 phone number*/
WHILE (LENGTH(extendedNumber) >= extNumberPointer * 10)
DO
	SET extNumberPart = SUBSTRING(extendedNumber, 1 + ((extNumberPointer - 1) * 10), 10);    
	IF (extNumberPart LIKE searchRequestRegExp)
	THEN
	RETURN 1;
	END IF;
	SET extNumberPointer = extNumberPointer + 1;
END WHILE;

RETURN 0;

END$$

DELIMITER ;