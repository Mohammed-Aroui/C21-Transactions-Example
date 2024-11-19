USE C21_DB1;

SELECT AccountID,Balance AS [Balance Before BEGIN TRANSACTION] from Accounts;

BEGIN TRANSACTION;

	BEGIN TRY
		-- Subtract $100 from Account 1
		UPDATE Accounts SET Balance = Balance - 100 WHERE AccountID = 1;
		SELECT AccountID,Balance AS [Balance after UPDATE 1] from Accounts;
		-- Add $100 to Account 2
		UPDATE Accounts SET Balance = Balance / 0 WHERE AccountID = 2;
		SELECT AccountID,Balance AS [Balance after UPDATE 2] from Accounts;
		-- Log the transaction
		INSERT INTO Transactions (FromAccount, ToAccount, Amount, Date) VALUES (1, 2, 100, GETDATE());
		SELECT AccountID,Balance AS [Balance after INSERT INTO] from Accounts;
		-- Commit the transaction
		COMMIT;

	END TRY
	BEGIN CATCH
		-- Rollback in case of error
		ROLLBACK;
		SELECT AccountID,Balance AS [Balance after ROLLBACK] from Accounts;
		-- Error handling code here (e.g., logging the error)
	END CATCH;
	
