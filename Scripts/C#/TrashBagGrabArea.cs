using Godot;
using System;

public partial class TrashBagGrabArea : Area3D
{

	private bool hovering;
	private bool holding;

	private Node3D holder;
	[Signal] public delegate void SetTargetEventHandler(Vector3 target);


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		AreaEntered += OnAreaEnteredSignal;
		MouseEntered += OnMouseEnteredSignal;
		MouseExited += OnMouseExitedSignal;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (holding)
		{
			// Send signal to move bag towards holder
			EmitSignal(SignalName.SetTarget, holder.Position);
		}
	}

	private void OnMouseEnteredSignal()
	{
		GD.Print("Mouse entered TrashBagGrabArea");
		hovering = true;
	}

	private void OnMouseExitedSignal()
	{
		GD.Print("Mouse exited TrashBagGrabArea");
		hovering = false;

	}

	private void OnAreaEnteredSignal(Area3D other)
	{
		GD.Print(other);
	}

	public void DropBag()
	{
		GD.Print("Dropped bag");
		holding = false;
	}


	public void GrabBag()
	{
		GD.Print("Grabbed bag");
		holding = true;
		// TODO: Set the holder to the cursor position
		// holder = GetCursorNode
		GD.Print(holder);
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		base._UnhandledInput(@event);
		if (@event is InputEventMouseButton)
		{
			InputEventMouseButton emb = (InputEventMouseButton)@event;

			if (emb.IsPressed())
			{
				if (holding)
					DropBag();
				else if (hovering)
					GrabBag();
			}
		}
	}
}
