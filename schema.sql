PRAGMA foreign_keys = ON;
SELECT load_extension("sha1");

CREATE TABLE bookmarks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  url TEXT NOT NULL UNIQUE,
  parent_id INTEGER,
  signature TEXT NOT NULL CHECK(
    signature = sha1(url)
  ),
  FOREIGN KEY(parent_id) REFERENCES bookmarks(id)
);

CREATE UNIQUE INDEX parent_unique ON bookmarks (
  ifnull(parent_id, 0)
);

INSERT INTO bookmarks (url, signature) VALUES ("google", sha1("google"));
INSERT INTO bookmarks (url, signature, parent_id) VALUES ("yahoo", sha1("yahoo") , 1);
INSERT INTO bookmarks (url, signature, parent_id) VALUES ("bing", sha1("bing"), 2);
INSERT INTO bookmarks (url, signature, parent_id) VALUES ("duckduckgo", sha1("duckduckgo"), 3);
