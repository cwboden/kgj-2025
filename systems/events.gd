extends Node

# when the player is near a plug and can pick up
signal can_grab_plug()

# when the player first picks up from a plug
signal grab_plug()

# when the player puts the plug down, without connecting to an outlet
signal drop_plug()

# when the player is near an outlet and can possibly plugin
signal can_plug_in()

# when the player _attempts_ to plug into an outlet
signal try_plug_in()

# when plugging into an outlet is successful, connecting active cables
signal plug_in()

enum Ability {
	JUMP,
	DASH,
	SHOOT,
}

# when changing a player ability
signal set_ability(type: Ability, is_active: bool)
