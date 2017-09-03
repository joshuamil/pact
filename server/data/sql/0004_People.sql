CREATE TABLE "People" (
  personid serial PRIMARY KEY NOT NULL,
  firstname varchar NOT NULL,
  lastname varchar NOT NULL,
  email varchar NOT NULL,
  phone varchar,
  avatar varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_people_active ON "People" (personid) WHERE deleted IS FALSE;


CREATE TABLE "Holiday" (
  holidayid serial PRIMARY KEY NOT NULL,
  personid int NOT NULL REFERENCES "People",
  startdate timestamp,
  enddate timestamp
);
CREATE INDEX idx_holiday_person ON "Holiday" (personid);
CREATE INDEX idx_holiday_active ON "Holiday" (holidayid) WHERE deleted IS FALSE;
