VERSION_TAG = 1.0
export USER_NAME = arybach
WORKDIR = $(CURDIR)/..
DOCKER_DIR = $(WORKDIR)/docker
-include $(DOCKER_DIR)/.env
export

SERVICES = ui post comment
MONITORING_SERVICES = prometheus cloudprober mongodb-exporter node-exporter

start:
	cd $(DOCKER_DIR) && docker-compose up -d

stop:
	cd $(DOCKER_DIR) && docker-compose down

restart: stop start

logs:
	cd $(DOCKER_DIR) && docker-compose logs -f

build: build-services build-monitoring

build-services:
	for service in $(SERVICES); do \
		if [ -d "$(WORKDIR)/src/$$service" ]; then \
			cd $(WORKDIR)/src/$$service; \
			if [ -f "docker_build.sh" ]; then \
				bash docker_build.sh $(VERSION_TAG); \
			else \
				echo "docker_build.sh not found for $$service"; \
			fi; \
			cd -; \
		else \
			echo "Directory not found for $$service"; \
		fi; \
	done

build-monitoring:
	for service in $(MONITORING_SERVICES); do \
		if [ -d "$(WORKDIR)/monitoring/$$service" ]; then \
			cd $(WORKDIR)/monitoring/$$service; \
			docker build -t $(DOCKER_REPO)/$$service:$(VERSION_TAG) . ; \
			cd -; \
		else \
			echo "Directory not found for $$service"; \
		fi; \
	done

push: push-services push-monitoring

push-services:
	for service in $(SERVICES); do \
		if [ -d "$(WORKDIR)/src/$$service" ]; then \
			cd $(WORKDIR)/src/$$service; \
			docker push $(DOCKER_REPO)/$$service:$(VERSION_TAG); \
			cd -; \
		else \
			echo "Directory not found for $$service"; \
		fi; \
	done

push-monitoring:
	for service in $(MONITORING_SERVICES); do \
		if [ -d "$(WORKDIR)/monitoring/$$service" ]; then \
			cd $(WORKDIR)/monitoring/$$service; \
			docker push $(DOCKER_REPO)/$$service:$(VERSION_TAG); \
			cd -; \
		else \
			echo "Directory not found for $$service"; \
		fi; \
	done

login:
	docker login

.PHONY: start stop restart logs build build-services build-monitoring push push-services push-monitoring login
