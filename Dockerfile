ARG base=python:3.13-trixie
FROM ${base}
ARG base=python:3.13-trixie

RUN  apt update; apt install -y curl gnupg2 vim bash-completion git make jq yq
RUN  curl -L https://download.docker.com/linux/debian/gpg > /etc/apt/trusted.gpg.d/docker.asc; \
     echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list
RUN  apt update; apt install -y docker-ce docker-ce-cli docker-compose-plugin

ARG fastmcp_ver=fastmcp
ENV _fastmcp_ver=${fastmcp_ver}
ENV _fastmcp_origin=git+https://github.com/jlowin/fastmcp.git@main
RUN pip install uv pydantic PyYAML  \
                 mcp fastapi      ${fastmcp_ver} \
                 pandas openpyxl \
                 openai langchain langgraph langchain-openai langchain-mcp-adapters

RUN echo "set mouse-=a" > /root/.vimrc;

# add 'just' (https://github.com/casey/just), needs to re-generate fastmcp api-docs(docs/python-sdk/*) on contributing.
RUN curl --tlsv1.2 -fL https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# mcp terminal client for dev/debug
RUN curl -fL https://raw.githubusercontent.com/zueai/terminal-mcp/main/install.sh | bash

ARG _scriptDir=/opt/ops
ENV _scriptDir=${_scriptDir}
COPY . ${_scriptDir}
WORKDIR ${_scriptDir}

CMD make startDockerd daemonize -C ${_scriptDir}
