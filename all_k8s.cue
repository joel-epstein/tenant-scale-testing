// cue eval all_k8s.cue -e everything_yaml --out text -t number=150 -t namespace=foobar-1


import (
	"strings"
	"strconv"
	"list"
	"encoding/yaml"
)

namespace: string | *"foobar-1" @tag(namespace)
number: int | *1 @tag(number,type=int)

_namespace2fruit: {
	"foobar-1": "kiwi",
	"foobar-2": "peach",
	"foobar-3": "orange",
	"foobar-4": "fig",
	"foobar-5": "grape",
	"foobar-6": "melon",
	"foobar-7": "cranberry",
	"foobar-8": "star",
	"foobar-9": "tangerine",
	"foobar-10": "blueberry",
	"foobar-11": "salmon"
	"foobar-12": "crab"
}



everything: list.Concat([
	(_sync_template & {_namespace: namespace}).objects,
	(_manifests_template & {_namespace: namespace}).objects,
	all_fruit,
	// [_vegeta_template & {_namespace: namespace}],
])

everything_yaml: yaml.MarshalStream(everything)



all_fruit: [for i in list.Range(1,number+1,1) {

   _fruit_template & {
     _name:"\(_namespace2fruit[namespace])\(i)"
     _namespace: namespace
  }

}]

_fruit_template: {
	_name: string
  _namespace: string
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name: _name
    namespace: _namespace
		annotations: "greymatter.io/inject-sidecar-to": "9090"
	}
	spec: {
		selector: matchLabels: app: _name
		replicas: 1 
		template: {
			metadata: labels: app: _name
			spec: {
				securityContext: sysctls: [
						{name: "net.ipv4.ip_local_port_range", value: "12000 65000"},
				]
				containers: [{
					name:  _name
					image: "greymatter.jfrog.io/internal-oci/fake-service:v0.24.2"
					// env: [
					// 	{name: "ERROR_RATE", value: "0.1"},
					// 	{name: "ERROR_CODE", value: "501"},
					// ]
				}]
			}
		}
	}
}



/////////
// vegeta.yaml

_vegeta_template: {
  _namespace: string
	_num: strings.Split(_namespace, "-")[1]
	_port: 10808+strconv.Atoi(_num)

	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name: "vegeta"
    namespace: _namespace
	}
	spec: {
		selector: matchLabels: app: "vegeta"
		replicas: 10
		template: {
			metadata: labels: app: "vegeta"
			spec: {
				securityContext: sysctls: [
					{name: "net.ipv4.ip_local_port_range", value: "12000 65000"},
					// {name: "net.ipv4.tcp_fin_timeout", value: "60"},
					// {name: "net.ipv4.tcp_tw_recycle", value: "1"},
					// {name: "net.ipv4.tcp_tw_reuse", value: "1"},
					// {name: "net.core.somaxconn", value: "512"},
				]
				imagePullSecrets: [{
					name: "gm-docker-secret"
				}]
				containers: [{
					name: "vegeta"
					image: "greymatter.jfrog.io/internal-oci/vegeta:latest"
					env: [
						{name: "TARGET_FQDN", value: "edge-projectwaldo\(_num).\(_namespace).svc.cluster.local:\(_port)"},
						{name: "TARGET_OBJECT", value: _namespace2fruit[_namespace]},
						{name: "COUNT", value: "\(number)"},
						{name: "RATE", value: "840"},
						{name: "DURATION", value: "0s"},
						{name: "BLOCK", value: "false"},
					]
				}]
			}
		}
	}
}





///////
//sync.yaml

_sync_template: {
	_namespace: string
	objects: [{
		apiVersion: "apps/v1"
		kind:       "StatefulSet"
		metadata: {
			name:      "greymatter-sync"
			namespace: _namespace
		}
		spec: {
			selector: matchLabels: app: "greymatter-sync"
			serviceName: "greymatter-sync"
			replicas:    1
			template: {
				metadata: labels: app: "greymatter-sync"
				spec: {
					terminationGracePeriodSeconds: 10
					imagePullSecrets: [{
						name: "gm-docker-secret"
					}]
					volumes: [{
						name: "ssh-private-key"
						secret: secretName: "greymatter-sync-secret"
					}]
					containers: [{
						name:            "greymatter-sync"
						image:           "greymatter.jfrog.io/release-oci/greymatter-cli:4.5.7"
						imagePullPolicy: "Always"
						command: ["/usr/local/bin/greymatter"]
						args: [
							"--api",
							"http://controlensemble.greymatter.svc.cluster.local:5555",
							"--catalog",
							"http://catalog.greymatter.svc.cluster.local:8080",
							"sync",
							"--ssh-private-key",
							"/var/lib/greymatter/.ssh/ssh-private-key",
							"--git",
							"--forever",
							"--branch",
							_namespace,
							"--interval",
							"3s",
							"--git-dir",
							"/var/lib/greymatter/checkout",
							"-e",
							"",
							"--redis-addr",
							"greymatter-datastore.greymatter.svc.cluster.local:6379",
							"--redis-passphrase",
							"",
							"--redis-username",
							"",
							"--redis-db",
							"0",
						]
						volumeMounts: [{
							name:      "ssh-private-key"
							readOnly:  true
							mountPath: "/var/lib/greymatter/.ssh"
						}]
						env: [{
							name:  "SSH_KNOWN_HOSTS"
							value: "/tmp/known_hosts"
						}, {
							name: "GREYMATTER_GIT_REMOTE"
							valueFrom: configMapKeyRef: {
								name: "greymatter-sync-config"
								key:  "GREYMATTER_GIT_REMOTE"
							}
						}]
					}]
				}
			}
		}
	}, {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name:      "greymatter-sync-config"
			namespace: _namespace
		}
		data: {
			GREYMATTER_GIT_REMOTE: "git@github.com:joel-epstein/tenant-scale-testing.git"
		}
	}]
}


////////////
// edge-foobar-X.yaml


_manifests_template: {
	_namespace: string
	// _num: strings.Split(_namespace, "-")[1]
	_num: ""
	_port: 10809
	objects: [{
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      "edge"
			namespace: _namespace
		}
		spec: {
			replicas: 10
			selector: matchLabels: "greymatter.io/cluster": "\(_namespace)-edge"
			template: {
				metadata: labels: "greymatter.io/cluster": "\(_namespace)-edge"
				spec: {
					securityContext: sysctls: [
						{name: "net.ipv4.ip_local_port_range", value: "12000 65000"},
						// {name: "net.ipv4.tcp_fin_timeout", value: "60"},
						// {name: "net.ipv4.tcp_tw_recycle", value: "1"},
						// {name: "net.ipv4.tcp_tw_reuse", value: "1"},
						// {name: "net.core.somaxconn", value: "512"},
					]
					containers: [{
						name:            "sidecar"
						image:           "greymatter.jfrog.io/dev-oci/gm-proxy:1.8.1"
						imagePullPolicy: "Always"
						ports: [{
							containerPort: _port
							name:          "proxy"
						}]
						env: [{
							name:  "XDS_CLUSTER"
							value: "\(_namespace)-edge"
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
			namespace: _namespace
		}
		spec: {
			ports: [{
				name:       "ingress"
				port:       _port
				protocol:   "TCP"
				targetPort: _port
			}]
			selector: "greymatter.io/cluster": "\(_namespace)-edge"
			type: "LoadBalancer"
		}
	}]
}
