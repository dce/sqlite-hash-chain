PRAGMA foreign_keys = ON;

CREATE TABLE bookmarks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  url TEXT NOT NULL UNIQUE,
  parent_id INTEGER,
  FOREIGN KEY(parent_id) REFERENCES bookmarks(id)
);
