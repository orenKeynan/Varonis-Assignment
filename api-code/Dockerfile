FROM python:3.11-slim


# Install system deps + Microsoft ODBC driver, then clean up
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        unixodbc unixodbc-dev gnupg curl ca-certificates lsb-release \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor -o /usr/share/keyrings/microsoft-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-keyring.gpg] \
        https://packages.microsoft.com/debian/$(lsb_release -rs)/prod \
        $(lsb_release -cs) main" \
        > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql17 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN groupadd --system restgroup \
    && useradd --system --gid appgroup --shell /usr/sbin/nologin --home-dir /app restuser

# Set working dir and install Python deps
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code, fix permissions, and switch to non-root
COPY main.py .
RUN chown -R restuser:restgroup /app
USER restuser

# Run the app
ENTRYPOINT ["python3", "main.py"]
