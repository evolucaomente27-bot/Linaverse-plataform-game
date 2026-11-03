
extends SceneTree

func _init() -> void:
    print('Testing why player cannot move...')
    var level_sc = load('res://scenes/levels/level_1.tscn')
    var level = level_sc.instantiate()
    get_root().add_child(level)
    
    var player = level.get_node_or_null('Player')
    print('Player exists:', player != null)
    if player:
        print('Player position:', player.global_position)
        print('Player is_on_floor:', player.is_on_floor())
        print('Player collision_layer:', player.collision_layer, 'mask:', player.collision_mask)
        print('Player process_mode:', player.process_mode)
    
    var gm = get_root().get_node_or_null('GameManager')
    if gm:
        print('GameManager is_game_over:', gm.is_game_over)
        print('GameManager is_level_completed:', gm.is_level_completed)
        print('Tree paused:', paused)
    
    # Check UI overlays
    for ui_name in ['HUD', 'PauseMenu', 'GameOverMenu', 'VictoryMenu']:
        var ui = level.get_node_or_null(ui_name)
        if ui:
            print(ui_name, 'visible:', ui.visible)
            var panel = ui.get_node_or_null('Panel')
            if panel:
                print('  panel visible:', panel.visible, 'mouse_filter:', panel.mouse_filter)
    quit()
