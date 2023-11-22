using System;
using Godot;
using Godot.Collections;
using multiplayerbase.server;

[GlobalClass]
public partial class MenuController : Node
{
	[Export] private PackedScene _server_scene;
	[Export] private PackedScene _client_scene;

	private Control startbuttons;
	private Node NetworkNode;

	#region Engine Overrides
	public override void _Ready()
	{
		GetTree().SetMultiplayer(MultiplayerApi.CreateDefaultInterface());

		_server_scene = GD.Load<PackedScene>("res://scenes/Server.tscn");
		_client_scene = GD.Load<PackedScene>("res://scenes/Client.tscn");

		GetNodeOrNull<Button>("%ButtonQuitApp").Pressed += OnQuitButtonPressed;

		startbuttons = GetNodeOrNull<Control>("%Buttons");
	}

	private void OnQuitButtonPressed()
	{
		GetTree().Quit();
	}

	public override void _EnterTree()
	{
		base._EnterTree();
	}

	public override void _ExitTree()
	{
		base._ExitTree();
	}

	public override void _Process(double delta)
	{
		base._Process(delta);
	}

	public override void _PhysicsProcess(double delta)
	{
		base._PhysicsProcess(delta);
	}

	public override void _Input(InputEvent @event)
	{
		base._Input(@event);
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		base._UnhandledInput(@event);
	}

	public override void _UnhandledKeyInput(InputEvent @event)
	{
		base._UnhandledKeyInput(@event);
	}

	#endregion

	private async void _on_button_pressed(int host = 2)
	{
		string title = "";

		if (host == 1)	// Host & Play == Single)
		{
			// 1. Start local Play Server
			NetworkNode = _server_scene.Instantiate();
			if (NetworkNode.HasMethod("SetHostMode"))
			{
				NetworkNode.Call("SetHostMode", host);
			}

			//this.AddChild(NetworkNode);
			var SvrAuth = GetTree().CurrentScene.GetNode<Node>("ServerAuthority");
			SvrAuth.AddChild(NetworkNode);
			var spawner = SvrAuth.GetNodeOrNull<CustomSpawner>("ServerMultiplayerSpawner");
			if (spawner != null)
			{
				spawner.startmode = host;
			}
			await ToSignal(GetTree().CreateTimer(0.5), "timeout");

			// 2. Start local Client
			NetworkNode = _client_scene.Instantiate();

			//this.AddChild(NetworkNode);
			GetTree().CurrentScene.GetNode<Node>("ClientAuthority").AddChild(NetworkNode);

			title = "Host & Play Server";
		}
		else if (host == 2)	//Dedicated
		{
			//Node svr_scn_inst = _server_scene.Instantiate();
			NetworkNode = _server_scene.Instantiate();
			if (NetworkNode.HasMethod("SetHostMode"))
			{
				NetworkNode.Call("SetHostMode", host);
			}
			//this.AddChild(NetworkNode);
			//GetTree().CurrentScene.GetNode<Node>("ServerAuthority").AddChild(NetworkNode);
			var SvrAuth = GetTree().CurrentScene.GetNode<Node>("ServerAuthority");
			SvrAuth.AddChild(NetworkNode);
			var spawner = SvrAuth.GetNodeOrNull<CustomSpawner>("ServerMultiplayerSpawner");
			if (spawner != null)
			{
				spawner.startmode = host;
			}
			await ToSignal(GetTree().CreateTimer(0.5), "timeout");

			title = "Dedicated Server";
		}
		else	// Client
		{
			GetNode<Label>("Control/Label").Text = "Client only Side";
			NetworkNode = _client_scene.Instantiate();

			var ClntAuth = GetTree().CurrentScene.GetNode<Node>("ClientAuthority");
			ClntAuth.AddChild(NetworkNode);

			title = "Client";
		}

		if (NetworkNode.HasMethod("GetNetworkStatus"))
		{
			GD.Print("Checking Network creation ...");
			double nwstate = (long)NetworkNode.Call("GetNetworkStatus");

			if (nwstate != (long)Error.Ok)
			{
				GetNode<Label>("Control/Label").Text = "Fehler beim erstellen!";
				return;
			}
			GD.Print("Network has created ...");
		}

		DisplayServer.WindowSetTitle(title);

		startbuttons.QueueFree();
	}
}
