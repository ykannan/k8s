#build docker images
docker build -t ykannan108/multi-client:latest -t ykannan108/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t ykannan108/multi-server:latest -t ykannan108/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t ykannan108/multi-worker:latest -t ykannan108/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#push docker latestimages
docker push ykannan108/multi-client:latest
docker push ykannan108/multi-server:latest
docker push ykannan108/multi-worker:latest

#push images with tags
docker push ykannan108/multi-client:$SHA
docker push ykannan108/multi-server:$SHA
docker push ykannan108/multi-worker:$SHA

#apply 
kubectl apply -f k8s
kubectl apply -f k8s/monitoring

#set latest images on a deployment
kubectl set image deployments/server-deployment server=ykannan108/multi-server:$SHA
kubectl set image deployments/client-deployment server=ykannan108/multi-client:$SHA
kubectl set image deployments/worker-deployment server=ykannan108/multi-worker:$SHA

#ignore the unstaged decrypted file
git status -uno