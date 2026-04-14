@echo off
chcp 65001 >nul

echo ==========================================
echo   K8S Port Forward Script (Ingress Mode)
echo ==========================================

echo [1] Ingress Controller -> localhost:80
start cmd /k "kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 80:80"

echo [2] MySQL -> localhost:3306
start cmd /k "kubectl -n demo port-forward svc/mysql 3306:3306"

echo [3] Redis -> localhost:6379
start cmd /k "kubectl -n demo port-forward svc/redis 6379:6379"

echo [4] InfluxDB -> localhost:8086
start cmd /k "kubectl -n demo port-forward svc/influxdb 8086:8086"

echo [5] EMQX MQTT -> localhost:1883
start cmd /k "kubectl -n demo port-forward svc/emqx 1883:1883"

echo [6] EMQX Dashboard -> localhost:18083
start cmd /k "kubectl -n demo port-forward svc/emqx 18083:18083"

echo ==========================================
echo Now open: http://demo.local
echo ==========================================
pause