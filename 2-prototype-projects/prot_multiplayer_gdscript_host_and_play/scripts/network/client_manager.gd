class_name Client_Manager extends Node

#[Export] private string _address = "localhost";
@export var _adress : String = "localhost"
#[Export] private int _port = 9999;
@export var _port : int = 9999

#private SceneMultiplayer _multiplayer = new();
@onready var _multiplayer : SceneMultiplayer = SceneMultiplayer.new()
#private Node _entityArray;
#var _entityArray : Node


#[Export] private int _lerpBufferWindow = 50;
#[Export] private int _maxLerp = 150;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_Connect()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _Connect() -> void:
	#_multiplayer.ConnectedToServer += OnConnectedToServer;
	_multiplayer.connected_to_server.connect(OnConnectedToServer)
	#_multiplayer.PeerPacket += OnPacketReceived;

	#_multiplayer.ServerDisconnected += OnServerDisconnected;
	_multiplayer.server_disconnected.connect(OnServerDisconnect)

	#ENetMultiplayerPeer peer = new();
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	#peer.CreateClient(_address, _port);
	peer.create_client(_adress, _port)
	_multiplayer.multiplayer_peer = peer;

	var path = get_path()
	get_tree().set_multiplayer(_multiplayer, path)

func OnConnectedToServer() -> void:
	print("Client connected to Server:", _adress, ":", _port)
	DisplayServer.window_set_title(str("Connected to: ", _adress, ":", _port, " / as: ", multiplayer.get_unique_id()))
	#GetNode<Label>("Debug/Label").Text += $"\n{Multiplayer.GetUniqueId()}";
	pass


func OnServerDisconnect() -> void:
	_multiplayer = null;
	print("Server disconnected:", _adress, ":", _port)

	#GetNode<Label>("Debug/Label").Modulate = Colors.Red;
	#GetNode<Label>("Debug/Label").Text = $"\nServer has closed the Connection !\nQuitting in 5 Seconds";
	#await ToSignal(GetTree().CreateTimer(5), "timeout");
	#GetTree().Quit();
	pass
