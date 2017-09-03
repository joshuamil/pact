CREATE TABLE "Team" (
  teamid serial PRIMARY KEY NOT NULL,
  projectid int NOT NULL REFERENCES "Project",
  name varchar NOT NULL,
  description varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_team_project ON "Team" (projectid);
CREATE INDEX idx_team_active ON "Team" (teamid) WHERE deleted IS FALSE;


CREATE TABLE "Allocation" (
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
CREATE INDEX idx_allocation_team ON "Phase" (teamid);
CREATE INDEX idx_allocation_project ON "Phase" (projectid);
CREATE INDEX idx_allocation_active ON "Allocation" (allocationid) WHERE deleted IS FALSE;
