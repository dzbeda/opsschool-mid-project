GRANT USAGE ON SCHEMA scheduler TO kandula;
GRANT USAGE, SELECT ON SEQUENCE scheduler.instance_shutdown_schedule_id_seq TO kandula;
GRANT  INSERT, SELECT, UPDATE, DELETE ON scheduler.instance_shutdown TO kandula;
alter role kandula in database postgres set search_path='scheduler';
