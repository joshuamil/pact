CREATE TABLE "_Mood" (
  moodid serial PRIMARY KEY NOT NULL,
  value varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx__mood_active ON "_Mood" (moodid) WHERE deleted IS FALSE;

INSERT INTO "_Mood" (value)
  VALUES (':)'), (':|'), (':/'), (':(');


CREATE TABLE "_Severity" (
  severityid serial PRIMARY KEY NOT NULL,
  value varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx__severity_active ON "_Severity" (severityid) WHERE deleted IS FALSE;

INSERT INTO "_Severity" (value)
  VALUES ('High'),('Medium'),('Low');


CREATE TABLE "_Status" (
  statusid serial PRIMARY KEY NOT NULL,
  value varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx__status_active ON "_Status" (statusid) WHERE deleted IS FALSE;

INSERT INTO "_Status" (value)
  VALUES ('Pending'),('In-Progress'),('Blocked'),('Complete');


CREATE TABLE "_Settings" (
  settingsid serial PRIMARY KEY NOT NULL,
  active boolean DEFAULT true,
  sprintweeks int NOT NULL DEFAULT 2,
  hoursperpoint decimal(3,2) NOT NULL DEFAULT 4,
  riskblocker decimal(3,2) NOT NULL DEFAULT 2,
  riskdelay decimal(3,2) NOT NULL DEFAULT 2,
  riskearly decimal(3,2) NOT NULL DEFAULT -1,
  riskdebt decimal(3,2) NOT NULL DEFAULT .25,
  riskdebthours decimal(5,2) NOT NULL DEFAULT 25,
  estimatepartdev decimal(3,2) NOT NULL DEFAULT .66,
  estimatepartqa decimal(3,2) NOT NULL DEFAULT .34,
  deleted boolean DEFAULT false
);
CREATE INDEX idx__settings_active ON "_Settings" (settingsid) WHERE deleted IS FALSE;
