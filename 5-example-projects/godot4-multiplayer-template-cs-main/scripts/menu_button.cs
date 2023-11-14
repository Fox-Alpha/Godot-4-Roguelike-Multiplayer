using Godot;
using System;

public partial class menu_button : MenuButton
{
    public override void _Ready()
    {
        base._Ready();
        GetPopup().IdPressed += ExitMenuPresses;
    }

    private void ExitMenuPresses(long id)
	{
		GD.Print($"Menu {GetPopup().GetItemText((int)id)} ({id}) is pressed");

		switch (id)
		{
			case 0:		// Quit to Menu
				// Todo: Add Buttons Back
                Multiplayer.MultiplayerPeer.Close();
                Multiplayer.MultiplayerPeer = null;
                GetTree().ReloadCurrentScene();
                //var own = GetOwner<Node>();
				//own.QueueFree();
				break;
			case 1:		// Quit App
				GetTree().Quit();
				break;
			default:	// not valid
				break;
		}
	}
}
