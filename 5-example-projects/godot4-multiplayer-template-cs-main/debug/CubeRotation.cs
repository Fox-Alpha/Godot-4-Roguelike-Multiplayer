using Godot;

[GlobalClass]
public partial class CubeRotation : MeshInstance3D
{
    public override void _Process(double delta)
    {
        base._Process(delta);
        if (this.Multiplayer.IsServer())
        {
            this.RotateY((float)delta * 4);
        }
        else
        {
            this.RotateY((float)-delta * 4);
        }
    }
}