class_name BillingAdapter
extends RefCounted
## Play Billing contract (spec 02_TECH/03). This base class IS the null adapter: the store is
## unavailable, so no products or purchases are offered. Saved entitlement is only a cache.

enum PurchaseResult { SUCCESS, PENDING, CANCELED, ALREADY_OWNED, REVOKED, DISCONNECTED, UNAVAILABLE, ERROR }

const SKU_REMOVE_INTERSTITIALS: StringName = &"remove_interstitials"

signal connected(available: bool)
## products: Array of {"sku": StringName, "title": String, "price_text": String}
signal products_loaded(products: Array[Dictionary])
signal purchase_finished(sku: StringName, result: PurchaseResult)
signal restore_finished(owned_skus: PackedStringArray, result: PurchaseResult)
@warning_ignore("unused_signal") # Contract signal: emitted by store-backed subclasses only.
signal entitlement_changed(sku: StringName, owned: bool)


func adapter_name() -> StringName:
	return &"null"


func is_available() -> bool:
	return false


func connect_store() -> void:
	connected.emit.call_deferred(false)


func query_products(_skus: PackedStringArray) -> void:
	products_loaded.emit.call_deferred([] as Array[Dictionary])


func purchase(sku: StringName) -> void:
	purchase_finished.emit.call_deferred(sku, PurchaseResult.UNAVAILABLE)


func restore() -> void:
	restore_finished.emit.call_deferred(PackedStringArray(), PurchaseResult.UNAVAILABLE)


static func result_name(result: PurchaseResult) -> StringName:
	return StringName(String(PurchaseResult.keys()[result]).to_lower())
