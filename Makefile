install-zookeeper-image:
	docker build -t "alecinvan/zookeeper:0.1.0" .

start-install-zookeeper-container:
	./bin/zk-container.sh

