# On Linux/Mac
docker run -it -v $(pwd)/platform-data:/app/platform-clients big5:latest

# On Windows (PowerShell)
#docker run -it -v ${PWD}/platform-data:/app/platform-clients platform-clients:latest

# On Windows (CMD)
#docker run -it -v %cd%\platform-data:/app/platform-clients platform-clients:latest