BEGIN;

INSERT INTO room_types (name, capacity, rate_paise) VALUES
  ('Standard', 50, 150000),
  ('Deluxe',   50, 250000),
  ('Family',   50, 350000),
  ('Suite',    50, 600000)
ON CONFLICT (name) DO NOTHING;

INSERT INTO rooms (room_number, room_type_id)
SELECT (f.floor * 100 + n)::text, t.id
FROM (VALUES ('Standard',1),('Deluxe',2),('Family',3),('Suite',4)) AS f(type_name, floor)
JOIN room_types t ON t.name = f.type_name
CROSS JOIN generate_series(1, 50) AS n
ON CONFLICT (room_number) DO NOTHING;

COMMIT;

SELECT t.name, t.capacity, count(r.id) AS rooms
FROM room_types t LEFT JOIN rooms r ON r.room_type_id = t.id
GROUP BY t.id ORDER BY t.id;