CREATE TABLE IF NOT EXISTS "Team" (
  teamid serial PRIMARY KEY NOT NULL,
  projectid int NOT NULL REFERENCES "Project",
  name varchar NOT NULL,
  description varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_team_project ON "Team" (projectid);
CREATE INDEX IF NOT EXISTS idx_team_active ON "Team" (teamid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "Allocation" (
  allocationid serial PRIMARY KEY NOT NULL,
  teamid int NOT NULL REFERENCES "Team",
  personid int NOT NULL REFERENCES "People",
  teamlead boolean DEFAULT false,
  allocation int DEFAULT 100,
  execution int NOT NULL DEFAULT 6,
  planning int NOT NULL DEFAULT 2,
  startdate timestamp,
  enddate timestamp,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_allocation_team ON "Allocation" (teamid);
CREATE INDEX IF NOT EXISTS idx_allocation_people ON "Allocation" (personid);
CREATE INDEX IF NOT EXISTS idx_allocation_active ON "Allocation" (allocationid) WHERE deleted IS FALSE;
