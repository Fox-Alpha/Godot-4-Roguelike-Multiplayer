extends MultiplayerSpawner

#[Export] private PackedScene _playerScene;
@export var _playerScene : PackedScene
#[Export] private PackedScene _serverPlayerScene;
@export var _serverPlayerScene : PackedScene
#[Export] private PackedScene _dummyScene;
@export var _dummyScene : PackedScene

#[Export] private int startmode = -1;
@export var startmode : int = -1

#private static ClientPlayer localPlayer;
static var localPlayer : ClientPlayer

#public static ClientPlayer LocalPlayer { get => localPlayer; set => localPlayer = value; }
static var LocalPlayer : ClientPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	#Callable customSpawnFunctionCallable = new (this, nameof(CustomSpawnFunction));
	var customSpawnFunctionCallable : Callable = Callable(CustomSpawnFunction)
	spawn_function = customSpawnFunctionCallable;

	var uid = multiplayer.get_unique_id();
	set_multiplayer_authority(uid)


func CustomSpawnFunction(data:int):
	#int spawnedPlayerID = (int)data;
	var spawnedPlayerID:int = data
	#int localID = Multiplayer.GetUniqueId();
	var localID : int = multiplayer.get_unique_id()

	#// Server character for simulation
	#if (localID == 1 && startmode == 2)
	if localID == 1:
	#{
		#GD.Print("Spawned server character");
		print("Spawned server character")
		#ServerPlayer player = _serverPlayerScene.Instantiate() as ServerPlayer;
		var player : ServerPlayer = _serverPlayerScene.instantiate() as ServerPlayer
		#player.Name = spawnedPlayerID.ToString();
		player.name = str(spawnedPlayerID)
		#player.MultiplayerID = spawnedPlayerID;
		player.MultiplayerID = str(spawnedPlayerID)
		return player;
	#}

	#// Client player
	#if (localID == spawnedPlayerID)
	elif localID == spawnedPlayerID:
	#{
		#GD.Print("Spawned client player");
		print("Spawned client player")
		#ClientPlayer player = _playerScene.Instantiate() as ClientPlayer;
		var player : ClientPlayer = _playerScene.instantiate() as ClientPlayer
		#player.Name = spawnedPlayerID.ToString();
		player.name = str(spawnedPlayerID)
		#player.SetMultiplayerAuthority(spawnedPlayerID);
		player.set_multiplayer_authority(spawnedPlayerID)
		#LocalPlayer = player;
		LocalPlayer = player
		return player;
	#}

	else:
		print("Spawned dummy");
		#Node player = _dummyScene.Instantiate();
		var player : Node = _dummyScene.instantiate()
		#player.Name = spawnedPlayerID.ToString();
		player.name = str(spawnedPlayerID)
		#player.SetMultiplayerAuthority(spawnedPlayerID);
		player.set_multiplayer_authority(spawnedPlayerID)
		return player;

