\echo Use "CREATE EXTENSION send_to_redis" to load this file. \quit -- Just a reminder...
CREATE OR REPLACE FUNCTION send_to_redis(text, text) RETURNS boolean
AS '$libdir/send_to_redis'
LANGUAGE C IMMUTABLE STRICT;