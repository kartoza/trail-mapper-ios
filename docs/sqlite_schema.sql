-- Category table for POI's

CREATE TABLE "category" ("guid" TEXT PRIMARY KEY NOT NULL UNIQUE, "name" TEXT NOT NULL UNIQUE, "image" TEXT, "synchronised" BOOL DEFAULT 0);

-- Trail table

CREATE TABLE "trail" ("guid" TEXT PRIMARY KEY NOT NULL UNIQUE, "name" TEXT NOT NULL, "notes" TEXT, "offset" REAL NOT NULL DEFAULT 0.0, "colour" TEXT NOT NULL, "image_path" TEXT, "geometry" TEXT NOT NULL, "synchronised" BOOL DEFAULT 0);

-- Grade lookup table for trail_sections

CREATE TABLE "grade" ("guid" TEXT PRIMARY KEY NOT NULL UNIQUE, "name" TEXT NOT NULL UNIQUE, "image" TEXT, "synchronised" BOOL DEFAULT 0);

-- Trail Section table

Drop table trail_section;
CREATE TABLE "trail_section" ("guid" TEXT PRIMARY KEY NOT NULL UNIQUE, "name" TEXT NOT NULL, "notes" TEXT, "offset" REAL NOT NULL DEFAULT 0.0, "grade_guid" INTEGER NOT NULL REFERENCES  "grade"("guid") ON DELETE RESTRICT ON UPDATE CASCADE, "image_path" TEXT, "geometry" TEXT NOT NULL, "date_time_start" TIMESTAMP, "date_time_end" TIMESTAMP, "synchronised" BOOL DEFAULT 0);

-- Point of interest table

CREATE TABLE "point_of_interest" ("guid" TEXT PRIMARY KEY NOT NULL UNIQUE, "name" TEXT NOT NULL, "notes" TEXT, "category_guid" TEXT NOT NULL REFERENCES "category" ("guid") ON DELETE RESTRICT ON UPDATE CASCADE, "trail_section_guid" INTEGER NOT NULL REFERENCES "trail_section" ("guid") ON DELETE RESTRICT ON UPDATE CASCADE, "synchronised" BOOL DEFAULT 0);

-- Trail Sections many to many join between trail and trail_section

CREATE TABLE "trail_sections" ("trail_guid" TEXT NOT NULL UNIQUE REFERENCES "trail" ("guid") ON DELETE RESTRICT ON UPDATE CASCADE, "trail_section_guid" TEXT NOT NULL UNIQUE REFERENCES "trail_section" ("guid") ON DELETE RESTRICT ON UPDATE CASCADE, "order" INTEGER, "synchronised" BOOL DEFAULT 0, PRIMARY KEY ("trail_guid","trail_section_guid"));


-- Grades

INSERT INTO "grade" ( "guid","name","image" ) VALUES ( '34ebcde5-91c4-4b6b-b98e-da7e7942e46c','level','' );
INSERT INTO "grade" ( "guid","name","image" ) VALUES ( '01637f9e-6750-45d1-917e-c51d0684d7d2','gentle incline',NULL );
INSERT INTO "grade" ( "guid","name","image" ) VALUES ( '8f78a54b-30d4-4d59-8fd6-4d52f3cc2272','moderate incline',NULL );
INSERT INTO "grade" ( "guid","name","image" ) VALUES ( 'b6a817ed-36d6-4382-9356-8b1464b84a41','steep incline',NULL );
INSERT INTO "grade" ( "guid","name","image" ) VALUES ( 'de0227b1-709a-4dae-b226-1a50d1d8c622','vertical or near vertical',NULL );
INSERT INTO "grade" ( "guid","name","image" ) VALUES ( 'e0efbcc6-723a-4093-a125-5fe6944b525b','difficult to traverse',NULL );


-- Categories

INSERT INTO "category" ( "guid","name","image" ) VALUES ( '731426af-1b2d-4e91-8c23-976712cdd4fc','trail signage',NULL );
INSERT INTO "category" ( "guid","name","image" ) VALUES ( 'd38d4c35-dc2f-44de-a9ae-abe8b239095f','invasive vegetation',NULL );
INSERT INTO "category" ( "guid","name","image" ) VALUES ( '1bec08ae-00b3-4f13-a1f8-506440a7915f','trail condition',NULL );
INSERT INTO "category" ( "guid","name","image" ) VALUES ( '90dca3eb-7988-4b67-b12e-d5c62ad88251','scenic view',NULL );
INSERT INTO "category" ( "guid","name","image" ) VALUES ( 'e0e50574-3506-4a0a-9635-c01d9d0b7114','flora',NULL );
INSERT INTO "category" ( "guid","name","image" ) VALUES ( 'f23edf34-0530-4973-b094-a42f4e596a2b','fauna',NULL );
INSERT INTO "category" ( "guid","name","image" ) VALUES ( 'e3e1eeca-1743-4375-8a41-f5f0ba9940a1','geology',NULL );
INSERT INTO "category" ( "guid","name","image" ) VALUES ( '4f247594-b159-4704-aa42-5ec6081bf0cd','pollution',NULL );
INSERT INTO "category" ( "guid","name","image" ) VALUES ( '96dea52d-e962-4106-8e64-ad9023264f87','vandalism',NULL );
INSERT INTO "category" ( "guid","name","image" ) VALUES ( 'd68582fb-09c1-422d-8140-d22739ada83f','other',NULL );

