wDir  ?=${PWD}
_scriptDir  ?=/opt/ops

distr ?=trixie
img   ?=itaru2622/mcp:${distr}
base  ?=python:3.13-${distr}
cName ?=mcp
cmd   ?=make startDockerd daemonize -C ${_scriptDir}
dOpts ?=
#dOpts ?=-v ${wDir}:${wDir} -w ${wDir}


#fastmcp_ver ?=fastmcp
#fastmcp_ver ?=git+https://github.com/jlowin/fastmcp.git@main
fastmcp_ver  ?=git+https://github.com/itaru2622/jlowin-fastmcp.git@main


build:
	docker build --build-arg _scriptDir=${_scriptDir} --build-arg base=${base} --build-arg fastmcp_ver=${fastmcp_ver} -t ${img} .

# start container with dockerd
start:
	docker run --name ${cName} -d --privileged ${dOpts} ${img} ${cmd}

# docker in docker (dockerd in container)
startDockerd:
	/usr/bin/dockerd &
daemonize:
	tail -f /dev/null

stop:
	docker rm -f ${cName} 

bash:
	docker exec -it ${cName} /bin/bash
