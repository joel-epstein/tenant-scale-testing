package v2

// Configuration for the Datadog tracer.
// [#extension: envoy.tracers.datadog]
#DatadogConfig: {
	// The cluster to use for submitting traces to the Datadog agent.
	collector_cluster?: string
	// The name used for the service when traces are generated by envoy.
	service_name?: string
}
