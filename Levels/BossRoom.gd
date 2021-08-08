extends Node



func _on_PlayerEntered_body_entered(body):
	if $BossRoomCamera.current:
		var player = get_node("../Player")
		var playerCam = player._get_camera()
		playerCam.current = true
	else:
		$BossRoomCamera.current = true
