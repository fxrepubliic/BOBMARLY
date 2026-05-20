FROM debian:bookworm-slim

LABEL maintainer="@Kakoolnews"

# Copy scripts and templates
COPY install.sh /app/install.sh
COPY config.json /etc/config.template.json
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates uuid-runtime \
    && rm -rf /var/lib/apt/lists/*

# Install Xray
RUN chmod +x /app/install.sh && /app/install.sh

# Make entrypoint executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# IMPORTANT: Removed HEALTHCHECK to prevent Codespaces Recovery Mode

CMD ["/usr/local/bin/entrypoint.sh"]
