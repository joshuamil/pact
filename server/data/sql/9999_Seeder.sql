/* Insert Numbers and Dates for Complex Query Support */

-- Generates number range 1-10,000
INSERT INTO "_Number" (num)
SELECT x.id FROM generate_series(1,10000) AS x(id);

-- Generates dates for the next 4 years
INSERT INTO "_Date" (year, month, day, complete)
SELECT
  y.y, m.m, d.d, CAST(y.y || '-' || m.m || '-' || d.d AS date)
FROM generate_series(
    CAST(date_part('year',now()) AS INT),
    CAST(date_part('year',now() + interval '3 years') AS INT)
  ) y(y)
  INNER JOIN generate_series(1,12) m(m) ON 1=1
  INNER JOIN generate_series(1,31) d(d) ON
    1=1
    AND (
      (
        (m.m IN (2) AND d.d <= 28)
        OR (m.m IN (2) AND y.y % 4 = 0 AND d.d <= 29)
      )
      OR (m.m IN (9, 4, 6, 11) AND d.d <= 30)
      OR (m.m IN (1, 3, 5, 7, 8, 10, 12) AND d.d <= 31)
    )
ORDER BY
  y.y, m.m, d.d


/* Insert Default Enumeratsions and Settings */

INSERT INTO "_Mood" (value)
  VALUES (':)'), (':|'), (':/'), (':(');

INSERT INTO "_Severity" (value)
  VALUES ('High'),('Medium'),('Low');

INSERT INTO "_Status" (value)
  VALUES ('Pending'),('In-Progress'),('Blocked'),('Complete');

INSERT INTO "_Settings" (active) VALUES (true);

INSERT INTO "_Points" (value) SELECT fib(400);


/* Pre-Defined Data */

INSERT INTO "Holiday" (startdate, enddate, description)
VALUES
  ('2017-09-04 00:00:00', '2017-09-04 23:59:59', 'Labor Day'),
  ('2017-10-09 00:00:00', '2017-10-09 23:59:59', 'Columbus Day'),
  ('2017-11-10 00:00:00', '2017-11-10 23:59:59', 'Veterans Day'),
  ('2017-11-23 00:00:00', '2017-11-23 23:59:59', 'Thanksgiving Day'),
  ('2017-12-25 00:00:00', '2017-12-25 23:59:59', 'Christmas Day'),
  ('2018-01-01 00:00:00', '2018-01-01 23:59:59', 'New Year\'s Day'),
  ('2018-01-15 00:00:00', '2018-01-15 23:59:59', 'Martin Luther King, Jr.'),
  ('2018-02-19 00:00:00', '2018-02-19 23:59:59', 'President\'s Day'),
  ('2018-03-28 00:00:00', '2018-03-28 23:59:59', 'Memorial Day'),
  ('2018-07-04 00:00:00', '2018-07-04 23:59:59', 'Independence Day'),
  ('2018-09-03 00:00:00', '2018-09-03 23:59:59', 'Labor Day'),
  ('2018-10-08 00:00:00', '2018-10-08 23:59:59', 'Columbus Day'),
  ('2018-11-12 00:00:00', '2018-11-12 23:59:59', 'Veterans Day'),
  ('2018-11-22 00:00:00', '2018-11-22 23:59:59', 'Thanksgiving Day'),
  ('2018-12-25 00:00:00', '2018-12-25 23:59:59', 'Christmas Day');


/* Data for testing */

INSERT INTO "People"
  (firstname, lastname, email, phone, avatar)
VALUES
  ('Joshua', 'Miller', 'joshuamil@gmail.com', '7046517472', 'https://avatars3.githubusercontent.com/u/1080695?v=4&s=400')


/* Creates a default Project that runs for 15 Sprints */
INSERT INTO "Project"
  (name, description, abbrev, startdate, enddate)
SELECT
  'PACT',
  'Default project for testing the application.',
  'PACT',
  CURRENT_DATE,
  CURRENT_DATE + (S.sprintweeks*15 || ' week')::interval
FROM "_Settings" S
LIMIT 1;


/* Creates 5 Phases in the default Project */
INSERT INTO "Phase"
  (projectid, sort, name, goals)
SELECT
  PR.projectid, N.num, 'Phase ' || N.num, 'Default goals for Phase ' || N.num
FROM "Project" PR
  INNER JOIN "_Number" N ON N.num <= 5
WHERE PR.name = 'PACT'
ORDER BY projectid ASC;


/* Creates 5 Milestones in the default Project */
INSERT INTO "Milestone"
  (projectid, name, description, scheduledate)
SELECT
  PR.projectid,
  'Milestone ' || N.num,
  'Deliverable ' || N.num || ' for the sample project',
  CURRENT_DATE + ((S.sprintweeks*2)*(N.num + 2) || ' week')::interval
FROM "Project" PR
  INNER JOIN "_Settings" S ON 1=1
  INNER JOIN "_Number" N ON N.num <= 5
WHERE PR.name = 'PACT';


/* Creates 3 Sprints for each Phase in the default Project */
INSERT INTO "Sprint"
  (projectid, phaseid, sprint, startdate, enddate, goals)
SELECT
  PR.projectid,
  PH.phaseid,
  row_number() OVER () as sprint,
  CURRENT_DATE + ((S.sprintweeks*(row_number() OVER ()-1)*7) || ' day')::interval AS startdate,
  CURRENT_DATE + (((S.sprintweeks*(row_number() OVER ()-1)+2)*7)-1 || ' day')::interval AS enddate,
  'Goals for Sprint ' || row_number() OVER() as goals
FROM "Project" PR
  INNER JOIN "Phase" PH ON PR.projectid = PH.projectid
  INNER JOIN "_Settings" S ON 1=1
  INNER JOIN "_Number" N ON N.num <= 3
WHERE PR.name = 'PACT';


/* Insert Team Mebers */
INSERT INTO "Team"
  (projectid, name, description)
SELECT
  PR.projectid, 'Development', 'Programming team for the ' || PR.name || ' project'
FROM "Project" PR
WHERE PR.name = 'PACT'
LIMIT 1;


/* Insert Team Allocation */
INSERT INTO "Allocation"
  (teamid, personid, teamlead, startdate, enddate)
SELECT
  T.teamid,
  P.personid,
  true,
  PR.startdate,
  PR.enddate
FROM "Team" T
  INNER JOIN "People" P ON 1=1
  INNER JOIN "Project" PR ON
    T.projectid = PR.projectid
LIMIT 1;


/* Insert sample Tasks based on the current Project */
WITH words(word, num) as (
  VALUES
  ('one', 1),('two', 2),('three', 3),('four', 4),('five', 5),
  ('six', 6),('seven', 7),('eight', 8),('nine', 9),('ten', 10)
),
POINT AS (
  SELECT F, row_number() OVER(ORDER BY random()) AS "row"
  FROM fib(200) F
  WHERE F > 0
)
INSERT INTO "Task"
  (projectid, identifier, title, description, estimate, notes)
SELECT
  PR.projectid,
  PR.abbrev || '-' || Right(CAST('0000' || N.num AS varchar), S.zeropadlength),
  'Task number ' || W.word,
  'This is the description for task number ' || W.word,
  POINT.f,
  ''
FROM "Project" PR
  INNER JOIN "_Settings" S ON 1=1
  INNER JOIN "_Number" N ON N.num <= 10
  INNER JOIN "words" W ON W.num = N.num
  INNER JOIN POINT ON N.num = POINT.row
WHERE PR.name = 'PACT';

/* Insert Task Status */
INSERT INTO "Status"
  (taskid, status)
SELECT
  T.taskid, S.statusid
FROM "Task" T
  INNER JOIN "_Status" S ON 1=1 AND S.value = 'Pending';


/* Insert Task Severity */
INSERT INTO "Severity"
  (taskid, severity)
SELECT
  T.taskid, S.severityid
FROM "Task" T
  INNER JOIN "_Severity" S ON 1=1 AND S.value = 'Medium';


/* Insert Task Priority */
INSERT INTO "Priority"
  (taskid, priority)
SELECT
  T.taskid, 1
FROM "Task" T;


/* Insert Task Assignment */
INSERT INTO "Assignment"
  (taskid, personid, teamid)
SELECT
  T.taskid,
  P.personid,
  TE.teamid
FROM "Task" T
  INNER JOIN "People" P ON 1=1
  INNER JOIN "Allocation" A ON P.personid = A.personid
  INNER JOIN "Team" TE ON A.teamid = TE.teamid;


/* Insert default schedule */
INSERT INTO "Schedule"
  (taskid, sprintid)
SELECT
  T.taskid,
  CAST(Ceil((row_number() OVER() / 2) + 1) AS INT)
FROM "Project" PR
  INNER JOIN "Task" T ON
    PR.projectid = T.projectid
  INNER JOIN "Sprint" S ON
    PR.projectid = S.projectid
    AND T.taskid = S.sprintid
WHERE PR.name = 'PACT';


/* Insert Event Records
 * Note that this block can be re-generated using /server/data/sql/_Generate_Events.sql
 */
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'allocationid', allocationid, 'created', 'Record created by seeder', 1 FROM "Allocation";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'assignmentid', assignmentid, 'created', 'Record created by seeder', 1 FROM "Assignment";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'commentid', commentid, 'created', 'Record created by seeder', 1 FROM "Comment";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'debtid', debtid, 'created', 'Record created by seeder', 1 FROM "Debt";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'healthid', healthid, 'created', 'Record created by seeder', 1 FROM "Health";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'holidayid', holidayid, 'created', 'Record created by seeder', 1 FROM "Holiday";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'milestoneid', milestoneid, 'created', 'Record created by seeder', 1 FROM "Milestone";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'moodid', moodid, 'created', 'Record created by seeder', 1 FROM "_Mood";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'personid', personid, 'created', 'Record created by seeder', 1 FROM "People";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'phaseid', phaseid, 'created', 'Record created by seeder', 1 FROM "Phase";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'pointid', pointid, 'created', 'Record created by seeder', 1 FROM "_Points";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'priorityid', priorityid, 'created', 'Record created by seeder', 1 FROM "Priority";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'projectid', projectid, 'created', 'Record created by seeder', 1 FROM "Project";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'resourceid', resourceid, 'created', 'Record created by seeder', 1 FROM "Resource";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'retrospectiveid', retrospectiveid, 'created', 'Record created by seeder', 1 FROM "Retrospective";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'riskid', riskid, 'created', 'Record created by seeder', 1 FROM "Risk";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'scheduleid', scheduleid, 'created', 'Record created by seeder', 1 FROM "Schedule";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'settingsid', settingsid, 'created', 'Record created by seeder', 1 FROM "_Settings";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'severityid', severityid, 'created', 'Record created by seeder', 1 FROM "Severity";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'severityid', severityid, 'created', 'Record created by seeder', 1 FROM "_Severity";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'sprintid', sprintid, 'created', 'Record created by seeder', 1 FROM "Sprint";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'statusid', statusid, 'created', 'Record created by seeder', 1 FROM "Status";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'statusid', statusid, 'created', 'Record created by seeder', 1 FROM "_Status";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'taskid', taskid, 'created', 'Record created by seeder', 1 FROM "Task";
INSERT INTO "Event" (keyname, keyvalue, action, details, personid) SELECT 'teamid', teamid, 'created', 'Record created by seeder', 1 FROM "Team";
