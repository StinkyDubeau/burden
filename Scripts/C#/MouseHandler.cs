using Godot;

// This script handles mutlitple functions all pertaining to Mouse input.
// Jake Dubeau November 18th 2024

public partial class MouseHandler : RayCast3D
{
	[Export]
	public Node3D cursor3D;
	[Export]
	public float Reach = 1000.0f;

	public Vector3 CursorPosition;
	public Camera3D camera3D;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		// Load and verify all dependant nodes.
		camera3D = GetNode<Camera3D>("Camera3D");

		if (camera3D == null)
		{
			GD.PrintErr("The MouseHandler script failed to find the player's camera. Seeking `Camera3D` of type Camera3D.");
		}

		if (cursor3D == null)
		{
			GD.PrintErr("You must assign a Node3D cursor for the MouseHandler.cs script to work!");
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		// Place the cursor at the last updated cursor position
		cursor3D.GlobalPosition = CursorPosition;
	}

	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventMouseMotion eventMouseMotion)
		{
			// Import the world into which will we cast rays
			var spaceState = GetWorld3D().DirectSpaceState;
			// Convert the screen space (Mouse X, Mouse Y) into worldspace position, suitable for casting rays.
			var from = camera3D.ProjectRayOrigin(eventMouseMotion.Position);
			// Multiply the normalized ray by our reach to get the farthest possible collision point.
			var to = from + camera3D.ProjectRayNormal(eventMouseMotion.Position) * Reach;
			// Check for intersections along the full length of the ray
			var query = PhysicsRayQueryParameters3D.Create(from, to);
			// Get the intersection Dictionary, defining metadata about the FIRST collision along the path.
			var intersections = spaceState.IntersectRay(query);
			// Extract the Vector3 position from the intersection definition, and assign it to our cursor position
			CursorPosition = (Vector3)intersections["position"];
		}
	}
}
