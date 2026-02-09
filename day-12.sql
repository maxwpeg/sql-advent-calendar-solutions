-- SQL Advent Calendar - Day 12
-- Title: North Pole Network Most Active Users
-- Difficulty: hard
--
-- Question:
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--

-- Table Schema:
-- Table: npn_users
--   user_id: INT
--   user_name: VARCHAR
--
-- Table: npn_messages
--   message_id: INT
--   sender_id: INT
--   sent_at: TIMESTAMP
--

-- My Solution:

with daily_counts as (
  select date(sent_at) as dday, 
  sender_id,
  count(*) as msg_count
  FROM npn_messages
  group by date(sent_at), sender_id
), 
ranked as (
  select dday,
  sender_id,
  msg_count,
  
  rank() over (
    PARTITION BY dday
    ORDER BY msg_count DESC
  ) as rnk
  from daily_counts
)

SELECT r.dday,
  u.user_id,
  u.user_name,
  r.msg_count
from npn_users u join ranked r on u.user_id=r.sender_id
where r.rnk = 1
order by r.dday, u.user_name
