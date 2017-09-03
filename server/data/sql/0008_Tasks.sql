CREATE TABLE "Task" (
  taskid serial PRIMARY KEY NOT NULL,
  projectid int NOT NULL REFERENCES "Project",
  identifier varchar NOT NULL,
  title varchar NOT NULL,
  description varchar,
  estimate int NOT NULL DEFAULT 1,
  notes varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_task_project ON "Task" (projectid);
CREATE INDEX idx_task_active ON "Task" (taskid) WHERE deleted IS FALSE;


CREATE TABLE "Schedule" (
  scheduleid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  sprintid int NOT NULL REFERENCES "Sprint",
  deleted boolean DEFAULT false
);
CREATE INDEX idx_schedule_task ON "Schedule" (taskid);
CREATE INDEX idx_schedule_sprint ON "Schedule" (sprintid);
CREATE INDEX idx_task_active ON "Schedule" (scheduleid) WHERE deleted IS FALSE;


CREATE TABLE "Resource" (
  resourceid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  resource varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_resource_task ON "Task" (taskid);
CREATE INDEX idx_resource_active ON "Resource" (resourceid) WHERE deleted IS FALSE;


CREATE TABLE "Comment" (
  commentid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  comment varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_comment_task ON "Task" (taskid);
CREATE INDEX idx_comment_active ON "Comment" (commentid) WHERE deleted IS FALSE;


CREATE TABLE "Assignment" (
  assignmentid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  personid int REFERENCES "People",
  teamid int NOT NULL REFERENCES "Team",
  deleted boolean DEFAULT false
);
CREATE INDEX idx_assignment_task ON "Task" (taskid);
CREATE INDEX idx_assignment_person ON "Task" (personid);
CREATE INDEX idx_assignment_team ON "Task" (teamid);
CREATE INDEX idx_assignment_active ON "Assignment" (assignmentid) WHERE deleted IS FALSE;


CREATE TABLE "Status" (
  statusid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  status varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_status_task ON "Task" (taskid);
CREATE INDEX idx_status_active ON "Status" (statusid) WHERE deleted IS FALSE;


CREATE TABLE "Severity" (
  severityid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  severity varchar,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_severity_task ON "Task" (taskid);
CREATE INDEX idx_severity_active ON "Severity" (severityid) WHERE deleted IS FALSE;


CREATE TABLE "Priority" (
  priorityid serial PRIMARY KEY NOT NULL,
  taskid int NOT NULL REFERENCES "Task",
  priority int,
  deleted boolean DEFAULT false
);
CREATE INDEX idx_priority_task ON "Task" (taskid);
CREATE INDEX idx_priority_active ON "Priority" (priorityid) WHERE deleted IS FALSE;
