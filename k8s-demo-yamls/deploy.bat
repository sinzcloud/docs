@echo off
chcp 65001 >nul

echo ==========================================
echo   K8S Deploy Script (demo namespace)
echo ==========================================

echo [1/10] Apply namespace...
kubectl apply -f namespace.yaml
if %errorlevel% neq 0 goto fail

echo [2/10] Apply mysql init sql...
kubectl apply -f mysql-init.yaml
if %errorlevel% neq 0 goto fail

echo [3/10] Apply mysql...
kubectl apply -f mysql.yaml
if %errorlevel% neq 0 goto fail

echo [4/10] Apply redis...
kubectl apply -f redis.yaml
if %errorlevel% neq 0 goto fail

echo [5/10] Apply influxdb...
kubectl apply -f influxdb.yaml
if %errorlevel% neq 0 goto fail

echo [6/10] Apply emqx...
kubectl apply -f emqx.yaml
if %errorlevel% neq 0 goto fail

echo [7/10] Apply app configmap...
kubectl apply -f app-configmap.yaml
if %errorlevel% neq 0 goto fail

echo [8/10] Apply app deployment...
kubectl apply -f app-deployment.yaml
if %errorlevel% neq 0 goto fail

echo [9/10] Apply app service...
kubectl apply -f app-service.yaml
if %errorlevel% neq 0 goto fail

echo [10/10] Apply app ingress...
kubectl apply -f app-ingress.yaml
if %errorlevel% neq 0 goto fail

echo ==========================================
echo Deploy finished. Check status:
echo kubectl -n demo get pods
echo kubectl -n demo get svc
echo kubectl -n demo get ingress
echo ==========================================

goto end

:fail
echo.
echo !!!!! Deploy failed, please check error output above.
pause
exit /b 1

:end
echo.
pause