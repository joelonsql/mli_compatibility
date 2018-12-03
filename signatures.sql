CREATE TABLE Signatures (
GitRepo text NOT NULL,
FilePath text NOT NULL,
FunctionName text NOT NULL,
GitTimestamp timestamptz NOT NULL,
Arguments text NOT NULL,
GitCommit text NOT NULL,
PRIMARY KEY (GitRepo, FilePath, FunctionName, GitTimestamp)
);
