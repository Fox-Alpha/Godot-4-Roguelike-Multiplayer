using Godot;
using System;

public partial class CustomSpawner : MultiplayerSpawner
{
	[Export] private PackedScene _playerScene;
	[Export] private PackedScene _serverPlayerScene;
	[Export] private PackedScene _dummyScene;

	[Export] private int startmode = -1;

	private static ClientPlayer localPlayer;

	public static ClientPlayer LocalPlayer { get => localPlayer; set => localPlayer = value; }

	public override void _Ready()
	{
		Callable customSpawnFunctionCallable = new (this, nameof(CustomSpawnFunction));
		this.SpawnFunction = customSpawnFunctionCallable;

		var uid = Multiplayer.GetUniqueId();

		this.SetMultiplayerAuthority(uid);
	}

	private Node CustomSpawnFunction(Variant data)
	{
		int spawnedPlayerID = (int)data;
		int localID = Multiplayer.GetUniqueId();

		// Server character for simulation
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
