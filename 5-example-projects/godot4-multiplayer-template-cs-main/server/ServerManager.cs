using System.Linq;
using Godot;
using MessagePack;

// Code executed on the server side only, handles network events
namespace multiplayerbase.server;

[GlobalClass]
public partial class ServerManager : Node
{
	[Export] private int _port = 9999;

	private SceneMultiplayer _multiplayer = new();
	private Godot.Collections.Array<Godot.Node> entityArray;

	private const int NET_TICKRATE = 30; //hz
	private double _netTickCounter = 0;

	private int HostMode { get; set; }= -1;

	public override void _Ready()
	{
		Create();
	}

	public void SetHostMode(int mode = -1)
	{
		HostMode = mode;
	}

	public override void _Process(double delta)
	{

		_netTickCounter += delta;
		if (_netTickCounter >= (1.0 / NET_TICKRATE))
		{
			DebugInfo();
			NetworkProcess();
			_netTickCounter = 0;
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		entityArray = GetNode("/root/Main/ServerAuthority/EntityArray").GetChildren();
		ProcessPendingPackets();
	}

	private void NetworkProcess() // Called every NET_TICKRATE hz
	{
		BroadcastSnapshot();
	}

	// Process corresponding packets for this tick
	private void ProcessPendingPackets()
	{
		foreach (ServerPlayer player in entityArray.Cast<ServerPlayer>())
		{
			player.ProcessPendingCommands();
		}
	}

	// Pack and send GameSnapshot with all entities and their information
	private void BroadcastSnapshot()
	{
		var peers = this.Multiplayer.GetPeers();

		if (peers.Length == 0)
			return;

		if (entityArray.Count > 0)
		{
			var snapshot = new NetMessage.GameSnapshot
			{
				Time = (int)Time.GetTicksMsec(),
				States = new NetMessage.UserState[entityArray.Count]
			};

			for (int i = 0; i < entityArray.Count; i++)
			{
				var player = entityArray[i] as ServerPlayer; //player
				if (GodotObject.IsInstanceValid(player))
					snapshot.States[i] = player.GetCurrentState();
			}

			byte[] data = MessagePackSerializer.Serialize<NetMessage.ICommand>(snapshot);

			_multiplayer.SendBytes(data, 0,
				MultiplayerPeer.TransferModeEnum.UnreliableOrdered, 0);
		}
	}

	private void OnPacketReceived(long id, byte[] data)
	{
		var command = MessagePackSerializer.Deserialize<NetMessage.ICommand>(data);

		switch (command)
		{
			case NetMessage.UserCommand userCmd:
				//ServerPlayer player = GetNode<ServerPlayer>(%EntityArray + $"/EntityArray/{userCmd.Id}") as ServerPlayer;
				ServerPlayer player = GetNode($"/root/Main/ServerAuthority/EntityArray/{userCmd.Id}") as ServerPlayer;
				player.PushCommand(userCmd);
				break;

			case NetMessage.Sync sync:
				sync.ServerTime = (int)Time.GetTicksMsec();
				_multiplayer.SendBytes(MessagePackSerializer.Serialize<NetMessage.ICommand>(sync), (int)id,
					MultiplayerPeer.TransferModeEnum.Unreliable, 1);
				break;
		}
	}

	private void OnPeerConnected(long id)
	{
		//Node playerInstance =
		CustomSpawner cs = GetNode<CustomSpawner>("/root/Main/MultiplayerSpawner");
		Node newPlayerNode = cs.Spawn(id);
		
		GD.Print("ServerManager::OnPeerConnected(): ", id, $" / LocalId: {Multiplayer.GetUniqueId()} ");
	}

	private void OnPeerDisconnected(long id)
	{
		GetNode($"/root/Main/ServerAuthority/EntityArray/{id}").QueueFree();
		GD.Print("Peer ", id, " disconnected");
	}

	private void Create()
	{
		ENetMultiplayerPeer peer = new();
        Error err;

		GD.Print("Before: CreateServer()");
		var mpspawner = GetTree().CurrentScene.GetNode("MultiplayerSpawner");
		GD.Print($"({mpspawner.Multiplayer.GetUniqueId()} + {mpspawner.GetMultiplayerAuthority()})");

		_multiplayer.PeerConnected += OnPeerConnected;
		_multiplayer.PeerDisconnected += OnPeerDisconnected;
		_multiplayer.PeerPacket += OnPacketReceived;

        if (HostMode == 1)	// Single || Host & Play
        {
            err = peer.CreateServer(_port, maxClients: 1);

			_multiplayer.MultiplayerPeer = peer;

			GetTree().SetMultiplayer(_multiplayer, GetPath());
			this.SetMultiplayerAuthority(Multiplayer.GetUniqueId());
			//GetTree().SetMultiplayer(_multiplayer, "/root/main/ServerAuthority");
			GetTree().SetMultiplayer(_multiplayer, "/root/main/MultiplayerSpawner");


			//var uid = GetNode<CustomSpawner>(GetPath("/root/Main/MultiplayerSpawner")).Multiplayer.GetUniqueId();
			//GetTree().CurrentScene.GetNode("Main/MultiplayerSpawner");
			

			GD.Print($"Lokal Single Server started ");
        }
        else
        {
            err = peer.CreateServer(_port, 4); //maxClients: HostMode);

			_multiplayer.MultiplayerPeer = peer;

			// ToDo: Make a dedicated node for Server peer
			GetTree().SetMultiplayer(_multiplayer);

			GD.Print("Multiplayer Dedicated Server listening on ", _port);
		}
		GD.Print("After: CreateServer()");
		//mpspawner = GetTree().CurrentScene.GetNode("Main/MultiplayerSpawner");
		GD.Print($"({mpspawner.Multiplayer.GetUniqueId()} + {mpspawner.GetMultiplayerAuthority()})");
		GD.Print($"ServerManager::Create(): LocalId: {Multiplayer.GetUniqueId()}  / NodeAuth: {GetMultiplayerAuthority()}");

        if (err != Error.Ok)
		{
			GD.PrintErr("Error: Fehler beim erstellen des Servers => ",err);
			_multiplayer.MultiplayerPeer = null;
			return;
		}
		
		//GetTree().SetMultiplayer(_multiplayer, "/root/main/ServerAuthority");
		//GD.Print("ServerManager::create() -> NodePath: " + GetPath());
		//GetTree().SetMultiplayer(_multiplayer, GetPath());
		//GetTree().SetMultiplayer(_multiplayer, "/root/main/ServerAuthority");
	}

	public Error GetNetworkStatus()
	{
		var mp_peer = GetTree().GetMultiplayer().MultiplayerPeer;

		return mp_peer != null ? Error.Ok : Error.ConnectionError;
	}

	private void DebugInfo()
	{
		var label = GetNode<Label>("Debug/Label2");
		label.Text = $"clk {Time.GetTicksMsec()}";
	}
}
