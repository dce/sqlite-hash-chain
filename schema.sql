PRAGMA foreign_keys = ON;
SELECT load_extension("sha1");

CREATE TABLE bookmarks (
  id TEXT NOT NULL UNIQUE CHECK(id = sha1(url || parent_id)),
  parent_id TEXT,
  url TEXT NOT NULL UNIQUE,
  FOREIGN KEY(parent_id) REFERENCES bookmarks(id)
);

/* CREATE TRIGGER hash_chain_check */
/* BEFORE INSERT ON bookmarks */
/* BEGIN */
/*   SELECT RAISE(FAIL, "signature invalid") */
/*   FROM bookmarks */
/*   WHERE id = NEW.parent_id */
/*   AND NEW.signature != sha1(NEW.url || signature); */
/* END; */

CREATE UNIQUE INDEX parent_unique ON bookmarks (
  ifnull(parent_id, "")
);

INSERT INTO bookmarks (url, id) VALUES ("google", sha1("google"));

/* INSERT INTO bookmarks (url, signature, parent_id) VALUES ("yahoo", sha1("yahoo" || (SELECT signature FROM bookmarks WHERE id = 1)) , 1); */
/* INSERT INTO bookmarks (url, signature, parent_id) VALUES ("bing", sha1("bing" || (SELECT signature FROM bookmarks WHERE id = 2)), 2); */
/* INSERT INTO bookmarks (url, signature, parent_id) VALUES ("duckduckgo", sha1("duckduckgo" || (SELECT signature FROM bookmarks WHERE id = 3)), 3); */
