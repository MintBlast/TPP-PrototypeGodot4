extends Area3D

class_name Interactable

# Emits when player looks at interactable
signal focused(interactor: Interactor)
# Emits when player stops looking at interactable
signal unfocused(interactor: Interactor)
# Emits when player interacts with interactable
signal interacted(interactor: Interactor)
# Emits when player cancels with interactable
signal cancel(interactor: Interactor)
