CREATE TABLE IF NOT EXISTS "Task" (
  taskid serial PRIMARY KEY NOT NULL,
  projectid int NOT NULL REFERENCES "Project",
  identifier varchar NOT NULL,
  title varchar NOT NULL,
  description varchar,
  estimate int NOT NULL DEFAULT 1,
  notes varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_task_project ON "Task" (projectid);
CREATE INDEX IF NOT EXISTS idx_task_active ON "Task" (taskid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "Status" (
  statusid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  status int NOT NULL REFERENCES "_Status" (statusid),
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_status_task ON "Status" (status);
CREATE INDEX IF NOT EXISTS idx_status_status ON "Status" (status);
CREATE INDEX IF NOT EXISTS idx_status_active ON "Status" (statusid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "Severity" (
  severityid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  severity int NOT NULL REFERENCES "_Severity" (severityid),
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_severity_task ON "Severity" (taskid);
CREATE INDEX IF NOT EXISTS idx_severity_severity ON "Severity" (severity);
CREATE INDEX IF NOT EXISTS idx_severity_active ON "Severity" (severityid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "Priority" (
  priorityid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  priority int NOT NULL DEFAULT 0,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_priority_task ON "Priority" (taskid);
CREATE INDEX IF NOT EXISTS idx_priority_priority ON "Priority" (priority);
CREATE INDEX IF NOT EXISTS idx_priority_active ON "Priority" (priorityid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "Resource" (
  resourceid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  resource varchar,
  description varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_resource_task ON "Resource" (taskid);
CREATE INDEX IF NOT EXISTS idx_resource_active ON "Resource" (resourceid) WHERE deleted IS FALSE;


CREATE TABLE IF NOT EXISTS "Comment" (
  commentid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  comment varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_comment_task ON "Comment" (taskid);
CREATE INDEX IF NOT EXISTS idx_comment_active ON "Comment" (commentid) WHERE deleted IS FALSE;
