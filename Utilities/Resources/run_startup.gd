class_name RunStartup
extends Resource

enum Type {NEW_RUN, CONTINUED_RUN}

@export var type: Type
@export var current_party : CurrentParty