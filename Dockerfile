ARG DHI_PYTHON_BUILD=dhi.io/python:3.11.11-debian12-dev@sha256:b9d90132fcace9841f22dd366d0732c03d62bb6bf4e4384a9a1b2d1c2aa73723
ARG DHI_PYTHON_RUNTIME=dhi.io/python:3.11.11-debian12@sha256:ec7c44322e121c4052801511d91c1b489becec77474293f255167d836ee9f488

FROM ${DHI_PYTHON_BUILD} AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv
ENV PATH="${VENV_PATH}/bin:${PATH}"

RUN python -m venv "${VENV_PATH}"

COPY submodules/parent-images/requirements/mini-requirements.txt .
COPY submodules/parent-images/requirements/common-requirements.txt .

RUN pip install --no-cache-dir -r common-requirements.txt

FROM ${DHI_PYTHON_RUNTIME}

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv
ENV PATH="${VENV_PATH}/bin:${PATH}"

COPY --from=builder --chown=65532:65532 ${VENV_PATH} ${VENV_PATH}

RUN python -c "import _cffi_backend, argon2.low_level, grpc, numpy.core._multiarray_umath, pandas._libs, psycopg2, pydantic_core._pydantic_core"

USER 65532:65532
