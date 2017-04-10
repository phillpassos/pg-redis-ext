#include "hiredis/hiredis.h"
#include "stdio.h"

int main()
{
	redisReply *r;
	redisContext *c = redisConnect("127.0.0.1", 6379);

	if (c == NULL || c->err) {
		redisFree(c);
		printf("\nError\n");
		return 0;
	}

	r = redisCommand(c, "SELECT 1");

	if (!c->err)
		r = redisCommand(c, "SET %s %s", "first", "value");

	redisFree(c);
	printf("\nworked\n");
    return 1;
}