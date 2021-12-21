/**
* The Positionable interface will be implemented in any class that wishes to have it's coordinates changed.
*
* @author Leyton O'Day
* @version 1.0
*/
public interface Positionable
{
    /**
    * This method changes the position of an Entity using a PVector.
    * @param position This is the new position of the Entity.
    */
    public void setPosition(PVector position);
    /**
    * This method changes the position of an Entity using two integers.
    * @param x The new coordinate of the Entity on the x-axis.
    * @param y The new coordinate of the Entity on the y-axis.
    */
    public void setPosition(float x, float y);
    /**
    * This method gets the position of an Entity.
    * @return PVector This is the current position of the Entity.
    */
    public PVector getPosition();
}