ARG base=python:3.12-bookworm
FROM ${base}
ARG base=python:3.12-bookworm

RUN  apt update; apt install -y curl gnupg2 vim bash-completion git make jq yq graphviz
RUN  curl -L https://download.docker.com/linux/debian/gpg | apt-key add -; \
     echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list
RUN  apt update; apt install -y docker-ce docker-ce-cli docker-compose-plugin

ARG fastmcp_ver=fastmcp
RUN  pip install uv pydantic PyYAML  \
                 mcp fastapi      gprof2dot ${fastmcp_ver} \
                 openai langchain langgraph langchain-openai langchain-mcp-adapters
RUN  echo "set mouse-=a" > /root/.vimrc;
