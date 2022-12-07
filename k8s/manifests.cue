[{
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      "edge"
		namespace: "main"
	}
	spec: {
		replicas: 1
		selector: matchLabels: "greymatter.io/cluster": "main-edge"
		template: {
			metadata: labels: "greymatter.io/cluster": "main-edge"
			spec: {
				containers: [{
					name:            "sidecar"
					image:           "greymatter.jfrog.io/release-oci/greymatter-proxy:1.8.1"
					imagePullPolicy: "Always"
					ports: [{
						containerPort: 10809
						name:          "proxy"
					}]
					env: [{
						name:  "XDS_CLUSTER"
						value: "main-edge"
					}, {
						name:  "ENVOY_ADMIN_LOG_PATH"
						value: "/dev/stdout"
					}, {
						name:  "PROXY_DYNAMIC"
						value: "true"
					}, {
						name:  "XDS_ZONE"
						value: "default-zone"
					}, {
						name:  "XDS_HOST"
						value: "controlensemble.greymatter.svc.cluster.local"
					}, {
						name:  "XDS_PORT"
						value: "50000"
					}]
					resources: {
						limits: {
							cpu:    "200m"
							memory: "200Mi"
						}
						requests: {
							cpu:    "100m"
							memory: "128Mi"
						}
					}
				}]
				imagePullSecrets: [{
					name: "gm-docker-secret"
				}]
			}
		}
	}
}, {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:      "edge"
		namespace: "main"
	}
	spec: {
		ports: [{
			name:       "ingress"
			port:       10809
			protocol:   "TCP"
			targetPort: 10809
		}]
		selector: "greymatter.io/cluster": "main-edge"
		type: "LoadBalancer"
	}
}]
