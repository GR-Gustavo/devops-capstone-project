FROM python:3.9-slim

# Establish a working folder
WORKDIR /app

# Establish dependencies
COPY requirements.txt .
RUN python -m pip install --upgrade pip wheel && \
    pip install --no-cache-dir -r requirements.txt

# Copy all application files into the image
COPY service/ ./service/
COPY setup.cfg .flaskenv Procfile ./

# Switch to a non-root user
RUN useradd --uid 1000 flask && chown -R flask /app
USER flask

# Run the service on port 8080
EXPOSE 8080
ENV PORT 8080
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]