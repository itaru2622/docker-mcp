ARG base=python:3.13-trixie
FROM ${base}
ARG base=python:3.13-trixie

RUN  apt update; apt install -y curl gnupg2 vim bash-completion git make jq yq
RUN  curl -L https://download.docker.com/linux/debian/gpg > /etc/apt/trusted.gpg.d/docker.asc; \
     echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list
RUN  apt update; apt install -y docker-ce docker-ce-cli docker-compose-plugin \
                                kmod iproute2     net-tools

ARG fastmcp_ver=fastmcp
ENV _fastmcp_ver=${fastmcp_ver}
ENV _fastmcp_origin=git+https://github.com/jlowin/fastmcp.git@main
RUN pip install uv pydantic PyYAML  \
                 mcp fastapi      ${fastmcp_ver} \
                 pandas openpyxl \
                 openai langchain langgraph langchain-openai langchain-mcp-adapters

RUN echo "set mouse-=a" > /root/.vimrc;

# docker-mcp plugin trial @ https://github.com/docker/mcp-gateway/releases (pre-releases)
RUN curl -L https://api.github.com/repos/docker/mcp-gateway/releases | jq -r 'map(select(.prerelease)) | first | .assets[].browser_download_url' | grep linux-amd64.tar.gz | xargs -I {} curl -L {} -o /tmp/docker-mcp.tgz ; \
tar zxvf /tmp/docker-mcp.tgz -C /usr/libexec/docker/cli-plugins ; \
rm -f /tmp/docker-mcp.tgz

# add nodejs + mcp-typescript-sdk(@modelcontextprotocol/sdk)
ARG node_ver=22
RUN curl -fsSL https://deb.nodesource.com/setup_${node_ver}.x | bash - ; apt update;
RUN apt install -y nodejs; \
    npm install -g @modelcontextprotocol/sdk

# add 'just' (https://github.com/casey/just), needs to re-generate fastmcp api-docs(docs/python-sdk/*) on contributing.
RUN curl --tlsv1.2 -fL https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# mcp terminal client for dev/debug
RUN curl -fL https://raw.githubusercontent.com/zueai/terminal-mcp/main/install.sh | bash
