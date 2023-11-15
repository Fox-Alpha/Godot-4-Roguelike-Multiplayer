using Godot;
using System;
using MessagePack;
using System.Text.RegularExpressions;

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

	// Debug only
	private double _sentPerSecond = 0, _recPerSecond = 0, _packetsPerSecond = 0, _sentPacketsPerSecond = 0;

	public override void _Ready()
	{
		Connect();

		_entityArray = GetNode("/root/Main/ServerAuthority/EntityArray");

		// ToDo: Check if connected
		_netClock = GetNode<NetworkClock>("NetworkClock");
		_netClock.Initialize(_multiplayer);
		_netClock.LatencyCalculated += OnLatencyCalculated;
	}

	public override void _Process(double delta)
	{
		var ConStatus = _multiplayer.MultiplayerPeer.GetConnectionStatus();
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
					CustomSpawner.LocalPlayer.ReceiveState(state);
				}
			}
		}
	}

	private void OnLatencyCalculated(int latencyAverage, int offsetAverage, int jitter)
	{
		_snapshotInterpolator.BufferTime = Mathf.Clamp(latencyAverage + _lerpBufferWindow, 0, _maxLerp);
	}

	private void OnConnectedToServer()
	{
		GetNode<Label>("Debug/Label").Text += $"\n{Multiplayer.GetUniqueId()}";
	}

	private void Connect()
	{
		_multiplayer.ConnectedToServer += OnConnectedToServer;
		_multiplayer.PeerPacket += OnPacketReceived;
		_multiplayer.ServerDisconnected += OnServerDisconnected;
		_multiplayer.ConnectionFailed += OnConnectionFailed;

		GD.Print("Try to connect to: ", _address, ":", _port);
		ENetMultiplayerPeer peer = new();
		peer.CreateClient(_address, _port);

		// ToDo: timeoutMaximum : Time to fire ConnectionFailed Signal
		//peer.setpeertimerout

		_multiplayer.MultiplayerPeer = peer;
		//_multiplayer.MultiplayerPeer;

		GetTree().SetMultiplayer(_multiplayer);
		// ToDo: Make a dedicated node for Client peer
		//GD.Print("ClientManager::connect() -> NodePath: " + GetPath());
		//GetTree().SetMultiplayer(_multiplayer, GetPath());
		//GetTree().SetMultiplayer(_multiplayer, "/root/main/ServerAuthority");


	}

	private void OnConnectionFailed()
	{
		GD.Print("Connecting to: ", _address, ":", _port, " has failed");
		GetNode<Timer>("Timer").Stop();
	}

	private async void OnServerDisconnected()
	{
		// ToDo: Quit and Stop all running processes
		_multiplayer = null;
		GetNode<Label>("Debug/Label").Modulate = Colors.Red;
		GetNode<Label>("Debug/Label").Text = $"\nServer has closed the Connection !\nQuitting in 5 Seconds";
		await ToSignal(GetTree().CreateTimer(5), "timeout");
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
		var ConStatus = _multiplayer.MultiplayerPeer.GetConnectionStatus();

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
		if (ConStatus != MultiplayerPeer.ConnectionStatus.Connected)
			return;

		var enetHost = (Multiplayer.MultiplayerPeer as ENetMultiplayerPeer).Host;
		_sentPerSecond = enetHost.PopStatistic(ENetConnection.HostStatistic.SentData);
		_recPerSecond = enetHost.PopStatistic(ENetConnection.HostStatistic.ReceivedData);
		_packetsPerSecond = enetHost.PopStatistic(ENetConnection.HostStatistic.ReceivedPackets);
		_sentPacketsPerSecond = enetHost.PopStatistic(ENetConnection.HostStatistic.SentPackets);
	}
}
