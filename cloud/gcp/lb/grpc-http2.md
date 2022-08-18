To use gRPC with your Google Cloud applications, you must proxy requests end-to-end over HTTP/2. To do this:

Configure an HTTPS load balancer.
Enable HTTP/2 as the protocol from the load balancer to the backends.

If you want to configure an external HTTP(S) load balancer by using HTTP/2 with Google Kubernetes Engine Ingress or by using gRPC and HTTP/2 with Ingress, see [HTTP/2 for load balancing with Ingress](https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-http2).

[鏈結](https://cloud.google.com/load-balancing/docs/https#using_grpc_with_your_applications)