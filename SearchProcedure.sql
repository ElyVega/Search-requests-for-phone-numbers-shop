DELIMITER $$
USE _databaseName$$

DROP PROCEDURE IF EXISTS `SearchRequestProcedure`$$

CREATE PROCEDURE `SearchRequestProcedure`(requestString VARCHAR(255))
BEGIN

DECLARE pointer INT DEFAULT 1;
DECLARE clearRequestString VARCHAR(255) DEFAULT '';
DECLARE currentChar VARCHAR(1);
DECLARE regExpForSequence VARCHAR(255);

/*result table where rowId saves output sequence*/
DROP TEMPORARY TABLE IF EXISTS `searchRequestResult`;
CREATE TEMPORARY TABLE searchRequestResult(rowId INT NOT NULL AUTO_INCREMENT, rpId INT, rpNumber VARCHAR(255), PRIMARY KEY (rowId));
/*tmp table with all numbers that satisfy the conditions*/
CREATE TEMPORARY TABLE fullNumberTable(fnpId INT, fnpNumber VARCHAR(255));
/*REGEXP that saves order for the search string in the original string*/
SET regExpForSequence = '%';
/*clearing search string from all not numeric characters - not required for clear search strings*/
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
/*add phone number to tmp table if numbers contains the same count of same digits from search string*/
INSERT INTO fullNumberTable (fnpId, fnpNumber)
	SELECT product_id, REPLACE(_name, ' ', '') FROM _productsTable 
    WHERE
    (SELECT CompareNumbers(REPLACE(_name, ' ', ''), clearRequestString))	
    GROUP BY product_id;
/*add phone number to result set if numbers contains full search string without any difference*/    
INSERT INTO searchRequestResult (rpId, rpNumber)
	SELECT fnpId, fnpNumber FROM fullNumberTable
    WHERE CompareNumbersByRegExp(fnpNumber, CONCAT('%', clearRequestString, '%'));	
/*add phone number to result set if number contains same sequence of search string digits*/        
INSERT INTO searchRequestResult (rpId, rpNumber)
	SELECT fnpId, fnpNumber FROM fullNumberTable
	WHERE fnpNumber LIKE regExpForSequence;    
/*add rest of phone numbers from tmp table to result set*/
INSERT INTO searchRequestResult (rpId, rpNumber)
	SELECT fnpId, fnpNumber FROM fullNumberTable;

DROP TEMPORARY TABLE `fullNumberTable`;

SELECT rpId, rpNumber FROM searchRequestResult
GROUP BY rpId
ORDER BY rowId ASC;
END$$
DELIMITER ;