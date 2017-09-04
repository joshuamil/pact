CREATE TABLE IF NOT EXISTS "Assignment" (
  assignmentid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  personid int REFERENCES "People",
  teamid int NOT NULL REFERENCES "Team",
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_assignment_task ON "Assignment" (taskid);
CREATE INDEX IF NOT EXISTS idx_assignment_person ON "Assignment" (personid);
CREATE INDEX IF NOT EXISTS idx_assignment_team ON "Assignment" (teamid);
CREATE INDEX IF NOT EXISTS idx_assignment_active ON "Assignment" (assignmentid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "Schedule" (
  scheduleid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  sprintid int NOT NULL REFERENCES "Sprint",
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_schedule_task ON "Schedule" (taskid);
CREATE INDEX IF NOT EXISTS idx_schedule_sprint ON "Schedule" (sprintid);
CREATE INDEX IF NOT EXISTS idx_task_active ON "Schedule" (scheduleid) WHERE deleted IS FALSE;
