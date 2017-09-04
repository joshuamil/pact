CREATE TABLE IF NOT EXISTS "People" (
  personid serial PRIMARY KEY NOT NULL,
  firstname varchar NOT NULL,
  lastname varchar NOT NULL,
  email varchar NOT NULL,
  phone varchar,
  avatar varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_people_active ON "People" (personid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "Holiday" (
  holidayid serial PRIMARY KEY NOT NULL,
  personid int REFERENCES "People",
  startdate timestamp,
  enddate timestamp,
  description varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_holiday_person ON "Holiday" (personid);
CREATE INDEX IF NOT EXISTS idx_holiday_active ON "Holiday" (holidayid) WHERE deleted IS FALSE;
