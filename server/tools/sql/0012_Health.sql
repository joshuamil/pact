CREATE TABLE IF NOT EXISTS "Health" (
  healthid serial PRIMARY KEY NOT NULL,
  projectid int NOT NULL REFERENCES "Project",
  phaseid int NOT NULL REFERENCES "Phase",
  sprintid int NOT NULL REFERENCES "Sprint",
  moodid int NOT NULL REFERENCES "_Mood",
  target decimal(5,2) DEFAULT 0,
  completed decimal(5,2) DEFAULT 0,
  risk decimal(5,2) DEFAULT 0,
  debt decimal(5,2) DEFAULT 0,
  blockers int DEFAULT 0,
  spilled decimal(5,2) DEFAULT 0,
  taskstodo decimal(5,2) DEFAULT 0,
  taskscomplete decimal(5,2) DEFAULT 0,
  taskstotal decimal(5,2) DEFAULT 0,
  daysinsprint int DEFAULT 0,
  daysinphase int DEFAULT 0,
  daystofreeze int DEFAULT 0,
  daystorelease int DEFAULT 0,
  deleted boolean NOT NULL DEFAULT false,
  createdat timestamp NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_health_project ON "Health" (projectid);
CREATE INDEX IF NOT EXISTS idx_health_phase ON "Health" (phaseid);
CREATE INDEX IF NOT EXISTS idx_health_sprint ON "Health" (sprintid);
CREATE INDEX IF NOT EXISTS idx_health_mood ON "Health" (moodid);
CREATE INDEX IF NOT EXISTS idx_health_active ON "Health" (healthid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "Retrospective" (
  retrospectiveid serial PRIMARY KEY NOT NULL,
  sprintid int NOT NULL REFERENCES "Sprint",
  moodid int NOT NULL REFERENCES "_Mood",
  accomplishments varchar,
  opportunities varchar,
  actionitems varchar,
  metgoals boolean NOT NULL DEFAULT false,
  velocity varchar NOT NULL DEFAULT '=',
  debt varchar NOT NULL DEFAULT '=',
  confidence decimal(5,2) NOT NULL DEFAULT 100,
  incidents int NOT NULL DEFAULT 0,
  deleted boolean NOT NULL DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_retros_sprint ON "Retrospective" (sprintid);
CREATE INDEX IF NOT EXISTS idx_retros_mood ON "Retrospective" (moodid);
CREATE INDEX IF NOT EXISTS idx_retros_active ON "Retrospective" (retrospectiveid) WHERE deleted IS FALSE;
