1   Deploy nginx pod with lable nginx
2   service yaml with metadata :nginx-service for nginx pod with cluster IP

# This policy only allows ingress traffic to nginx pods from pods with label access: granted.
3   write NetworkPolicy metadata name: [allo=specific] | policy type ingress | podSelector  >>matchLabels >> access: granted

4   Apply the nginx deployment and service:
 kubectl apply -f nginx-deployment.yaml
5   Apply the NetworkPolicy: 
 kubeclt apply -f nginx-networkpolicy.yaml



6   Test the NetworkPolicy:
  Allowed Pod
Run a test pod with the correct label:
  kubectl run test-allowed --image=busybox -l access=granted -it --rm -- /bin/sh

  # write command in container CLI 
  wget --spider nginx-service
  # get responds 
remote file exists ( Should succeed.)


7   Denied Pod
Run a test pod without the label:
  kubectl run test-denied --image=busybox -it --rm -- /bin/sh
  # write command in container CLI 
  wget --spider nginx-service
  # get responds 
  ❌ Should fail (blocked by NetworkPolicy).
