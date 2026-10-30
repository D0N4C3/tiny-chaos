class_name MemoryAnalyticsAdapter
extends AnalyticsAdapter
## Editor/debug analytics: keeps a bounded in-memory queue for QA inspection; nothing is sent.

const MAX_EVENTS: int = 500

var events: Array[Dictionary] = []
var dropped_count: int = 0


func adapter_name() -> StringName:
	return &"memory"


func _deliver(event_name: StringName, properties: Dictionary) -> void:
	if events.size() >= MAX_EVENTS:
		events.pop_front()
		dropped_count += 1
	events.append({"event": event_name, "properties": properties.duplicate(), "msec": Time.get_ticks_msec()})


func flush() -> void:
	events.clear()
