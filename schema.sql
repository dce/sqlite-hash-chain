PRAGMA foreign_keys = ON;
SELECT load_extension("sha1");

CREATE TABLE bookmarks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  url TEXT NOT NULL UNIQUE,
  signature TEXT NOT NULL UNIQUE,
  parent_id INTEGER,
  FOREIGN KEY(parent_id) REFERENCES bookmarks(id)
);

CREATE TRIGGER hash_chain_check
BEFORE INSERT ON bookmarks
BEGIN
  SELECT RAISE(FAIL, "signature invalid")
  FROM bookmarks
  WHERE id = NEW.parent_id
  AND NEW.signature != sha1(NEW.url || signature);
END;

/* ALTER TABLE bookmarks */
/* ADD COLUMN signature TEXT NOT NULL CHECK( */
/*   signature = sha1(url) */
/* ); */

/* ALTER TABLE bookmarks */
/* ADD COLUMN signature TEXT NOT NULL CHECK( */
/*   signature = sha1(url || (SELECT signature FROM bookmarks AS b WHERE b.id = parent_id)) */
/* ); */

CREATE UNIQUE INDEX parent_unique ON bookmarks (
  ifnull(parent_id, 0)
);

INSERT INTO bookmarks (url, signature) VALUES ("google", sha1("google"));
INSERT INTO bookmarks (url, signature, parent_id) VALUES ("yahoo", sha1("yahoo" || (SELECT signature FROM bookmarks WHERE id = 1)) , 1);
INSERT INTO bookmarks (url, signature, parent_id) VALUES ("bing", sha1("bing" || (SELECT signature FROM bookmarks WHERE id = 2)), 2);
INSERT INTO bookmarks (url, signature, parent_id) VALUES ("duckduckgo", sha1("duckduckgo" || (SELECT signature FROM bookmarks WHERE id = 3)), 3);
