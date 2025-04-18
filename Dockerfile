# Start with a Linux micro-container to keep the image tiny
FROM alpine

# Install just the Python runtime (no dev)
RUN apk add --no-cache \
    python3 \
    py-pip \
    ca-certificates
RUN pip install --upgrade setuptools && pip install --upgrade pip

# Expose any ports the app is expecting in the environment
ENV PORT 5000
EXPOSE $PORT

# Set up a working folder and install the pre-reqs
WORKDIR /app
ADD requirements.txt /app
RUN pip install -r requirements.txt
# If there are build dependencies use this instead
# RUN apk --no-cache add --virtual build-dependencies python-dev build-base wget \
#   && pip install -r requirements.txt \
#   && python setup.py install \
#   && apk del build-dependencies

# Add the code as the last Docker layer because it changes the most
ADD static /app/static
ADD service.py /app

# Run the service
CMD [ "python", "service.py" ]
