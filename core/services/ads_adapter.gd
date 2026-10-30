class_name AdsAdapter
extends RefCounted
## Ads contract (spec 02_TECH/03). This base class IS the null adapter: nothing loads, rewarded
## requests answer NO_FILL on the next frame, and gameplay is never blocked.
## Placement policy (caps, "never after failure") lives in features/monetization, not here.

enum RewardResult { COMPLETED_REWARDED, CANCELED, NO_FILL, SDK_ERROR, NOT_ALLOWED }

signal consent_changed(consent_state: StringName)
signal interstitial_closed(placement: StringName)

var interstitials_disabled: bool = false
var consent_state: StringName = &"unknown"


func adapter_name() -> StringName:
	return &"null"


func initialize_with_privacy() -> void:
	_set_consent(&"not_available")


func can_show_interstitial(_placement: StringName) -> bool:
	return false


## Shows an interstitial if allowed; always ends with interstitial_closed so callers can continue.
func show_interstitial(placement: StringName) -> void:
	interstitial_closed.emit.call_deferred(placement)


## on_result: Callable(result: RewardResult). Called exactly once, never synchronously.
func show_rewarded(_reward_opportunity_id: StringName, on_result: Callable) -> void:
	on_result.call_deferred(RewardResult.NO_FILL)


func disable_interstitials(entitlement: bool) -> void:
	interstitials_disabled = entitlement


func open_privacy_choices() -> void:
	pass


static func result_name(result: RewardResult) -> StringName:
	return StringName(String(RewardResult.keys()[result]).to_lower())


func _set_consent(state: StringName) -> void:
	if consent_state == state:
		return
	consent_state = state
	consent_changed.emit(state)
