extends Node2D

@onready var label = $InteractionLabel

var interactions := []

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if interactions:
			label.hide()
			await interactions[0].interact.call()
		else:
			print("dropping plug")
			Events.drop_plug.emit()

func _process(_delta: float) -> void:
	if interactions:
		var interaction = interactions[0]
		label.text = interaction.interaction_name
		label.show()
	else:
		label.hide()


func _on_range_area_entered(area: Area2D) -> void:
	if "interact" in area:
		interactions.push_back(area)


func _on_range_area_exited(area: Area2D) -> void:
	interactions.erase(area)
