FROM python:3.12.2-bookworm AS python

RUN python3 -m venv /pythonenv
RUN /pythonenv/bin/python3 -m pip install mpt-cli

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
RUN apt-get update -y 
RUN apt-get install python3 -y
COPY --from=python /pythonenv /pythonenv
COPY --from=python /usr/local/bin/python3.12 /usr/local/bin/
COPY --from=python /usr/local/lib/python3.12 /usr/local/lib/python3.12
COPY --from=python /usr/local/lib/libpython* /usr/local/lib/
COPY --from=python /usr/local/include/python3.12 /usr/local/include/python3.12
RUN ln -s /usr/local/bin/python3.12 /usr/local/bin/python3
ENV PATH="/pythonenv/bin:$PATH" 

ENTRYPOINT ["mpt-cli"]
