class_name AnalyticsAdapter
extends RefCounted
## Analytics contract. track() enforces the generated allowlist (AnalyticsSchema): unknown events
## and non-allowlisted properties are rejected so no unplanned or personal data leaves the device.
## This base class IS the null adapter: validated events are dropped.

## Collection is consent-aware; Services turns this on only when allowed.
var collection_enabled: bool = false
var rejected_count: int = 0


func adapter_name() -> StringName:
	return &"null"


## Returns true when the event passed validation and collection is enabled.
func track(event_name: StringName, properties: Dictionary = {}) -> bool:
	if not AnalyticsSchema.EVENTS.has(event_name):
		return _reject("unknown analytics event %s" % event_name)
	var allowed: Array = AnalyticsSchema.EVENTS[event_name]
	for key: Variant in properties.keys():
		if not allowed.has(str(key)):
			return _reject("property %s not allowlisted for %s" % [key, event_name])
		var value: Variant = properties[key]
		if not (value is String or value is StringName or value is int or value is float or value is bool):
			return _reject("property %s of %s must be a scalar" % [key, event_name])
	if not collection_enabled:
		return false
	_deliver(event_name, properties)
	return true


func flush() -> void:
	pass


func _deliver(_event_name: StringName, _properties: Dictionary) -> void:
	pass


func _reject(reason: String) -> bool:
	rejected_count += 1
	push_warning("Analytics rejected: " + reason)
	return false
