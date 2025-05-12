# Base image: UV Python packaging tool
FROM ghcr.io/astral-sh/uv:debian-slim
RUN apt-get update && apt-get install -y git
# The installer requires curl (and certificates) to download the release archive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates

# Download the latest installer
ADD https://astral.sh/uv/install.sh /uv-installer.sh

# Run the installer then remove it
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin/:$PATH"


# Set working directory
WORKDIR /app

RUN git clone https://github.com/ERC-BIG-5/platform-clients


WORKDIR /app/platform-clients

COPY env /app/platform-clients/.env
RUN ls -la /app/platform-clients/.env || echo "FILE NOT FOUND"

RUN uv sync --all-extras

RUN . .venv/bin/activate
ENV PATH="/app/platform-clients/.venv/bin:$PATH"
RUN typer main.py run init
#RUN /app/platform-clients/.venv/bin/python -m typer main.py run init
# VOLUME ["/platform-clients"]

# Make sure the data directory exists
#RUN mkdir -p /app/platform-clients/data

# Create a backup of just the data directory
RUN cp -r /app/platform-clients/data /app/data-backup

# Copy the entrypoint script from host
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set volume at the parent level
VOLUME ["/platform-clients"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]