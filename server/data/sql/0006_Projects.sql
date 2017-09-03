CREATE TABLE "Project" (
  projectid serial PRIMARY KEY NOT NULL,
  name varchar,
  description varchar,
  abbrev varchar,
  startdate timestamp DEFAULT now(),
  enddate timestamp,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_project_active ON "Project" (projectid) WHERE deleted IS FALSE;


CREATE TABLE "Phase" (
  phaseid serial PRIMARY KEY NOT NULL,
  projectid int NOT NULL REFERENCES "Project",
  order int NOT NULL DEFAULT 0,
  name varchar,
  goals varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_phase_project ON "Phase" (projectid);
CREATE INDEX idx_phase_order ON "Phase" (order ASC);
CREATE INDEX idx_phase_active ON "Phase" (phaseid) WHERE deleted IS FALSE;


CREATE TABLE "Milestone" (
  milestoneid serial PRIMARY KEY NOT NULL,
  projectid int NOT NULL REFERENCES "Project",
  name varchar,
  description varchar,
  scheduledate timestamp NOT NULL,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_milestone_project ON "Milestone" (projectid);
CREATE INDEX idx_milestone_active ON "Milestone" (milestoneid) WHERE deleted IS FALSE;


CREATE TABLE "Sprint" (
  sprintid serial PRIMARY KEY NOT NULL,
  projectid int NOT NULL REFERENCES "Project",
  phaseid int NOT NULL REFERENCES "Phase",
  sprint int NOT NULL,
  startdate timestamp NOT NULL,
  enddate timestamp NOT NULL,
  demo boolean DEFAULT true,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_sprint_project ON "Sprint" (projectid);
CREATE INDEX idx_sprint_phase ON "Sprint" (phaseid);
CREATE INDEX idx_sprint_active ON "Sprint" (sprintid) WHERE deleted IS FALSE;
