-- Adatbázis létrehozása
CREATE DATABASE basketball_db;

-- Táblák beszúrása
CREATE TABLE matches ( 
	match_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	home_team VARCHAR(100), 
	away_team VARCHAR(100), 
	match_date DATE, 
	venue VARCHAR(100)
);

CREATE TABLE ticket_sales ( 
	ticket_sale_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	match_id INT REFERENCES matches(match_id), 
	sale_date DATE, 
	ticket_price FLOAT, 
	seat_type VARCHAR(100) 
); 

CREATE TABLE concession_sales ( 
	concession_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	match_id INT REFERENCES matches(match_id), 
	item_name VARCHAR(100), 
	quantity INT, 
	price FLOAT
);

--Dummy adatok betöltése
INSERT INTO matches (home_team, away_team, match_date, venue) VALUES
('Lakers',   'Bulls', '2025-05-01', 'Staples Center'),
('Celtics',  'Heat',  '2025-05-02', 'TD Garden'),
('Warriors', 'Nets',  '2025-05-03', 'Chase Center');

INSERT INTO ticket_sales (match_id, sale_date, ticket_price, seat_type) VALUES
(1, '2025-04-20', 150.00, 'VIP'),
(1, '2025-04-21', 100.00, 'Regular'),
(1, '2025-04-21', 100.00, 'Regular'),
(2, '2025-04-22', 120.00, 'Regular'),
(2, '2025-04-22', 120.00, 'Regular'),
(3, '2025-04-23', 130.00, 'VIP');

INSERT INTO concession_sales (match_id, item_name, quantity, price) VALUES
(1, 'Hotdog', 50, 5.00),
(1, 'Soda',   30, 3.00),
(2, 'Popcorn',40, 4.50),
(3, 'Nachos', 20, 6.00);

-- I. feladat: Meccsek listázása, ahol több mint  jegyet adtak el
SELECT m.match_id, m.home_team, m.away_team, COUNT(*) AS ticket_count
FROM matches AS m JOIN ticket_sales AS t ON m.match_id = t.match_id
GROUP BY m.match_id, m.home_team, m.away_team HAVING COUNT(*)>2;   

-- II. feladat: Lapozó lekérdezés a meccsek listájára
SELECT match_id, home_team, away_team, match_date
FROM matches
ORDER BY match_date DESC
LIMIT 3 OFFSET 1;

-- III. feladat: Bevétel számolása az eladott jegyekből és büfé bevételből
SELECT m.match_id, m.home_team, m.away_team, SUM(t.ticket_price) AS ticket_income, SUM(c.quantity * c.price) AS concession_income, SUM(t.ticket_price) + SUM(c.quantity * c.price) AS total_income 
FROM matches as m
LEFT JOIN ticket_sales AS t ON m.match_id = t.match_id
LEFT JOIN concession_sales AS c ON m.match_id = c.match_id
GROUP BY m.match_id, m.home_team, m.away_team 
ORDER BY total_income DESC;

-- IV. feladat: Adatok törlése
DELETE FROM ticket_sales
WHERE seat_type = 'VIP';

-- V. feladat: Adatok kiürítése
TRUNCATE TABLE concession_sales;

-- VI. Meccsek és jegyeladás összekapcsolása
SELECT m.match_id, m.home_team, m.away_team, m.match_date, t.sale_date, t.ticket_price, t.seat_type
FROM matches AS m
JOIN ticket_sales AS t ON m.match_id = t.match_id
ORDER BY t.ticket_price ASC
LIMIT 3 OFFSET 0;