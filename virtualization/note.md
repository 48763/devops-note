# Note

## IPVS

IPVS (IP Virtual Server) implements transport-layer load balancing inside the Linux kernel, so called Layer-4 switching. IPVS running on a host acts as a load balancer at the front of a cluster of real servers, it can direct requests for TCP/UDP based services to the real servers, and makes services of the real servers to appear as a virtual service on a single IP address.

> http://linux-vs.org/software/ipvs.html