-- Create the database
CREATE DATABASE FileSystem;

-- Use the database
USE FileSystem;

-- Create the FileSystem table
CREATE TABLE FileSystem (
    NodeID INT PRIMARY KEY,
    NodeName VARCHAR(255),
    ParentID INT,
    SizeBytes INT
);

-- Insert sample data into the FileSystem table
INSERT INTO FileSystem (NodeID, NodeName, ParentID, SizeBytes) VALUES
(1, 'Document', NULL, NULL),
(2, 'Pictures', NULL, NULL),
(3, 'File1.txt', 1, 500),
(4, 'Folder1', 1, NULL),
(5, 'Image.jpg', 2, 1200),
(6, 'Subfolder1', 4, NULL),
(7, 'File2.txt', 4, 750),
(8, 'File3.txt', 6, 300),
(9, 'Folder2', 2, NULL),
(10, 'File4.txt', 9, 250);

-- Query to calculate the total size of each folder and its subfolders
WITH RECURSIVE FileSystemCTE AS (
    SELECT 
        NodeID,
        NodeName,
        ParentID,
        COALESCE(SizeBytes, 0) AS SizeBytes
    FROM 
        FileSystem
    WHERE 
        ParentID IS NULL

    UNION ALL

    SELECT 
        fs.NodeID,
        fs.NodeName,
        fs.ParentID,
        COALESCE(fs.SizeBytes, 0)
    FROM 
        FileSystem fs
    INNER JOIN 
        FileSystemCTE cte ON fs.ParentID = cte.NodeID
)

SELECT 
    NodeID,
    NodeName,
    SUM(SizeBytes) AS TotalSizeBytes
FROM 
    FileSystemCTE
GROUP BY 
    NodeID, NodeName
ORDER BY 
    NodeID;
