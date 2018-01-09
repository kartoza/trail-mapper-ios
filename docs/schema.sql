-- Category table for POI's

CREATE TABLE "category" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, "guid" TEXT UNIQUE, "name" TEXT NOT NULL UNIQUE, "image" TEXT);

-- Trail table

CREATE TABLE "trail" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, "guid" TEXT UNIQUE, "name" TEXT NOT NULL, "notes" TEXT, "offset" REAL NOT NULL DEFAULT 0.0, "colour" TEXT NOT NULL, "image_path" TEXT, "geometry" TEXT NOT NULL);

-- Grade lookup table for trail_sections

CREATE TABLE "grade" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, "guid" TEXT UNIQUE, "name" TEXT NOT NULL UNIQUE, "image" TEXT);

-- Trail Section table

CREATE TABLE "trail_section" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, "guid" TEXT UNIQUE, "name" TEXT NOT NULL, "notes" TEXT, "offset" REAL NOT NULL DEFAULT 0.0, "grade_id" INTEGER NOT NULL REFERENCES  "grade"("id") ON DELETE RESTRICT ON UPDATE CASCADE, "image_path" TEXT, "geometry" TEXT NOT NULL, "date_time_start" TIMESTAMP, "date_time_end" TIMESTAMP);

-- Point of interest table

CREATE TABLE "point_of_interest" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, "guid" TEXT UNIQUE, "name" TEXT NOT NULL, "notes" TEXT, "category_id" INTEGER NOT NULL REFERENCES "category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE, "trail_section_id" INTEGER NOT NULL REFERENCES "trail_section" ("id") ON DELETE RESTRICT ON UPDATE CASCADE);

-- Trail Sections many to many join between trail and trail_section

CREATE TABLE "trail_sections" ("trail_id" INTEGER NOT NULL REFERENCES "trail" ("id") ON DELETE RESTRICT ON UPDATE CASCADE, "trail_section_id" INTEGER NOT NULL REFERENCES "trail_section" ("id") ON DELETE RESTRICT ON UPDATE CASCADE, "order" INTEGER, PRIMARY KEY ("trail_id","trail_section_id"));


-- Grades

INSERT INTO "grade" ( "id","guid","name","image" ) VALUES ( '1',NULL,'level','' );
INSERT INTO "grade" ( "id","guid","name","image" ) VALUES ( '2',NULL,'gentle incline',NULL );
INSERT INTO "grade" ( "id","guid","name","image" ) VALUES ( '3',NULL,'moderate incline',NULL );
INSERT INTO "grade" ( "id","guid","name","image" ) VALUES ( '4',NULL,'steep incline',NULL );
INSERT INTO "grade" ( "id","guid","name","image" ) VALUES ( '5',NULL,'vertical or near vertical',NULL );
INSERT INTO "grade" ( "id","guid","name","image" ) VALUES ( '6',NULL,'difficult to traverse',NULL );

-- Categories

INSERT INTO "category" ( "id","guid","name","image" ) VALUES ( '1',NULL,'trail signage',NULL );
INSERT INTO "category" ( "id","guid","name","image" ) VALUES ( '2',NULL,'invasive vegetation',NULL );
INSERT INTO "category" ( "id","guid","name","image" ) VALUES ( '3',NULL,'trail condition',NULL );
INSERT INTO "category" ( "id","guid","name","image" ) VALUES ( '4',NULL,'scenic view',NULL );
INSERT INTO "category" ( "id","guid","name","image" ) VALUES ( '5',NULL,'flora',NULL );
INSERT INTO "category" ( "id","guid","name","image" ) VALUES ( '6',NULL,'fauna',NULL );
INSERT INTO "category" ( "id","guid","name","image" ) VALUES ( '7',NULL,'geology',NULL );
INSERT INTO "category" ( "id","guid","name","image" ) VALUES ( '8',NULL,'pollution',NULL );
INSERT INTO "category" ( "id","guid","name","image" ) VALUES ( '9',NULL,'vandalism',NULL );
INSERT INTO "category" ( "id","guid","name","image" ) VALUES ( '10',NULL,'other',NULL );
