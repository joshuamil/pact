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
  INNER JOIN "_Number" N ON
    N.num <= 5
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
  INNER JOIN "Phase" PH ON
    PR.projectid = PH.projectid
  INNER JOIN "_Settings" S ON 1=1
  INNER JOIN "_Number" N ON
    N.num <= 3
WHERE PR.name = 'PACT';


/* Insert Team Mebers */
INSERT INTO "Team"
(projectid, name, description)
SELECT PR.projectid, 'Development', 'Programming team for the ' || PR.name || ' project'
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
