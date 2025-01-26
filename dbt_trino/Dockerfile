FROM python:3.11-slim

COPY dbt_trino_pkg/. /dbt_trino_pkg
COPY requirements.txt /tmp
COPY --chmod=0755 dbt_exec.sh /tmp

WORKDIR /dbt_trino_pkg

RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

CMD ["/tmp/dbt_exec.sh"]