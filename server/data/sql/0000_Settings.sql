CREATE TABLE IF NOT EXISTS "_Number" (
  num int UNIQUE PRIMARY KEY NOT NULL
);


CREATE TABLE IF NOT EXISTS "_Date" (
  dateid serial PRIMARY KEY NOT NULL,
  year int NOT NULL,
  month int NOT NULL,
  day int NOT NULL,
  complete timestamp NOT NULL
);


CREATE TABLE IF NOT EXISTS "_Mood" (
  moodid serial PRIMARY KEY NOT NULL,
  value varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx__mood_active ON "_Mood" (moodid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "_Severity" (
  severityid serial PRIMARY KEY NOT NULL,
  value varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx__severity_active ON "_Severity" (severityid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "_Status" (
  statusid serial PRIMARY KEY NOT NULL,
  value varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx__status_active ON "_Status" (statusid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "_Point" (
  pointid serial PRIMARY KEY NOT NULL,
  value int NOT NULL,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx__points_active ON "_Point" (pointid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "_Settings" (
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
  zeropadtaskid boolean DEFAULT true,
  zeropadlength int DEFAULT 4,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx__settings_active ON "_Settings" (settingsid) WHERE deleted IS FALSE;
