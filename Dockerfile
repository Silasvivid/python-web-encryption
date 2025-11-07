FROM python:3.12-slim

WORKDIR /app

# 安装 ca-certificates + curl（官方源）
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# 先复制 requirements（利用 Docker 缓存，改 app.py 不重装依赖）
COPY requirements.txt .

# 直接系统级安装（不用 --user，也不用改 PATH）
RUN pip install --no-cache-dir -r requirements.txt

# 再复制应用文件
COPY app.py .
COPY galaxy01.data.enc galaxy01.data.enc

EXPOSE 8000

CMD ["python", "app.py", "--encrypted", "galaxy01.data.enc", "--run-http"]
