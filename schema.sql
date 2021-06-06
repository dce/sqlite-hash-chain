PRAGMA foreign_keys = ON;

CREATE TABLE bookmarks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  url TEXT NOT NULL UNIQUE,
  parent_id INTEGER,
  FOREIGN KEY(parent_id) REFERENCES bookmarks(id)
);

INSERT INTO bookmarks (url) VALUES ("google");
INSERT INTO bookmarks (url, parent_id) VALUES ("yahoo", 1);
INSERT INTO bookmarks (url, parent_id) VALUES ("bing", 2);
INSERT INTO bookmarks (url, parent_id) VALUES ("duckduckgo", 3);
