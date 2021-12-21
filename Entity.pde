
/**
* The Entity class servers as the superclass of all entities in the game.
* The {@code public static final int X_CENTRE} constant is used to indicate that an entity should be placed in the centre of the screen.
*
* @author Leyton O'Day
* @version 2.0
*/
abstract public class Entity
{
    /**
    * This method is called every frame, to run arbitrary code implemented by subclasses.
    */
    abstract public void update();
    /**
    * This method is to move the player by applying the velocity vector to the position vector. A default implementation is provided.
    */
    protected void move()
    {
        position.add(velocity);
        velocity.set(0, 0);
    }

    public static final int X_CENTRE = -1;
    protected String path;
    protected float speed;
    protected PVector position;
    protected PVector velocity;
    protected PVector scale;
}