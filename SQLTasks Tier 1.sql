/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
/* A1: 
run_query("""
SELECT name
FROM Facilities
WHERE membercost > 0
""") */


/* Q2: How many facilities do not charge a fee to members? */
/* A2: there are 4 free facilities */


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
/* A3: 
run_query("""
SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost > 0
  AND membercost < monthlymaintenance * 0.2
""") */


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
/* A4:
run_query("""
SELECT *
FROM Facilities
WHERE facid IN (1, 5)
""")*/


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
/* A5: 
run_query("""
SELECT name,
       monthlymaintenance,
       CASE WHEN monthlymaintenance > 100 THEN 'expensive'
            ELSE 'cheap' END AS cost_label
FROM Facilities
""")*/


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
/* A6: 
run_query("""
SELECT firstname, surname, joindate
FROM Members
WHERE joindate = (SELECT MAX(joindate) FROM Members)
""")*/

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
/* A7: 
run_query("""
SELECT DISTINCT f.name AS facility,
       m.firstname || ' ' || m.surname AS member_name
FROM Bookings AS b
INNER JOIN Facilities AS f ON b.facid = f.facid
INNER JOIN Members AS m ON b.memid = m.memid
WHERE f.name LIKE 'Tennis Court%'
  AND m.memid != 0
ORDER BY member_name
""")*/


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
/* A8:
run_query("""
SELECT f.name AS facility,
       m.firstname || ' ' || m.surname AS member_name,
       CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
            ELSE f.membercost * b.slots END AS cost
FROM Bookings AS b
INNER JOIN Facilities AS f ON b.facid = f.facid
INNER JOIN Members AS m ON b.memid = m.memid
WHERE DATE(b.starttime) = '2012-09-14'
  AND CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
           ELSE f.membercost * b.slots END > 30
ORDER BY cost DESC
""")*/


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
/* A9: 
run_query("""
SELECT facility, member_name, cost
FROM (
    SELECT f.name AS facility,
           m.firstname || ' ' || m.surname AS member_name,
           CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
                ELSE f.membercost * b.slots END AS cost
    FROM Bookings AS b
    INNER JOIN Facilities AS f ON b.facid = f.facid
    INNER JOIN Members AS m ON b.memid = m.memid
    WHERE DATE(b.starttime) = '2012-09-14'
) AS booking_costs
WHERE cost > 30
ORDER BY cost DESC
""")*/


/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
/* A10:
	facility	total_revenue
0	Table Tennis	180
1	Snooker Table	240
2	Pool Table	270
*/


/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */
/* A11:
	member_surname	member_firstname	recommender_surname	recommender_firstname
0	Bader	Florence	Stibbons	Ponder
1	Baker	Anne	Stibbons	Ponder
2	Baker	Timothy	Farrell	Jemima
3	Boothe	Tim	Rownam	Tim
4	Butters	Gerald	Smith	Darren
5	Coplin	Joan	Baker	Timothy
6	Crumpet	Erica	Smith	Tracy
7	Dare	Nancy	Joplette	Janice
8	Genting	Matthew	Butters	Gerald
9	Hunt	John	Purview	Millicent
10	Jones	David	Joplette	Janice
11	Jones	Douglas	Jones	David
12	Joplette	Janice	Smith	Darren
13	Mackenzie	Anna	Smith	Darren
14	Owen	Charles	Smith	Darren
15	Pinker	David	Farrell	Jemima
16	Purview	Millicent	Smith	Tracy
17	Rumney	Henrietta	Genting	Matthew
18	Sarwin	Ramnaresh	Bader	Florence
19	Smith	Jack	Smith	Darren
20	Stibbons	Ponder	Tracy	Burton
21	Worthington-Smyth	Henry	Smith	Tracy
*/


/* Q12: Find the facilities with their usage by member, but not guests */
/* A12:
facility	member_name	total_slots
0	Badminton Court	Anna Mackenzie	96
1	Badminton Court	Anne Baker	30
2	Badminton Court	Burton Tracy	6
3	Badminton Court	Charles Owen	18
4	Badminton Court	Darren Smith	432
...	...	...	...
197	Tennis Court 2	Ramnaresh Sarwin	36
198	Tennis Court 2	Tim Boothe	168
199	Tennis Court 2	Tim Rownam	18
200	Tennis Court 2	Timothy Baker	21
201	Tennis Court 2	Tracy Smith	6
202 rows × 3 columns
*/

/* Q13: Find the facilities usage by month, but not guests */
/* A13
facility	month	total_slots
0	Badminton Court	07	165
1	Badminton Court	08	414
2	Badminton Court	09	507
3	Massage Room 1	07	166
4	Massage Room 1	08	316
5	Massage Room 1	09	402
6	Massage Room 2	07	8
7	Massage Room 2	08	18
8	Massage Room 2	09	28
9	Pool Table	07	110
10	Pool Table	08	303
11	Pool Table	09	443
12	Snooker Table	07	140
13	Snooker Table	08	316
14	Snooker Table	09	404
15	Squash Court	07	50
16	Squash Court	08	184
17	Squash Court	09	184
18	Table Tennis	07	98
19	Table Tennis	08	296
20	Table Tennis	09	400
21	Tennis Court 1	07	201
22	Tennis Court 1	08	339
23	Tennis Court 1	09	417
24	Tennis Court 2	07	123
25	Tennis Court 2	08	345
26	Tennis Court 2	09	414
*/

