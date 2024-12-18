STEPS TO RUN

- Go to bin and run `download.sh` then `source set.sh`
- RUN `run.sh` in clusters and wait until ready using `kubectl get nodes`
- RUN `startup.sh` in ingress directory and check until controler runnig using `kubectl get pods -n ingress-nginx`
- RUN the app in app directory for deplyment and service

