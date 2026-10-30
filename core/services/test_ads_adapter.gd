class_name TestAdsAdapter
extends AdsAdapter
## Editor/debug ads simulation with the same event semantics as the native adapter.
## Tests and QA set next_rewarded_result / fill to exercise every branch without an SDK.

var fill: bool = true
var next_rewarded_result: RewardResult = RewardResult.COMPLETED_REWARDED
var shown_interstitials: Array[StringName] = []

var _rewarded_opportunities: Dictionary[StringName, bool] = {}


func adapter_name() -> StringName:
	return &"test"


func initialize_with_privacy() -> void:
	_set_consent(&"not_required")


func can_show_interstitial(_placement: StringName) -> bool:
	return fill and not interstitials_disabled and consent_state != &"unknown"


func show_interstitial(placement: StringName) -> void:
	if can_show_interstitial(placement):
		shown_interstitials.append(placement)
	interstitial_closed.emit.call_deferred(placement)


## Each opportunity id can be rewarded once; repeats answer NOT_ALLOWED (no duplicate grants).
func show_rewarded(reward_opportunity_id: StringName, on_result: Callable) -> void:
	var result: RewardResult = next_rewarded_result
	if consent_state == &"unknown":
		result = RewardResult.NOT_ALLOWED
	elif _rewarded_opportunities.has(reward_opportunity_id):
		result = RewardResult.NOT_ALLOWED
	elif not fill:
		result = RewardResult.NO_FILL
	if result == RewardResult.COMPLETED_REWARDED:
		_rewarded_opportunities[reward_opportunity_id] = true
	on_result.call_deferred(result)
