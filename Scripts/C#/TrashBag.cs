using Godot;
using System;

public partial class TrashBag : RigidBody3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		BodyEntered += OnBodyEnteredSignal;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	private void OnBodyEnteredSignal(Node n)
	{
		GD.Print(n);

		//  Bag handler sudocode
		// if (collided body is trash)
		//  {
		// 	grow the bag
		// }
		// else if (collided body is cursor) {
		// 	pick up bag
		// }
	}


}
