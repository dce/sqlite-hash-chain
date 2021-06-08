PRAGMA foreign_keys = ON;
SELECT load_extension("sha1");
.mode table

CREATE TABLE bookmarks (
  id INTEGER PRIMARY KEY,
  signature TEXT NOT NULL UNIQUE
    CHECK(signature = sha1(url || COALESCE(parent, ""))),
  parent TEXT,
  url TEXT NOT NULL UNIQUE,
  FOREIGN KEY(parent) REFERENCES bookmarks(signature)
);

CREATE UNIQUE INDEX parent_unique ON bookmarks (
  ifnull(parent, "")
);

/* INSERT SOME DATA */

INSERT INTO bookmarks (url, signature) VALUES ("google", sha1("google"));

WITH head AS (SELECT signature FROM bookmarks ORDER BY id DESC LIMIT 1)
INSERT INTO bookmarks (url, parent, signature) VALUES (
  "yahoo", (SELECT signature FROM head), sha1("yahoo" || (SELECT signature FROM head))
);

WITH head AS (SELECT signature FROM bookmarks ORDER BY id DESC LIMIT 1)
INSERT INTO bookmarks (url, parent, signature) VALUES (
  "bing", (SELECT signature FROM head), sha1("bing" || (SELECT signature FROM head))
);

WITH head AS (SELECT signature FROM bookmarks ORDER BY id DESC LIMIT 1)
INSERT INTO bookmarks (url, parent, signature) VALUES (
  "duckduckgo", (SELECT signature FROM head), sha1("duckduckgo" || (SELECT signature FROM head))
);

SELECT * FROM bookmarks;

/* DEMONSTRATE UPDATES */

WITH tmp(id, url, parent, signature) AS (VALUES
  (3, "altavista",
    "64633167b8e44cb833fbfa349731d8a68e942ebc",
    sha1("altavista" || "64633167b8e44cb833fbfa349731d8a68e942ebc")),
  (4, "duckduckgo",
    sha1("altavista" || "64633167b8e44cb833fbfa349731d8a68e942ebc"),
    sha1("duckduckgo" || sha1("altavista" || "64633167b8e44cb833fbfa349731d8a68e942ebc")))
)
UPDATE bookmarks
SET url = (SELECT url FROM tmp WHERE tmp.id = bookmarks.id),
    parent = (SELECT parent FROM tmp WHERE tmp.id = bookmarks.id),
    signature = (SELECT signature FROM tmp WHERE tmp.id = bookmarks.id)
WHERE id IN (SELECT id FROM tmp);

SELECT * FROM bookmarks;

WITH RECURSIVE
  t1(url, parent, old_signature, signature) AS (
    SELECT "askjeeves", parent, signature, sha1("askjeeves" || COALESCE(parent, ""))
    FROM bookmarks WHERE id = 2
    UNION
    SELECT t2.url, t1.signature, t2.signature, sha1(t2.url || t1.signature)
    FROM bookmarks AS t2, t1 WHERE t2.parent = t1.old_signature
  )
UPDATE bookmarks
SET url = (SELECT url FROM t1 WHERE t1.old_signature = bookmarks.signature),
    parent = (SELECT parent FROM t1 WHERE t1.old_signature = bookmarks.signature),
    signature = (SELECT signature FROM t1 WHERE t1.old_signature = bookmarks.signature)
WHERE signature IN (SELECT old_signature FROM t1);

SELECT * FROM bookmarks;
