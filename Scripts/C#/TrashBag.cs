using Godot;
using System;
using System.Threading;

public partial class TrashBag : RigidBody3D
{
	[Export]
	public int trash = 0;
	[Export]
	public TrashBagGrabArea _grabArea;
	[Export]
	public Node3D cursor;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		BodyEntered += OnBodyEnteredSignal;
		_grabArea.SetTarget += OnSetTargetSignal;

	}

	public override void _ExitTree()
	{
		BodyEntered -= OnBodyEnteredSignal;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	private void OnSetTargetSignal(Vector3 target)
	{
		GD.Print("Trashbag has target " + target);
	}

	private void OnBodyEnteredSignal(Node n)
	{
		GD.Print(Name + " collided with " + n);

		//  Bag handler sudocode
		// if (collided body is trash)
		//  {
		// 	grow the bag
		// }
		// else if (collided body is activeCursor) {
		// 	pick up bag
		// }

	}
}
