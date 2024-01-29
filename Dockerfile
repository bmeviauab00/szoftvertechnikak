FROM squidfunk/mkdocs-material:9.5.6

# required for mkdocs-git-committers-plugin-2
RUN apk add --no-cache --virtual .build-deps gcc libc-dev libxslt-dev && \
    apk add --no-cache libxslt && \
    pip install --no-cache-dir lxml>=3.5.0 && \
    apk del .build-deps

# to support multiple versions mike is installed
RUN pip install mike

RUN pip install --no-cache-dir \
  mkdocs-git-revision-date-localized-plugin \
  git+https://github.com/tibitoth/mkdocs-git-committers-plugin-2.git@master \
  mkdocs-glightbox

RUN git config --global --add safe.directory /github/workspace

EXPOSE 8000

# override inherited entrypoint (which is mkdocs), we want to have full control over
# what is executed using docker run's command parameters
ENTRYPOINT [] 

# Run the "mkdocs serve" command at the specified port.
# (to build the docs without serve: just override the cmd with "mkdocs build" when
# executing docker run. This can be used when runnig this docker image as github action
# in the CI pipeline)
CMD mkdocs serve --dev-addr=0.0.0.0:8000