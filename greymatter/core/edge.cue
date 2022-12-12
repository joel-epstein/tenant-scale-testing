// Edge configuration for enterprise mesh-segmentation. This is a dedicated
// edge proxy that provides north/south network traffic to services in this
// repository in the mesh. This edge would be separate from the default
// greymatter edge that is deployed via enterprise-level configuration in
// the gitops-core git repository.
package foobar_3

import (
	gsl "greymatter.io/gsl/v1"

	"foobar_3.module/greymatter:globals"
)

Edge: gsl.#Service & {
	// A context provides global information from globals.cue
	// to your service definitions.
	context: Edge.#NewContext & globals

	name:              "edge"
	display_name:      "Foobar 3 Edge"
	version:           "v1.8.1"
	description:       "Edge ingress for foobar-3"
	api_endpoint:              "N/A"
	api_spec_endpoint:         "N/A"
	business_impact:           "high"
	owner: "Foobar 3"
	capability: ""
	
	ingress: {
		// Edge -> HTTP ingress to your container
		(name): {
			gsl.#HTTPListener
			
			port: 10809
				

			routes: "/": upstreams: (name): { 
				namespace: context.globals.namespace 
			}
		}
	}
}

exports: "edge-foobar-3": Edge
