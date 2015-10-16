
.PHONY: schema

test:
	busted

init_schema::
	createdb -U postgres mtacommunity
	cat schema.sql | psql -U postgres mtacommunity

migrate::
	lapis migrate
	make schema.sql

schema.sql::
	pg_dump -s -U postgres mtacommunity > schema.sql
	pg_dump -a -t lapis_migrations -U postgres mtacommunity >> schema.sql

# save a copy of dev database into dev_backup
checkpoint:
	mkdir -p dev_backup
	pg_dump -F c -U postgres mtacommunity > dev_backup/$$(date +%F_%H-%M-%S).dump

# restore latest dev backup
restore_checkpoint::
	-dropdb -U postgres mtacommunity
	createdb -U postgres mtacommunity
	pg_restore -U postgres -d mtacommunity $$(find dev_backup | grep \.dump | sort -V | tail -n 1)


