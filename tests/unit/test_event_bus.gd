extends TestCase

const EventBusScript: GDScript = preload("res://core/events/event_bus.gd")

var _bus: Node
var _received: Array = []


func before_each() -> void:
	_bus = add_node(EventBusScript.new())
	_received.clear()


func _capture(a: Variant = null, b: Variant = null, c: Variant = null) -> void:
	_received.append([a, b, c])


func test_level_completed_delivers_typed_payload() -> void:
	_bus.level_completed.connect(_capture)
	var medals: PackedStringArray = ["rescue"]
	_bus.emit_level_completed(&"W01_L001", medals, {"seconds": 21.5, "actions": 2, "retry_count": 0})
	assert_eq(_received.size(), 1, "one emission")
	assert_eq(_received[0][0], &"W01_L001", "level id")
	assert_eq(_received[0][1], medals, "medals")
	assert_eq((_received[0][2] as Dictionary)["actions"], 2, "metrics.actions")


func test_level_completed_rejects_unschematized_metrics() -> void:
	_bus.level_completed.connect(_capture)
	_bus.emit_level_completed(&"W01_L001", PackedStringArray(), {"seconds": 1.0, "actions": 1, "retry_count": 0, "email": "x"})
	_bus.emit_level_completed(&"W01_L001", PackedStringArray(), {"seconds": 1.0})
	assert_eq(_received.size(), 0, "extra or missing metric keys must not emit")


func test_level_failed_carries_cause_enum() -> void:
	_bus.level_failed.connect(_capture)
	_bus.emit_level_failed(&"W02_L006", EventBusScript.FailCause.STUCK, 3)
	assert_eq(_received[0][1], EventBusScript.FailCause.STUCK, "cause")
	assert_eq(EventBusScript.fail_cause_name(EventBusScript.FailCause.OUT_OF_BOUNDS), &"out_of_bounds", "analytics name")


func test_every_signal_has_an_emit_helper() -> void:
	var methods: PackedStringArray = PackedStringArray()
	for info: Dictionary in _bus.get_method_list():
		methods.append(info["name"])
	for info: Dictionary in EventBusScript.get_script_signal_list():
		var signal_name: String = info["name"]
		var helper: String = "emit_" + signal_name.trim_suffix("_reported")
		assert_true(methods.has(helper), "missing helper %s for signal %s" % [helper, signal_name])
