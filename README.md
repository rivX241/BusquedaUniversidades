# BusquedaUniversidades
docker build -t universidades_app .
docker run -d --name universidades_container -p 8090:80 universidades_app
