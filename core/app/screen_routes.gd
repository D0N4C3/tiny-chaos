class_name ScreenRoutes
extends RefCounted
## Composition-root route table: screen id -> scene path. The only place in core/ that names
## feature/ui scene files, so core code never imports feature classes.

const ROUTES: Dictionary[StringName, String] = {
	&"home": "res://ui/screens/home/home_screen.tscn",
	&"world_select": "res://features/campaign/world_select/world_select_screen.tscn",
	&"level_select": "res://features/campaign/level_select/level_select_screen.tscn",
	&"settings": "res://features/settings/settings_screen.tscn",
	&"level": "res://features/gameplay/level_screen.tscn",
	&"workshop": "res://features/workshop/workshop_screen.tscn",
	&"daily": "res://features/dailies/daily_screen.tscn",
	&"weekly": "res://features/weeklies/weekly_screen.tscn",
	&"challenges": "res://features/social/challenges_screen.tscn",
	&"shop": "res://features/monetization/shop_screen.tscn",
	&"privacy": "res://features/settings/privacy_screen.tscn",
}
