DELIMITER $$
USE _databaseName$$

DROP PROCEDURE IF EXISTS `SearchRequestProcedure`$$

CREATE PROCEDURE `SearchRequestProcedure`(requestString VARCHAR(255))
BEGIN

DECLARE pointer INT DEFAULT 1;
DECLARE clearRequestString VARCHAR(255) DEFAULT '';
DECLARE currentChar VARCHAR(1);
DECLARE regExpForSequence VARCHAR(255);

CREATE TEMPORARY TABLE searchRequestResult(rowId INT NOT NULL AUTO_INCREMENT, rpId INT, rpNumber VARCHAR(255), PRIMARY KEY (rowId));
CREATE TEMPORARY TABLE fullNumberTable(fnpId INT, fnpNumber VARCHAR(255));

SET regExpForSequence = '%';

WHILE (pointer <= LENGTH(requestString))
DO
	SET currentChar = SUBSTRING(requestString, pointer, 1);	
	IF (currentChar REGEXP '[0-9]')
	THEN
    SET clearRequestString = CONCAT(clearRequestString, currentChar);
    SET regExpForSequence = CONCAT(regExpForSequence, currentChar, '%');
	END IF;
	SET pointer = pointer + 1;
END WHILE;

INSERT INTO fullNumberTable (fnpId, fnpNumber)
	SELECT product_id, REPLACE(_name, ' ', '') FROM _productsTable 
    WHERE
    (SELECT CompareNumbers(REPLACE(_name, ' ', ''), clearRequestString))	
    GROUP BY product_id;
    
INSERT INTO searchRequestResult (rpId, rpNumber)
	SELECT fnpId, fnpNumber FROM fullNumberTable
    WHERE CompareNumbersByRegExp(fnpNumber, CONCAT('%', clearRequestString, '%'));	
    
INSERT INTO searchRequestResult (rpId, rpNumber)
	SELECT fnpId, fnpNumber FROM fullNumberTable
	WHERE fnpNumber LIKE regExpForSequence;    
    
INSERT INTO searchRequestResult (rpId, rpNumber)
	SELECT fnpId, fnpNumber FROM fullNumberTable;

DROP TEMPORARY TABLE `fullNumberTable`;
DROP TEMPORARY TABLE `searchRequestResult`;

SELECT rpId, rpNumber FROM searchRequestResult
GROUP BY rpId
ORDER BY rowId ASC;
END$$
DELIMITER ;