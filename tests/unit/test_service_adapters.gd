extends TestCase

const ServicesScript: GDScript = preload("res://core/services/services.gd")

var _results: Array = []


func before_each() -> void:
	_results.clear()


func _collect(a: Variant = null, b: Variant = null) -> void:
	_results.append([a, b])


func test_null_ads_answer_no_fill_asynchronously() -> void:
	var ads: AdsAdapter = AdsAdapter.new()
	ads.initialize_with_privacy()
	assert_false(ads.can_show_interstitial(&"result"), "null never shows")
	ads.show_rewarded(&"opp_1", _collect)
	assert_eq(_results.size(), 0, "never synchronous")
	await tree.process_frame
	assert_eq(_results[0][0], AdsAdapter.RewardResult.NO_FILL, "no fill")


func test_rewarded_grants_once_per_opportunity() -> void:
	var ads: TestAdsAdapter = TestAdsAdapter.new()
	ads.initialize_with_privacy()
	ads.show_rewarded(&"opp_1", _collect)
	ads.show_rewarded(&"opp_1", _collect)
	await tree.process_frame
	assert_eq(_results[0][0], AdsAdapter.RewardResult.COMPLETED_REWARDED, "first rewarded")
	assert_eq(_results[1][0], AdsAdapter.RewardResult.NOT_ALLOWED, "duplicate refused")


func test_rewarded_branches_cancel_and_no_fill_and_consent() -> void:
	var ads: TestAdsAdapter = TestAdsAdapter.new()
	ads.show_rewarded(&"before_consent", _collect)
	ads.initialize_with_privacy()
	ads.next_rewarded_result = AdsAdapter.RewardResult.CANCELED
	ads.show_rewarded(&"opp_2", _collect)
	ads.fill = false
	ads.next_rewarded_result = AdsAdapter.RewardResult.COMPLETED_REWARDED
	ads.show_rewarded(&"opp_3", _collect)
	await tree.process_frame
	assert_eq(_results[0][0], AdsAdapter.RewardResult.NOT_ALLOWED, "no ads before consent")
	assert_eq(_results[1][0], AdsAdapter.RewardResult.CANCELED, "canceled")
	assert_eq(_results[2][0], AdsAdapter.RewardResult.NO_FILL, "no fill")


func test_interstitial_respects_entitlement_and_always_closes() -> void:
	var ads: TestAdsAdapter = TestAdsAdapter.new()
	ads.initialize_with_privacy()
	ads.interstitial_closed.connect(_collect)
	assert_true(ads.can_show_interstitial(&"result"), "eligible")
	ads.disable_interstitials(true)
	assert_false(ads.can_show_interstitial(&"result"), "remove_interstitials owned")
	ads.show_interstitial(&"result")
	await tree.process_frame
	assert_eq(ads.shown_interstitials.size(), 0, "not shown")
	assert_eq(_results.size(), 1, "closed signal still fires so flow continues")


func test_mock_billing_purchase_restore_and_revoke() -> void:
	var billing: MockBillingAdapter = MockBillingAdapter.new()
	billing.purchase_finished.connect(_collect)
	billing.entitlement_changed.connect(_collect)
	billing.connect_store()
	billing.purchase(BillingAdapter.SKU_REMOVE_INTERSTITIALS)
	await tree.process_frame
	assert_has(_results, [BillingAdapter.SKU_REMOVE_INTERSTITIALS, BillingAdapter.PurchaseResult.SUCCESS], "purchase ok")
	assert_has(_results, [BillingAdapter.SKU_REMOVE_INTERSTITIALS, true], "entitled")
	_results.clear()
	billing.purchase(BillingAdapter.SKU_REMOVE_INTERSTITIALS)
	await tree.process_frame
	assert_has(_results, [BillingAdapter.SKU_REMOVE_INTERSTITIALS, BillingAdapter.PurchaseResult.ALREADY_OWNED], "already owned")
	var restored: Array = []
	billing.restore_finished.connect(func(skus: PackedStringArray, result: BillingAdapter.PurchaseResult) -> void: restored.append([skus, result]))
	billing.restore()
	await tree.process_frame
	assert_eq(restored[0][0], PackedStringArray(["remove_interstitials"]), "restore lists sku")
	_results.clear()
	billing.next_result = BillingAdapter.PurchaseResult.REVOKED
	billing.purchase(BillingAdapter.SKU_REMOVE_INTERSTITIALS)
	await tree.process_frame
	assert_has(_results, [BillingAdapter.SKU_REMOVE_INTERSTITIALS, false], "revoked removes entitlement")


func test_mock_billing_disconnected_and_pending() -> void:
	var billing: MockBillingAdapter = MockBillingAdapter.new()
	billing.purchase_finished.connect(_collect)
	billing.purchase(BillingAdapter.SKU_REMOVE_INTERSTITIALS)
	billing.connect_store()
	billing.next_result = BillingAdapter.PurchaseResult.PENDING
	billing.purchase(BillingAdapter.SKU_REMOVE_INTERSTITIALS)
	await tree.process_frame
	assert_eq(_results[0][1], BillingAdapter.PurchaseResult.DISCONNECTED, "not connected")
	assert_eq(_results[1][1], BillingAdapter.PurchaseResult.PENDING, "pending")
	assert_false(billing.owned.get(BillingAdapter.SKU_REMOVE_INTERSTITIALS, false), "pending grants nothing")


func test_analytics_enforces_allowlist() -> void:
	assert_eq(AnalyticsSchema.EVENTS.size(), 51, "51 spec events")
	var analytics: MemoryAnalyticsAdapter = MemoryAnalyticsAdapter.new()
	analytics.collection_enabled = true
	assert_true(analytics.track(&"level_start", {"level_id": "W01_L001", "puzzle_type": "rescue", "difficulty_tier": 1}), "valid")
	assert_false(analytics.track(&"level_start", {"level_id": "W01_L001", "email": "a@b.c"}), "non-allowlisted prop")
	assert_false(analytics.track(&"made_up_event"), "unknown event")
	assert_false(analytics.track(&"level_clear", {"level_id": {"nested": 1}}), "non-scalar")
	assert_eq(analytics.events.size(), 1, "only valid event kept")
	assert_eq(analytics.rejected_count, 3, "rejections counted")


func test_analytics_drops_when_collection_disabled() -> void:
	var analytics: MemoryAnalyticsAdapter = MemoryAnalyticsAdapter.new()
	assert_false(analytics.track(&"app_open", {"session_id": "abc"}), "disabled by default")
	assert_eq(analytics.events.size(), 0, "nothing stored")


func test_services_relays_entitlement_to_ads_and_event_bus() -> void:
	var services: Node = add_node(ServicesScript.new())
	var ads: TestAdsAdapter = TestAdsAdapter.new()
	var billing: MockBillingAdapter = MockBillingAdapter.new()
	services.configure(ads, billing, MemoryAnalyticsAdapter.new())
	var bus_events: Array = []
	EventBus.entitlement_changed.connect(func(sku: StringName, owned: bool) -> void: bus_events.append([sku, owned]))
	billing.connect_store()
	billing.purchase(BillingAdapter.SKU_REMOVE_INTERSTITIALS)
	await tree.process_frame
	assert_true(ads.interstitials_disabled, "ads disabled by entitlement")
	assert_has(bus_events, [BillingAdapter.SKU_REMOVE_INTERSTITIALS, true], "EventBus relayed")
	assert_eq(services.adapter_summary(), {"ads": &"test", "billing": &"mock", "analytics": &"memory"}, "summary")
