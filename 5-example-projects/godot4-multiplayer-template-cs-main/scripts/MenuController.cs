using Godot;
using Godot.Collections;

[GlobalClass]
public partial class MenuController : Node
{
	[Export] private PackedScene _server_scene;
	[Export] private PackedScene _client_scene;

	private Control startbuttons;

	public override void _Ready()
	{
		_server_scene = GD.Load<PackedScene>("res://scenes/Server.tscn");
		_client_scene = GD.Load<PackedScene>("res://scenes/Client.tscn");

		startbuttons = GetNodeOrNull<Control>("%Buttons");
	}


	private async void _on_button_pressed(int host = 2)
	{
		string title = "";

		if (host == 1)
		{
			Node svr_scn_inst = _server_scene.Instantiate();
			this.AddChild(svr_scn_inst);
			await ToSignal(GetTree().CreateTimer(0.5), "timeout");

			title = "Dedicated Server";
		}
		else if (host == 2)
		{
			//Node svr_scn_inst = _server_scene.Instantiate();
			this.AddChild(_server_scene.Instantiate());
			await ToSignal(GetTree().CreateTimer(0.5), "timeout");

			title = "Dedicated Server";
		}
		else
		{
			GetNode<Label>("Control/Label").Text = "Client only Side";
			this.AddChild(_client_scene.Instantiate());
			title = "Client";
		}

		DisplayServer.WindowSetTitle(title);
		//$ServerAuthority/MultiplayerSpawner.startmode = host
		startbuttons.QueueFree();
	}
}
