using Godot;
using System;
using MessagePack;
using System.Text.RegularExpressions;
using multiplayerbase.server;

// Code executed on the client side only, handles network events
public partial class ClientManager : Node
{
	[Export] private string _address = "localhost";
	[Export] private int _port = 9999;
	[Export] private int _lerpBufferWindow = 50;
	[Export] private int _maxLerp = 150;

	private SceneMultiplayer _multiplayer = new();
	private SnapshotInterpolator _snapshotInterpolator = new();
	private NetworkClock _netClock;
	private Node _entityArray;

	private MenuButton ExitButton;
	private int ConnectionTimeElapsed = 0;
	private int HostMode { get; set; } = -1;


	// Debug only
	private double _sentPerSecond = 0, _recPerSecond = 0, _packetsPerSecond = 0, _sentPacketsPerSecond = 0;

	public override void _Ready()
	{
		Connect();

		//_entityArray = GetNode("/root/Main/ClientAuthority/EntityArray");
		_entityArray = GetTree().CurrentScene.GetNode("ClientAuthority/EntityArray");

		// ToDo: Check if connected
		_netClock = GetNode<NetworkClock>("NetworkClock");
		_netClock.Initialize(_multiplayer);
		_netClock.LatencyCalculated += OnLatencyCalculated;
	}

	public override void _Process(double delta)
	{
		//var ConStatus = GetTree().GetMultiplayer().MultiplayerPeer.GetConnectionStatus();
		var ConStatus = this.Multiplayer.MultiplayerPeer.GetConnectionStatus();
		if (ConStatus != MultiplayerPeer.ConnectionStatus.Connected || ConStatus == MultiplayerPeer.ConnectionStatus.Disconnected)
			return;

		_snapshotInterpolator.InterpolateStates(_entityArray, NetworkClock.Clock);
		DebugInfo(delta);
	}

	private void OnPacketReceived(long id, byte[] data)
	{
		var command = MessagePackSerializer.Deserialize<NetMessage.ICommand>(data);

		if (command is NetMessage.GameSnapshot snapshot)
		{
			_snapshotInterpolator.PushState(snapshot);

			foreach (NetMessage.UserState state in snapshot.States)
			{
				long mpuid = Multiplayer.GetUniqueId();

				if (state.Id == mpuid)
				{
					// ToDo ????
					CustomSpawner.LocalPlayer.ReceiveState(state);
				}
			}
		}
	}

	private void OnLatencyCalculated(int latencyAverage, int offsetAverage, int jitter)
	{
		_snapshotInterpolator.BufferTime = Mathf.Clamp(latencyAverage + _lerpBufferWindow, 0, _maxLerp);
	}

	private void Connect()
	{
		var time = Time.GetDatetimeStringFromSystem(false, true);
		//get_datetime_string_from_system 
		GD.Print($"{time}Try to connect to: ", _address, ":", _port);
		ENetMultiplayerPeer peer = new();

		GD.Print("Before: CreateClient()");
		//var cs = GetTree().CurrentScene;
		//var mp_clnt_spawner = GetTree().CurrentScene.GetNode("ClientAuthority/ClientMultiplayerSpawner");
		//GD.Print($"ClientManager::Connect(): LocalId({Multiplayer.GetUniqueId()} + ClntSpawnerAuth:{mp_clnt_spawner.GetMultiplayerAuthority()} / NodeAuth: {GetMultiplayerAuthority()})");
		//var mp_svr_spawner = GetTree().CurrentScene.GetNode("ServerAuthority/ServerMultiplayerSpawner");
		//GD.Print($"ClientManager::Connect(): LocalId({Multiplayer.GetUniqueId()} + SvrSpawnerAuth:{mp_svr_spawner.GetMultiplayerAuthority()} / NodeAuth: {GetMultiplayerAuthority()})");

		var err = peer.CreateClient(_address, _port);
		if (err != Error.Ok)
		{
			GD.PrintErr("Error: Fehler beim erstellen des Clients => ",err);
			_multiplayer.MultiplayerPeer = null;
			return;
		}

		_multiplayer.ConnectedToServer += OnConnectedToServer;
		_multiplayer.PeerPacket += OnPacketReceived;
		_multiplayer.ServerDisconnected += OnServerDisconnected;
		_multiplayer.ConnectionFailed += OnConnectionFailed;
		_multiplayer.PeerConnected += OnPeerConnected;
		_multiplayer.PeerDisconnected += OnPeerDisconnected;

		// ToDo: timeoutMaximum : Time to fire ConnectionFailed Signal
		//peer.setpeertimerout

		_multiplayer.MultiplayerPeer = peer;
		//_multiplayer.MultiplayerPeer;

		GD.Print($"ClientManager::Connect(): mp_Id {Multiplayer.GetUniqueId()} / ");

		GetTree().SetMultiplayer(_multiplayer, "/ClientAuthority");

		Callable customSpawnFunctionCallable = new Callable(this,CustomSpawner.MethodName.CustomSpawnFunction);
		var clnt = GetTree().CurrentScene.GetNode<CustomSpawner>("ClientAuthority/ClientMultiplayerSpawner");
		var client = GetTree().CurrentScene.GetNode("ClientAuthority");
		clnt.SpawnFunction = customSpawnFunctionCallable;
		client.SetMultiplayerAuthority(Multiplayer.GetUniqueId());

		GD.Print($"ClientManager::Connect(): mp_Id {Multiplayer.GetUniqueId()} / ");
		//Multiplayer.MultiplayerPeer = _multiplayer		

		//this.SetMultiplayerAuthority(Multiplayer.GetUniqueId());

		//var clnt = GetTree().CurrentScene.GetNode<CustomSpawner>("ClientAuthority/ClientMultiplayerSpawner");
		//clnt.SetMultiplayerAuthority(Multiplayer.GetUniqueId());
		//var svr = GetTree().CurrentScene.GetNodeOrNull<ServerManager>("Server");
		//svr.SetMultiplayerAuthority(1);

		//var ent_array = GetTree().CurrentScene.GetNodeOrNull<Node>("ClientAuthority/EntityArray");
		
		// ToDo: Make a dedicated node for Client peer
		//GD.Print("ClientManager::connect() -> NodePath: " + GetPath());
		//GetTree().SetMultiplayer(_multiplayer, GetPath());
		//GetTree().SetMultiplayer(_multiplayer, "/root/main/ServerAuthority");

		GD.Print("After: CreateClient()");
		//mp_clnt_spawner = GetTree().CurrentScene.GetNode("Main/MultiplayerSpawner");
		//GD.Print($"ClientManager::Connect(): LocalId({Multiplayer.GetUniqueId()} + ClntSpawnerAuth:{mp_clnt_spawner.GetMultiplayerAuthority()} / NodeAuth: {GetMultiplayerAuthority()})");
		//GD.Print($"ClientManager::Connect(): LocalId({Multiplayer.GetUniqueId()} + SvrSpawnerAuth:{mp_svr_spawner.GetMultiplayerAuthority()} / NodeAuth: {GetMultiplayerAuthority()} / ClientEntityArrayAuth: {ent_array.GetMultiplayerAuthority()})");
	}

	private void OnConnectedToServer()
	{
		GD.Print($"ClientManager::OnConnectedToServer(Node:{this.Name}): LocalId: {Multiplayer.GetUniqueId()} / NodeAuth: {GetMultiplayerAuthority()}");
		GetNode<Label>("Debug/Label").Text += $"\n{Multiplayer.GetUniqueId()}";

		//GD.Print("Before Changing Node Authority ?");

		//this.SetMultiplayerAuthority(Multiplayer.GetUniqueId());

		//GD.Print("After Changing Node Authority ?: ", $"{Multiplayer.GetUniqueId()}");
	}


    private void OnPeerDisconnected(long id)
    {
		GD.Print($">> ClientManager::OnPeerDisconnected(): {id} / LocalId: {Multiplayer.GetUniqueId()} ");
    }


    private void OnPeerConnected(long id)
    {
        GD.Print($">> ClientManager::OnPeerConnected(): {id} / LocalId: {Multiplayer.GetUniqueId()} ");
    }

    private void OnConnectionFailed()
	{
		GD.Print($"ClientManager::OnConnectionFailed(): Connecting to: {_address}:{_port} has failed");
		GetNode<Timer>("Timer").Stop();
	}

	private async void OnServerDisconnected()
	{
		// ToDo: Quit and Stop all running processes
		//_multiplayer = null;
		GetTree().GetMultiplayer().MultiplayerPeer.Close();
		GetNode<Label>("Debug/Label").Modulate = Colors.Red;

		GD.Print($">> ClientManager::OnServerDisconnected(): Server has closed the Connection");

		await ToSignal(GetTree().CreateTimer(5), "timeout");

		// Change to Mainmenu, instead of quit
		GetTree().Quit();
	}

	private void DebugInfo(double delta)
	{
		var label = GetNode<Label>("Debug/Label2");
		label.Modulate = Colors.White;

		label.Text = $"buf {_snapshotInterpolator.BufferCount} ";
		label.Text += String.Format("int {0:0.00}", _snapshotInterpolator.InterpolationFactor);
		label.Text += $" len {_snapshotInterpolator.BufferTime}ms \nclk {NetworkClock.Clock} ofst {_netClock.Offset}ms";
		label.Text += $"\nping {_netClock.InmediateLatency}ms r_pps {_packetsPerSecond} t_pps {_sentPacketsPerSecond} jit {_netClock.Jitter}";

		if (CustomSpawner.LocalPlayer != null)
		{
			label.Text += $"\nrdt {CustomSpawner.LocalPlayer.RedundantInputs} tx {_sentPerSecond} rx {_recPerSecond}";
		}

		if (_snapshotInterpolator.InterpolationFactor > 1)
			label.Modulate = Colors.Red;
	}

	private void OnDebugTimerOut()
	{
		return;
		/*
		var ConStatus = GetTree().GetMultiplayer().MultiplayerPeer.GetConnectionStatus();

		if (ConStatus == MultiplayerPeer.ConnectionStatus.Connecting)
		{
			Label debug = GetNodeOrNull<Label>("Debug/Label");

			if(debug != null)
			{
				debug.Text = $"Connecting ... ({ConnectionTimeElapsed})";
			}

			ConnectionTimeElapsed++;
			return;
		}
		if (ConStatus == MultiplayerPeer.ConnectionStatus.Disconnected)
			return;

		var enetHost = (Multiplayer.MultiplayerPeer as ENetMultiplayerPeer).Host;
		_sentPerSecond = enetHost.PopStatistic(ENetConnection.HostStatistic.SentData);
		_recPerSecond = enetHost.PopStatistic(ENetConnection.HostStatistic.ReceivedData);
		_packetsPerSecond = enetHost.PopStatistic(ENetConnection.HostStatistic.ReceivedPackets);
		_sentPacketsPerSecond = enetHost.PopStatistic(ENetConnection.HostStatistic.SentPackets);
		*/
	}
}
