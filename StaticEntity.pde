/**
* The StaticEntity class is used for all entities that are a single image, and are not animated. This uses a PImage object to represent the Entity.
*
* @author Leyton O'Day
* @version 1.0
*/
abstract public class StaticEntity extends Entity implements Scalable, Sizeable, Positionable
{
    /**
    * This method is the constructor, and is used to initialize all the instance fields of the StaticEntity class.
    * @param position Initial position of the Entity.
    * @param path Path to the image of the Entity.
    * @param scale Initial scale of the Entity image.
    * @param velocity Initial velocity of the Entity.
    * @param speed Speed to be applied to the velocity vector when moving the Entity.
    */
    protected StaticEntity(PVector position, String path, PVector scale, PVector velocity, float speed)
    {
        this.image = loadImage(path);
        this.path = path;
        setPosition(position);
        this.velocity = velocity;
        this.speed = speed;
        this.scale = scale;
        setScale(this.scale);
    }
    /**
    * This method is the second constructor of Entity, with default values of 1 for scale, 0 for velocity and 5 for speed.
    */
    protected StaticEntity(PVector position, String path)
    {
        this(position, path, new PVector(1, 1), new PVector(0, 0), 5);
    }
    /**
    * This method is the third constructor of Entity, envoking the second constructor and passing a default value of 0, 0 for the position
    */
    protected StaticEntity(String path)
    {
        this(new PVector(0, 0), path);
    }
    /**
    * @see Scalable#setScale(float scale)
    */
    @Override
    public void setScale(float scale)
    {
        image.resize((int)(scale*image.width), (int)(scale*image.height));
        this.scale.set((int)(scale*this.scale.x), (int)(scale*this.scale.y));
    }
    /**
    * @see Scalable#setScale(PVector scale)
    */
    @Override
    public void setScale(PVector scale)
    {
        image.resize((int)(scale.x*image.width), (int)(scale.y*image.height));
        this.scale.set((int)(scale.x*this.scale.x), (int)(scale.y*this.scale.y));
    }
    /**
    * @see Scalable#getScale()
    */
    @Override
    public PVector getScale()
    {
        return scale;
    }
    /**
    * @see Scalable#resetScale()
    */
    @Override
    public void resetScale()
    {
        image.resize((int)((1/scale.x)*image.width), (int)((1/scale.y)*image.height));
        scale.set(1, 1);
    }
    /**
    * @see Sizeable#setSize(PVector size)
    */
    @Override
    public void setSize(PVector size)
    {
        image.resize((int)size.x, (int)size.y);
    }
    /**
    * @see Sizeable#setSize(int x, int y)
    */
    @Override
    public void setSize(int x, int y)
    {
        image.resize(x, y);
    }
    /**
    * @see Sizeable#getSize()
    */
    @Override
    public PVector getSize()
    {
        return new PVector(image.width, image.height);
    }
    /**
    * @see Positionable#setPosition(PVector position)
    */
    @Override
    public void setPosition(PVector position)
    {
        this.position = position;
        if (position.x == Entity.X_CENTRE)
            this.position.set(width/2 - image.width/2, position.y);
    }
    /**
    * @see Positionable#setPosition(float x, float y)
    */
    @Override
    public void setPosition(float x, float y)
    {
        position.set(x, y);
        if (position.x == Entity.X_CENTRE)
            this.position.set(width/2 - image.width/2, position.y);
    }
    /**
    * @see Positionable#getPosition()
    */
    @Override
    public PVector getPosition()
    {
        return position;
    }
    /**
    * This method is used to check the if the given StaticEntity has collided with this Entity.
    * @param entity This is the potential collided StaticEntity.
    * @return boolean If we did collide or not.
    */
    protected boolean hasCollided(StaticEntity entity)
    {
        // This code is vile, but I wasn't sure how else to do it.
       if (getPosition().x < entity.getPosition().x + entity.getSize().x &&
            getPosition().x + getSize().x > entity.getPosition().x &&
            getPosition().y < entity.getPosition().y + entity.getSize().y &&
            getPosition().y + getSize().y > entity.getPosition().y)
            return true;
        return false;
    }
    /**
    * This method is used to check the if the given DynamicEntity has collided with this Entity.
    * @param entity This is the potential collided DynamicEntity.
    * @return boolean If we did collide or not.
    */
    protected boolean hasCollided(DynamicEntity entity)
    {
        // This code is vile, but I wasn't sure how else to do it.
       if (getPosition().x < entity.getPosition().x + entity.getSize().x &&
            getPosition().x + getSize().x > entity.getPosition().x &&
            getPosition().y < entity.getPosition().y + entity.getSize().y &&
            getPosition().y + getSize().y > entity.getPosition().y)
            return true;
        return false;
    }
    /**
    * @see Entity#update()
    */
    @Override
    abstract public void update();

    protected PImage image;
}