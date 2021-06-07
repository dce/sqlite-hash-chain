PRAGMA foreign_keys = ON;
SELECT load_extension("sha1");

CREATE TABLE bookmarks (
  id INTEGER PRIMARY KEY,
  signature TEXT NOT NULL UNIQUE CHECK(signature = sha1(url || parent)),
  parent TEXT,
  url TEXT NOT NULL UNIQUE,
  FOREIGN KEY(parent) REFERENCES bookmarks(signature)
);

CREATE UNIQUE INDEX parent_unique ON bookmarks (
  ifnull(parent, "")
);

INSERT INTO bookmarks (url, signature) VALUES ("google", sha1("google"));

WITH parent AS (SELECT signature FROM bookmarks ORDER BY id DESC LIMIT 1)
INSERT INTO bookmarks (url, parent, signature) VALUES (
  "yahoo", (SELECT signature FROM parent), sha1("yahoo" || (SELECT signature FROM parent))
);

WITH parent AS (SELECT signature FROM bookmarks ORDER BY id DESC LIMIT 1)
INSERT INTO bookmarks (url, parent, signature) VALUES (
  "bing", (SELECT signature FROM parent), sha1("bing" || (SELECT signature FROM parent))
);

WITH parent AS (SELECT signature FROM bookmarks ORDER BY id DESC LIMIT 1)
INSERT INTO bookmarks (url, parent, signature) VALUES (
  "duckduckgo", (SELECT signature FROM parent), sha1("duckduckgo" || (SELECT signature FROM parent))
);

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
