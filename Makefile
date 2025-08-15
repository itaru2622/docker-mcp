distr ?=trixie
img   ?=itaru2622/mcp:${distr}
base  ?=python:3.13-${distr}
wDir  ?=${PWD}
cName ?=mcp
cmd   ?=tail -f /dev/null

#fastmcp_ver ?=fastmcp
#fastmcp_ver ?=git+https://github.com/jlowin/fastmcp.git@main
fastmcp_ver  ?=git+https://github.com/itaru2622/jlowin-fastmcp.git@main


build:
	docker build --build-arg base=${base} --build-arg fastmcp_ver=${fastmcp_ver} -t ${img} .

start:
	docker run --name ${cName} -d \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${wDir}:${wDir} -w ${wDir} \
	${img} ${cmd}

stop:
	docker rm -f ${cName} 

bash:
	docker exec -it ${cName} /bin/bash
