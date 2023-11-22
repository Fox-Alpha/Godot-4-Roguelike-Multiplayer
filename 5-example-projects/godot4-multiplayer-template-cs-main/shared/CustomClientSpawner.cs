using Godot;
using System;

public partial class CustomClientSpawner : MultiplayerSpawner
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

		//this.SetMultiplayerAuthority(uid);

		var time = Time.GetDatetimeStringFromSystem(false, true);
		this.SpawnFunction = customSpawnFunctionCallable;
		GD.Print(time, " : ",
			"MultiplayerSpawner::_Ready(): Callable this.SpawnFunction => :",
			$"{this.GetParent().Name} / ",
			$"{this.SpawnFunction.Method} / ",
			$"{this.SpawnFunction.Target} / ",
			$"{this.SpawnFunction.Target.GetType()} / ",
			$"{this.SpawnFunction.Target.GetClass()}",
			$"{this.SpawnFunction.Target.GetScript()} / "
		);
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

		
		GD.Print($"MultiplayerSpawner<CustomPlayerSpawner>::CustomSpawnFunction(): Local UniqueId: ({Multiplayer.GetUniqueId()} / Authority: {GetMultiplayerAuthority()})");

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
