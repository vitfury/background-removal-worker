.SILENT: ;  # Avoid commands output
.NOTPARALLEL: ; # Each command will be executted syncronously

CONTAINER_ID = $$(docker-compose ps -q api | cut -c1-12)

CYAN = \033[0;36m
RED = \033[0;31m
LGREEN = \033[0;32m
END = \033[0m

define check_container_exists
	if [ "$(CONTAINER_ID)" = "" ]; then \
		echo "${RED}App is not running${END}" ; \
		exit 0; \
	fi
endef



.PHONY: create
create:
	make down
	docker rmi stickerpack-generator -f
	docker-compose build
	make up



.PHONY: up
up:
	docker-compose up -d
	echo "Your app runs on ${CYAN}http://localhost:8008/${END}"
	echo "Container ID - ${LGREEN}${CONTAINER_ID}${END}"


.PHONY: down
down:
	echo 'Remove project containers ...'
	docker-compose kill
	echo 'Remove stopped containers ...'
	docker-compose rm -fv



.PHONY: restart
restart:
	make down && make up



.PHONY: exec
exec:
	$(call check_container_exists); \
	docker exec -ti $(CONTAINER_ID) sh ; \



.PHONY: stats
stats:
	$(call check_container_exists); \
	docker stats \
		--no-stream \
		--format \
		"table {{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}"; \



.PHONY: logs
logs:
	$(call check_container_exists); \
	docker logs $(CONTAINER_ID); \
