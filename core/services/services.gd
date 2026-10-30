extends Node
## Autoload `Services`: chooses ads/billing/analytics adapters for this build and relays
## entitlement/consent changes to EventBus. Native adapters arrive in P08/P09; until then debug
## builds use test/mock adapters and release builds use the null adapters (never blocking play).

var ads: AdsAdapter
var billing: BillingAdapter
var analytics: AnalyticsAdapter


func _ready() -> void:
	if OS.is_debug_build():
		configure(TestAdsAdapter.new(), MockBillingAdapter.new(), MemoryAnalyticsAdapter.new())
	else:
		configure(AdsAdapter.new(), BillingAdapter.new(), AnalyticsAdapter.new())
	ads.initialize_with_privacy()
	billing.connect_store()


## Swaps adapters (tests, or native adapters once their plugins are verified).
func configure(ads_adapter: AdsAdapter, billing_adapter: BillingAdapter, analytics_adapter: AnalyticsAdapter) -> void:
	ads = ads_adapter
	billing = billing_adapter
	analytics = analytics_adapter
	ads.consent_changed.connect(_on_consent_changed)
	billing.entitlement_changed.connect(_on_entitlement_changed)
	# Local memory adapter never transmits, so it may collect in debug; real adapters need consent.
	analytics.collection_enabled = analytics is MemoryAnalyticsAdapter


func adapter_summary() -> Dictionary:
	return {"ads": ads.adapter_name(), "billing": billing.adapter_name(), "analytics": analytics.adapter_name()}


func _on_entitlement_changed(sku: StringName, owned: bool) -> void:
	if sku == BillingAdapter.SKU_REMOVE_INTERSTITIALS:
		ads.disable_interstitials(owned)
	var event_bus: Node = get_node_or_null("/root/EventBus")
	if event_bus != null:
		event_bus.call("emit_entitlement_changed", sku, owned)


func _on_consent_changed(consent_state: StringName) -> void:
	var event_bus: Node = get_node_or_null("/root/EventBus")
	if event_bus != null:
		event_bus.call("emit_consent_changed", consent_state)
