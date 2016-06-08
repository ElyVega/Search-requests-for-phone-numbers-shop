DELIMITER $$
USE _databaseName$$

DROP FUNCTION IF EXISTS `CompareNumbers`$$

CREATE FUNCTION `CompareNumbers`(extendedNumber VARCHAR(255), searchRequestRegExp VARCHAR(255)) RETURNS TINYINT
BEGIN

DECLARE iterPointer INT DEFAULT 0;
DECLARE extNumberPointer INT DEFAULT 1;
DECLARE extNumberPart VARCHAR(255);
/*cycle for products that includes a phone numbers sets where '10' is digits count for 1 phone number*/
WHILE (LENGTH(extendedNumber) >= extNumberPointer * 10)
DO
	SET extNumberPart = SUBSTRING(extendedNumber, 1 + ((extNumberPointer - 1) * 10), 10);
	/*compare result 'true' if phone number contains the same count of same digits from search string*/
	WHILE (iterPointer < 10)
	DO
		IF (LENGTH(extNumberPart) - LENGTH(REPLACE(extNumberPart, iterPointer, '')) < LENGTH(searchRequestRegExp) - LENGTH(REPLACE(searchRequestRegExp, iterPointer, '')))
			THEN
			RETURN 0;
		END IF;
		SET iterPointer = iterPointer + 1;
	END WHILE;
	SET extNumberPointer = extNumberPointer + 1;
END WHILE;

RETURN 1;

END$$

DELIMITER ;