wDir  ?=${PWD}

#fastmcp_ver ?=fastmcp
#fastmcp_ver ?=git+https://github.com/jlowin/fastmcp.git@main
fastmcp_ver  ?=git+https://github.com/itaru2622/jlowin-fastmcp.git@main

distr ?=trixie
img   ?=itaru2622/mcp:${distr}
base  ?=python:3.13-${distr}
cName ?=mcp

# tune options by modes (dind or ordinal)
dind  ?=true
ifneq ($(dind),true)
# case1) ordinal mode (dind != true)
cmd     ?=/bin/bash
dOpts   ?=-t --rm -v ${wDir}:${wDir} -w ${wDir}
dnsOpts ?=
# case1 end
else
# case2) docker in docker mode (dind == true)
cmd     ?=/lib/systemd/systemd
dOpts   ?=-d --privileged
dnsOpts ?=$(shell cat /etc/resolv.conf | grep -v ^# | grep nameserver | awk '{print "--dns", $$2}' | paste -sd " " - )
# case2 end
endif
# end options by modes


build:
	docker build --build-arg base=${base} --build-arg fastmcp_ver=${fastmcp_ver} -t ${img} .

# start container with dockerd
start:
	docker run --name ${cName} -i ${dOpts} ${dnsOpts} ${img} ${cmd}

stop:
	docker rm -f ${cName} 

bash:
	docker exec -it ${cName} /bin/bash
