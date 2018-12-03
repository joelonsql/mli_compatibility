CREATE VIEW View_Changes AS
WITH
A AS (
    SELECT
        FilePath,
        FunctionName,
        Arguments,
        MIN(GitTimestamp)
    FROM Signatures
    GROUP BY FilePath, FunctionName, Arguments
),
B AS (
    SELECT
        FilePath,
        FunctionName,
        COUNT(*)
    FROM A
    GROUP BY FilePath,FunctionName
)
SELECT
    A.FilePath,
    A.FunctionName,
    A.MIN,
    A.Arguments,
    B.COUNT
FROM A
JOIN B ON B.FilePath = A.FilePath
      AND B.FunctionName = A.FunctionName
WHERE B.COUNT > 1
ORDER BY 1,2,3,4
;