FROM python:3.9-slim

COPY submodules/parent-images/requirements/mini-requirements.txt .
COPY submodules/parent-images/requirements/common-requirements.txt .

RUN pip install --no-cache-dir -r common-requirements.txt