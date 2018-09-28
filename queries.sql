-- 1. топ 10 игроков забивших большее кол-во голов
with top_count_goals as (
	select player_id, count(*) as count_goals
	from "action"
	where "type" = 'goal'
	group by "action".player_id
	order by count_goals DESC
	limit 10
)
select top_count_goals.count_goals, team."name" ,player.surname, player.name
from player
join top_count_goals on player_id = player.id
join team on team.id = player.team_id
order by top_count_goals.count_goals desc


-- 2. топ 10 игроков рано открывших счёт
select "action"."time", team."name" ,player.surname, player.name
from "action"
join player on player_id = "player".id
join team on team.id = player.team_id
where "action"."type" = 'goal'
order by cast("action"."time" as int)
limit 10


-- 3. возраст игроков в порядке возрастания
select age(birthday) as age, surname, name
from player
order by age


-- 4. топ стадионов по кол-ву проведённых игр
select stadium."name", count(*) as count_games
from stadium
join game on stadium.id = game.stadium_id
group by stadium."name"
order by count_games desc, "name"


-- 5. самый и молодой и самый старый игроки
with limits_birthdays as (
	select min(birthday) as min_birthday, max(birthday) as max_birthday
	from player
)
select age(birthday) as age, surname, "name"
from player
where birthday in (select min_birthday from limits_birthdays)
or birthday in (select max_birthday from limits_birthdays)
order by age


-- 6. дни с максимальным совпадением дней рождений игроков
select birthday, string_agg(concat_ws(' ',"surname" , "name"),', ')
from player
group by birthday
having count(*) in (
  select count(*) as counts_birthday
  from player
  group by birthday
  order by counts_birthday desc
  limit 1
)