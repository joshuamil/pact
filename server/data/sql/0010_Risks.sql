CREATE TABLE "Risk" (
  riskid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL,
  level int NOT NULL DEFAULT 1,
  notes varchar,
  deleted boolean default false
);
CREATE INDEX idx_status_task ON "Task" (taskid);
CREATE INDEX idx_assignment_active ON "Assignment" (assignmentid) WHERE deleted IS FALSE;


CREATE TABLE "Debt" (
  debtid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL,
  level int NOT NULL DEFAULT 1,
  notes varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_status_task ON "Task" (taskid);
CREATE INDEX idx_assignment_active ON "Assignment" (assignmentid) WHERE deleted IS FALSE;
