CREATE TABLE IF NOT EXISTS "Risk" (
  riskid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  level int NOT NULL DEFAULT 1,
  notes varchar,
  deleted boolean default false
);
CREATE INDEX IF NOT EXISTS idx_status_task ON "Risk" (taskid);
CREATE INDEX IF NOT EXISTS idx_assignment_active ON "Risk" (riskid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "Debt" (
  debtid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  level int NOT NULL DEFAULT 1,
  notes varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_status_task ON "Debt" (taskid);
CREATE INDEX IF NOT EXISTS idx_assignment_active ON "Debt" (debtid) WHERE deleted IS FALSE;
