using Godot;
using System;
using System.Runtime.CompilerServices;

public partial class Cursor : Area3D
{
	CollisionShape3D Collider;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Collider = GetNode<CollisionShape3D>("CollisionShape3D");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public override void _Input(InputEvent @event)
	{
		base._Input(@event);

		if (@event is InputEventMouseButton eventMouseButton)
		{
			GD.Print("Click.");
		}
	}
}
