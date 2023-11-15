using Godot;
using multiplayerbase.server;
using System;

public partial class menu_button : MenuButton
{
    public override void _Ready()
    {
        base._Ready();
        GetPopup().IdPressed += ExitMenuPresses;
    }

    public override void _ExitTree()
    {
        base._ExitTree();
		GetTree().ReloadCurrentScene();
    }

    private void ExitMenuPresses(long id)
	{
		GD.Print($"Menu {GetPopup().GetItemText((int)id)} ({id}) is pressed");

		switch (id)
		{
			case 0:		// Quit to Menu
				// Todo: (WIP) Add Buttons Back
				
				var peer = GetTree().GetMultiplayer().MultiplayerPeer;
				Node parent = null;

				if (GetTree().GetMultiplayer().IsServer())
				{
					parent = this.GetOwnerOrNull<ServerManager>();
				}
				else if (!GetTree().GetMultiplayer().IsServer())
				{
					parent = this.GetOwnerOrNull<ClientManager>();
				}

				GetTree().GetMultiplayer().MultiplayerPeer.Close();
				
				GetTree().SetMultiplayer(MultiplayerApi.CreateDefaultInterface());

				// ToDo: What id parent(owner) is noct null but also noct client- or servermanager ?
				if (parent != null)
				{
					parent.QueueFree();
				}
				break;
			case 1:		// Quit App
				GetTree().Quit();
				break;
			default:	// not valid
				break;
		}
	}
}
