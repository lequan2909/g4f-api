# Use an official Python runtime as a parent image
FROM python:3.11-slim-buster

# Set the working directory in the container to /app
WORKDIR /app

# Install git and other dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install the latest version of Poetry
RUN pip install --upgrade pip && \
    pip install poetry

# Copy the current directory contents into the container at /app
COPY pyproject.toml poetry.lock* /app/
COPY src /app/src

# Install dependencies using poetry
# The --no-root option is used to avoid installing the package (defined in pyproject.toml) itself
# The --no-interaction option is used to avoid interactive prompts
RUN poetry install --no-root --no-interaction

# Expose port 7001 for the application
EXPOSE 7001

# Run main.py when the container launches
CMD ["poetry", "run", "python3", "main.py"]
