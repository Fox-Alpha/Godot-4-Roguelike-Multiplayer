using Godot;

[GlobalClass]
public partial class CubeRotation : MeshInstance3D
{
	public override void _Process(double delta)
	{
		base._Process(delta);
		if(!Multiplayer.HasMultiplayerPeer())
		{
			this.RotateX((float)delta * 1);
			this.RotateY((float)delta * 1);
			this.RotateZ((float)delta * 1);
			//return;
		}
		if (this.Multiplayer.IsServer())
		{
			this.RotateY((float)delta * 2);
		}
		else
		{
			this.RotateY((float)-delta * 2);
		}
	}
}
