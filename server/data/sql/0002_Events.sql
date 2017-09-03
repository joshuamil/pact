CREATE TABLE "Event" (
  eventid serial PRIMARY KEY NOT NULL,
  keyname varchar NOT NULL,
  keyvalue int NOT NULL,
  action varchar, -- created, updated, deleted
  details varchar,
  personid int NOT NULL REFERENCES "People",
  occurred timestamp DEFAULT now(),
  deleted boolean DEFAULT false
);
CREATE INDEX idx_event_key ON "Event" (keyname, keyvalue);
CREATE INDEX idx_event_person ON "Event" (personid);
CREATE INDEX idx_event_active ON "Event" (eventid) WHERE deleted IS FALSE;
