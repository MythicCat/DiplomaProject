extends TextureProgress

onready var tween = get_node("../../../../Tween")

func update_hp():
	var new_value = (PlayerVariables.lives + 1) * 25
	tween.interpolate_property(self, "value", self.value, new_value, 0.5)
	tween.start()
