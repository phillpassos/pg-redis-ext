#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"
#include "hiredis/hiredis.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(send_to_redis);
Datum
send_to_redis(PG_FUNCTION_ARGS)
{
	text *key = PG_GETARG_TEXT_P(0);
	text *value = PG_GETARG_TEXT_P(1);
	redisReply *r;
	redisContext *c = redisConnect("127.0.0.1", 6379);

	if (c == NULL || c->err) {
		redisFree(c);
		PG_RETURN_BOOL(false);
	}
	
	r = redisCommand(c, "SELECT 1");

	if (c->err) {
		redisFree(c);
		PG_RETURN_BOOL(false);
	}
	
	freeReplyObject(r);
	r = redisCommand(c, "SET %s %s", text_to_cstring(key), text_to_cstring(value));

	if (c->err) {
		redisFree(c);
		freeReplyObject(r);
		PG_RETURN_BOOL(false);
	}
	
	freeReplyObject(r);
	redisFree(c);
    PG_RETURN_BOOL(true);
}


/* converting from pg_text to ctring*/
char *text_to_cstring(const text *t)
{
	char	   *result;
	text	   *tunpacked = pg_detoast_datum_packed((struct varlena *) t);
	int			len = VARSIZE_ANY_EXHDR(tunpacked);

	result = (char *) palloc(len + 1);
	memcpy(result, VARDATA_ANY(tunpacked), len);
	result[len] = '\0';

	if (tunpacked != t)
		pfree(tunpacked);
	
	return result;
}
