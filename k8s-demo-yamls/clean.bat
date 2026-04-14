@echo off
chcp 65001 >nul

echo ==========================================
echo   K8S Clean Script (demo namespace)
echo ==========================================

echo [1/10] Delete app ingress...
kubectl delete -f app-ingress.yaml --ignore-not-found
if %errorlevel% neq 0 goto fail

echo [2/10] Delete app service...
kubectl delete -f app-service.yaml --ignore-not-found
if %errorlevel% neq 0 goto fail

echo [3/10] Delete app deployment...
kubectl delete -f app-deployment.yaml --ignore-not-found
if %errorlevel% neq 0 goto fail

echo [4/10] Delete app configmap...
kubectl delete -f app-configmap.yaml --ignore-not-found
if %errorlevel% neq 0 goto fail

echo [5/10] Delete emqx...
kubectl delete -f emqx.yaml --ignore-not-found
if %errorlevel% neq 0 goto fail

echo [6/10] Delete influxdb...
kubectl delete -f influxdb.yaml --ignore-not-found
if %errorlevel% neq 0 goto fail

echo [7/10] Delete redis...
kubectl delete -f redis.yaml --ignore-not-found
if %errorlevel% neq 0 goto fail

echo [8/10] Delete mysql...
kubectl delete -f mysql.yaml --ignore-not-found
if %errorlevel% neq 0 goto fail

echo [9/10] Delete mysql init sql...
kubectl delete -f mysql-init.yaml --ignore-not-found
if %errorlevel% neq 0 goto fail

echo [10/10] Delete namespace...
kubectl delete -f namespace.yaml --ignore-not-found
if %errorlevel% neq 0 goto fail

echo ==========================================
echo Clean finished.
echo ==========================================

goto end

:fail
echo.
echo !!!!! Clean failed, please check error output above.
pause
exit /b 1

:end
echo.
pause