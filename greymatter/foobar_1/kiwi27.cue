package foobar_1

import (
	gsl "greymatter.io/gsl/v1"

	"foobar_1.module/greymatter:globals"
)


Kiwi27: gsl.#Service & {
	// A context provides global information from globals.cue
	// to your service definitions.
	context: Kiwi27.#NewContext & globals

	// name must follow the pattern namespace/name
	name:          "kiwi27"
	display_name:  "Foobar 1 Kiwi27"
	version:       "v1.0.0"
	description:   "EDIT ME"
	api_endpoint:              "http://\(context.globals.edge_host)/services/\(context.globals.namespace)/\(name)/"
	api_spec_endpoint:         "http://\(context.globals.edge_host)/services/\(context.globals.namespace)/\(name)/"
	business_impact:           "low"
	owner: "Foobar 1"
	capability: ""
	
	// Kiwi27 -> ingress to your container
	ingress: {
		(name): {
			gsl.#HTTPListener
			
			
			
			routes: {
				"/": {
					upstreams: {
						"local": {
							
							instances: [
								{
									host: "127.0.0.1"
									port: 9090
								},
							]
						}
					}
				}
			}
		}
	}


	
	// Edge config for the Kiwi27 service.
	// These configs are REQUIRED for your service to be accessible
	// outside your cluster/mesh.
	edge: {
		edge_name: "edge"
		routes: "/services/\(context.globals.namespace)/\(name)": upstreams: (name): {
			namespace: context.globals.namespace
			
		}
	}
	
}

exports: "kiwi27": Kiwi27
