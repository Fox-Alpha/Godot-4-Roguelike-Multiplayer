using Godot;
using System;

public partial class CustomSpawner : MultiplayerSpawner
{
	[Export] private PackedScene _playerScene;
	[Export] private PackedScene _serverPlayerScene;
	[Export] private PackedScene _dummyScene;

	[Export] public int startmode { get; set; } = -1;

	private static ClientPlayer localPlayer;

	public static ClientPlayer LocalPlayer { get => localPlayer; set => localPlayer = value; }

	public override void _Ready()
	{
		Callable customSpawnFunctionCallable = new (this, nameof(CustomSpawnFunction));
		this.SpawnFunction = customSpawnFunctionCallable;
		//this.SpawnFunction

		var uid = Multiplayer.GetUniqueId();

		this.SetMultiplayerAuthority(uid);
	}
	
	/* TODO: 
		Maybe seperate Client and Server Spawener func 
		For Host & Play Mode

		So the MultiplayerPeer can assigned for seperate Nodes
		in Server- / ClientManager::Create()
	*/

	public Node CustomSpawnFunction(double data)
	{
		int spawnedPlayerID = (int)data;
		int localID = Multiplayer.GetUniqueId();

		
		GD.Print($"MultiplayerSpawner::CustomSpawnFunction(): Local UniqueId: ({Multiplayer.GetUniqueId()} / Authority: {GetMultiplayerAuthority()})");

		// Server character for simulation
		// Only when ServerMode == dedicated
		if (localID == 1) // && startmode == 2)
		{
			GD.Print("Spawned server character");
			ServerPlayer player = _serverPlayerScene.Instantiate() as ServerPlayer;
			player.Name = spawnedPlayerID.ToString();
			player.MultiplayerID = spawnedPlayerID;
			return player;
		}

		// Client player
		if (localID == spawnedPlayerID)
		{
			GD.Print("Spawned client player");
			ClientPlayer player = _playerScene.Instantiate() as ClientPlayer;
			player.Name = spawnedPlayerID.ToString();
			player.SetMultiplayerAuthority(spawnedPlayerID);
			LocalPlayer = player;
			return player;
		}

		// Dummy player
		{
			GD.Print("Spawned dummy");
			Node player = _dummyScene.Instantiate();
			player.Name = spawnedPlayerID.ToString();
			player.SetMultiplayerAuthority(spawnedPlayerID);
			return player;
		}
	}
}
