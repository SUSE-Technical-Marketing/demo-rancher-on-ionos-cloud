## v0.1.0 (2025-12-12)

### Feat

- **tf**: cloud-init move rke2 install logic into one-shot systemd service
- **tf**: rancher task for 60sec delay, dependency to lb rules ready
- **tf**: increase lb health check timeout, weight 100 for first rancher server target
- **tf**: rancher installation on rke2 cluster through first server node
- **tf**: prepare for rancher install, retrieve kubeconfig
- **tf**: split rancher resources and add k8s load balancing
- **tf**: add network load balancer in front of rancher servers
- **tf**: rancher server in private network, rke2 installation during cloud-init
- **tf**: include passwd in output, adjust cloud-init for rancher servers
- **tf**: cloud init scc registration and rancher server dns output
- **tf**: show rancher server ips as output
- **tf**: add 'ionoscloud_server' and related resources for rancher vms
- **tf**: add 'ionoscloud_lan' resources for public and private network
- **tf**: add ionoscloud_datacenter resource
- **tf**: add and init ionos provider

### Fix

- **tf**: reduce lb and node wait time from 300 to 120 secs
- **tf**: Don't reboot nodes, wait 300 sec before rancher install
- **tf**: add nullable false to some vars
- **tf**: cloud-init for additional server used userdata from first server
- **tf**: wrong private ip for first rancher server in output
- **tf**: add reboot to additional rancher server cloud-init
- **tf**: make additional servers depend on first rancher server
- **tf**: decouple public ip from first server into ipblock resource

### Refactor

- **tf**: move resources in own .tf files
