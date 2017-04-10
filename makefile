# if you dont have any shared libs to link, you can use the 
# postgresql's bare-bones-default-script to build your module as commented below

# PG default script begin

#EXTENSION = send_to_redis        # extension name
#DATA = send_to_redis--0.0.1.sql  # creation script

#MODULE = send_to_redis          # module name
# postgres build stuff
#PG_CONFIG = pg_config
#PGXS := $(shell $(PG_CONFIG) --pgxs)
#include $(PGXS)

# PG default script end

# From here we are using our own Makefile

EXT_VERSION = 0.0.1
EXT_NAME = send_to_redis
# This is where extensions files should be installed
EXT_DATA_FOLDER = $(shell pg_config --sharedir)/extension

# This is our extra lib
EXTRA_LINKER_LIBS = hiredis/libhiredis.a

INCLUDEDIRS := -I.
INCLUDEDIRS += -I$(shell pg_config --includedir-server)
INCLUDEDIRS += -I$(shell pg_config --includedir)
# If you are using shared libraries, make sure this location can be
# found at runtime (see /etc/ld.so.conf and ldconfig command).
LIBDIR = -L$(shell pg_config --libdir)
# This is where the shared object should be installed
LIBINSTALL = $(shell pg_config --pkglibdir)

send_to_redis.so: $(EXT_NAME).c Makefile
			gcc -fpic -o $(EXT_NAME).o -c $(EXT_NAME).c $(INCLUDEDIRS)
			gcc -shared -fpic -o $(EXT_NAME).so $(EXT_NAME).o $(EXTRA_LINKER_LIBS) $(LIBDIR) -lpq -lm
			cp $(EXT_NAME).so $(LIBINSTALL)
			cp $(EXT_NAME).control $(EXT_DATA_FOLDER)
			cp $(EXT_NAME)--$(EXT_VERSION).sql $(EXT_DATA_FOLDER)