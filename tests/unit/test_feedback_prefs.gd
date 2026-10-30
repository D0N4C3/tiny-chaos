extends TestCase


func before_each() -> void:
	Haptics.reset_for_tests()
	MotionPrefs.override_settings = {}


func after_each() -> void:
	Haptics.reset_for_tests()
	MotionPrefs.override_settings = {}


func test_haptics_respect_toggle_and_rate_limit() -> void:
	var pulses: Array = []
	Haptics.sink = func(ms: int, amp: float) -> void: pulses.append([ms, amp])
	Haptics.override_enabled = 0
	assert_false(Haptics.play(Haptics.Pattern.TAP), "disabled")
	Haptics.override_enabled = 1
	assert_true(Haptics.play(Haptics.Pattern.SUCCESS), "enabled")
	assert_false(Haptics.play(Haptics.Pattern.TAP), "rate limited")
	assert_eq(pulses, [[40, 0.6]], "one success pulse")
	for preset: Array in Haptics.PRESETS.values():
		assert_true(int(preset[0]) <= 50, "no long rattles")


func test_reduced_motion_disables_decoration_but_keeps_information() -> void:
	MotionPrefs.override_settings = {"reduced_motion": false, "camera_shake": true}
	assert_true(MotionPrefs.shake_enabled(), "shake on by default")
	assert_eq(MotionPrefs.scaled_duration(1.0), 1.0, "full duration")
	MotionPrefs.override_settings = {"reduced_motion": true, "camera_shake": true}
	assert_false(MotionPrefs.shake_enabled(), "shake off")
	assert_false(MotionPrefs.flashes_enabled(), "flashes off")
	assert_false(MotionPrefs.particles_enabled(), "decorative particles off")
	assert_true(MotionPrefs.particles_enabled(true), "essential particles kept")
	assert_true(MotionPrefs.scaled_duration(1.0) < 0.5, "decorative shortened")
	assert_eq(MotionPrefs.scaled_duration(1.0, true), 1.0, "informative unchanged")
	MotionPrefs.override_settings = {"reduced_motion": false, "camera_shake": false}
	assert_false(MotionPrefs.shake_enabled(), "independent shake toggle")
