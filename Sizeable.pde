
/**
* The Sizeable interface will be implemented in any class that wishes to change it's size by a definate amount.
*
* @author Leyton O'Day
* @version 1.0
*/
public interface Sizeable
{
    /**
    * This method changes the size of an Entity using a PVector.
    * @param size This is the new size of the Entity.
    */
    public void setSize(PVector size);
    /**
    * This method changes the size of an Entity using two integers.
    * @param x The new width of the Entity.
    * @param y The new height of the Entity.
    */
    public void setSize(int x, int y);
    /**
    * This method gets the size of an Entity.
    * @return PVector This is the current size of the Entity.
    */
    public PVector getSize();
}