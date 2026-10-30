class_name MockBillingAdapter
extends BillingAdapter
## Editor/debug store simulation. Prices are labelled as test values; real prices come from Play.
## QA sets next_result to walk pending/canceled/already-owned/revoked/disconnected paths.

var next_result: PurchaseResult = PurchaseResult.SUCCESS
var owned: Dictionary[StringName, bool] = {}
var catalog: Dictionary[StringName, String] = {
	BillingAdapter.SKU_REMOVE_INTERSTITIALS: "Remove interstitial ads",
}

var _connected: bool = false


func adapter_name() -> StringName:
	return &"mock"


func is_available() -> bool:
	return _connected


func connect_store() -> void:
	_connected = next_result != PurchaseResult.DISCONNECTED
	connected.emit.call_deferred(_connected)


func query_products(skus: PackedStringArray) -> void:
	var products: Array[Dictionary] = []
	if _connected:
		for sku: String in skus:
			if catalog.has(StringName(sku)):
				products.append({"sku": StringName(sku), "title": catalog[StringName(sku)], "price_text": "TEST"})
	products_loaded.emit.call_deferred(products)


func purchase(sku: StringName) -> void:
	var result: PurchaseResult = next_result
	if not _connected:
		result = PurchaseResult.DISCONNECTED
	elif not catalog.has(sku):
		result = PurchaseResult.ERROR
	elif owned.get(sku, false) and result == PurchaseResult.SUCCESS:
		result = PurchaseResult.ALREADY_OWNED
	match result:
		PurchaseResult.SUCCESS, PurchaseResult.ALREADY_OWNED:
			_set_owned(sku, true)
		PurchaseResult.REVOKED:
			_set_owned(sku, false)
	purchase_finished.emit.call_deferred(sku, result)


func restore() -> void:
	if not _connected:
		restore_finished.emit.call_deferred(PackedStringArray(), PurchaseResult.DISCONNECTED)
		return
	var skus: PackedStringArray = PackedStringArray()
	for sku: StringName in owned.keys():
		if owned[sku]:
			skus.append(String(sku))
			entitlement_changed.emit.call_deferred(sku, true)
	restore_finished.emit.call_deferred(skus, PurchaseResult.SUCCESS)


func _set_owned(sku: StringName, value: bool) -> void:
	if owned.get(sku, false) == value:
		return
	owned[sku] = value
	entitlement_changed.emit.call_deferred(sku, value)
