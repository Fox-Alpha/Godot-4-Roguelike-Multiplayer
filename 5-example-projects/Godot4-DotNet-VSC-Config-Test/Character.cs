using Godot;
using System;

public partial class Character : Godot.CharacterBody2D
{
	[Export] public const float Speed = 300.0f;
	[Export] public const float JumpVelocity = -400.0f;

	// Get the gravity from the project settings to be synced with RigidBody nodes.
	//public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();

	public override void _Ready()
	{
		GD.Print("READY()");
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Add the gravity.
		//if (!IsOnFloor())
			//velocity.Y += gravity * (float)delta;

		// Handle Jump.
		//if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
			//velocity.Y = JumpVelocity;

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		
		Vector2 direction = Input.GetVector("ui_left", 
			"ui_right", 
			"ui_up", 
			"ui_down");
		if (direction != Vector2.Zero)
		{
			velocity = (direction * Speed);
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			velocity.Y = Mathf.MoveToward(Velocity.Y, 0, Speed);
		}

		Label pos = this.GetNodeOrNull<Label>("../UI/LabelPosition");
		if(pos is not null)
			pos.Text = $"Pos: (X: {GlobalPosition.X:F} / Y: {GlobalPosition.Y:F})";

		Velocity = velocity;
		MoveAndSlide();
	}
}
