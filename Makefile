
img   ?=itaru2622/mcp:bookworm
wDir  ?=${PWD}
cName ?=mcp
cmd   ?=tail -f /dev/null

build:
	docker build -t ${img} .

start:
	docker run --name ${cName} -d \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${wDir}:${wDir} -w ${wDir} \
	${img} ${cmd}

stop:
	docker rm -f ${cName} 

bash:
	docker exec -it ${cName} /bin/bash
