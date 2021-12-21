/**
* The Scalable interface will be implemented in any class that wishes to change it's size by a scalar.
*
* @author Leyton O'Day
* @version 1.0
*/
public interface Scalable
{
    /**
    * This method changes the scale of an Entity using a float. This value will be applied to both width and height.
    * @param scale This is the new scale of the Entity.
    */
    public void setScale(float scale);
    /**
    * This method changes the scale of an Entity using a PVector.
    * @param scale This is the new scale of the Entity.
    */
    public void setScale(PVector scale);
    /**
    * This method gets the scale of an Entity.
    * @return PVector This is the current scale of the Entity.
    */
    public PVector getScale();
    /**
    * This method resets an Entity to it's original scale.
    */
    public void resetScale();
}