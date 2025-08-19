ARG VARIANT=3.12-bookworm
FROM python:${VARIANT}
ENV DEBIAN_FRONTEND=noninteractive

# We need to set this environment variable so that uv knows where
# the virtual environment is to install packages
ARG ACTIVE_PROJECT
ENV VIRTUAL_ENV="/workspaces/${ACTIVE_PROJECT:-.}/.venv"
ENV PATH="/workspaces/${ACTIVE_PROJECT:-.}/.venv/bin:$PATH"

# ENV VIRTUAL_ENV="/workspace/.venv"

# Set the working directory to match the workspaceFolder in devcontainer.json
WORKDIR /workspaces

# Make sure that the virtual environment is in the PATH so
# we can use the binaries of packages that we install such as pip
# without needing to activate the virtual environment explicitly
#ENV PATH="/opt/venv/bin:$PATH"
ENV PATH="/workspaces/.venv/bin:$PATH"

# Remove imagemagick due to security vulnerability, then install system binaries
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131 \
    && apt-get purge -y imagemagick imagemagick-6-common \
    && apt-get install -y --no-install-recommends bat fd-find pipx \
    && rm -rf /var/lib/apt/lists/* 

    