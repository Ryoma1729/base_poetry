# Build stage
FROM python:3.9.16 as builder

ENV PYTHONPATH "${PYTHONPATH}:/workspace"
WORKDIR /workspace

# Install poetry
ENV POETRY_HOME=/opt/poetry
RUN curl -sSL https://install.python-poetry.org/ | python - && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false

# Install dependencies first to make use of Docker cache
COPY pyproject.toml .
RUN poetry install

# Final stage
FROM python:3.9.16

# Create a non-root user
RUN adduser --disabled-password --gecos '' appuser
USER appuser

COPY --from=builder /workspace /workspace
WORKDIR /workspace
