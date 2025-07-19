extends Node

# when the player first picks up from a plug
signal grab_plug()

# when the player puts the plug down, without connecting to an outlet
signal drop_plug()

# when the player _attempts_ to plug into an outlet
signal try_plug_in()

# when plugging into an outlet is successful, connecting active cables
signal plug_in()
