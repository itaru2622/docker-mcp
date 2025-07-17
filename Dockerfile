ARG base=python:3.12-bookworm
FROM ${base}
ARG base=python:3.12-bookworm

RUN  apt update; apt install -y curl gnupg2 vim bash-completion git make jq yq
RUN  curl -L https://download.docker.com/linux/debian/gpg | apt-key add -; \
     echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list
RUN  apt update; apt install -y docker-ce docker-ce-cli docker-compose-plugin

RUN  pip install uv pydantic PyYAML  \
                 mcp fastapi fastmcp \
                 openai langchain langgraph langchain-openai langchain-mcp-adapters
RUN pip install git+https://github.com/jlowin/fastmcp.git
RUN  echo "set mouse-=a" > /root/.vimrc;
