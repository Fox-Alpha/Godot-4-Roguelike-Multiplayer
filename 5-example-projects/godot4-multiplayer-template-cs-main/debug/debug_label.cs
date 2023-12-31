using System.Numerics;
using Godot;
using Godot.Collections;

[GlobalClass]
public partial class debug_label : Label
{
    public override void _Process(double delta)
    {
        base._Process(delta);

        Node ea = GetNodeOrNull<Node>("%EntityArray");
        
        if (ea == null)
            return;


        int gcc = ea.GetChildCount();

        if (gcc > 0)
        {
            this.Text = string.Empty;

            Array<Node> childs = GetNodeOrNull<Node>("%EntityArray")?.GetChildren();

            // Todo: Refactor for 2D
            foreach (var item in childs)
            {
                if(item is Node3D)
                {
                    Node3D n3d = (Node3D)item;
                    this.Text += $"{item.Name}-{n3d.Position.Snapped(Godot.Vector3.One*0.1f)}\n";
                }
            }
        }    
        else
        {
            this.Text = "No peers connected.";
        }
    }
}