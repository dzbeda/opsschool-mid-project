CREATE TABLE IF NOT EXISTS scheduler.instance_shutdown (
	schedule_id SERIAL NOT NULL PRIMARY key,
	instance_id VARCHAR(32) NOT NULL,
	shutdown_hour NUMERIC NOT NULL CHECK(shutdown_hour >= 0 AND shutdown_hour < 24),
	unique (instance_id, shutdown_hour));
