extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	body.health_component.take_damage(25)
