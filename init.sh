docker build -t big5:latest .
docker run -it -v $(pwd)/platform-data:/platform-clients:rw big5:latest typer main.py run init