/**
* The DynamicEntity class is used for all entities that are require an animation. This uses an Anim object to represent the Entity.
*
* @author Leyton O'Day
* @version 1.0
*/
abstract public class DynamicEntity extends Entity implements Scalable, Positionable, Sizeable
{
    /**
    * This method is the constructor, and is used to initialize all the instance fields of the DynamicEntity class.
    * @param position Initial position of the Entity.
    * @param path Path to the folder containing the various images of the Entity.
    * @param scale Initial scale of the Entity image.
    * @param velocity Initial velocity of the Entity.
    * @param speed Speed to be applied to the velocity vector when moving the Entity.
    * @param frameDelta The time between each frame, in milliseconds.
    * @param boolean If the animation is looping or not.
    */
    protected DynamicEntity(PVector position, String path, PVector scale, PVector velocity, float speed, int frameDelta, boolean looping)
    {
        this.entityAnim = new Anim(position, path, frameDelta, looping);
        setPosition(entityAnim.position);
        this.path = path;
        this.speed = speed;
        this.scale = scale;
        this.velocity = velocity;
        this.speed = speed;
    }
    /**
    * This method is the second constructor of Entity, with default values of 1 for scale, 0 for velocity, 5 for speed, 100 for frameDelta and true for looping
    */
    protected DynamicEntity(PVector position, String path)
    {
        this(position, path, new PVector(1, 1), new PVector(0, 0), 5, 100, true);
    }
    /**
    * This method is the third constructor of Entity, envoking the second constructor and passing a default value of 0, 0 for the position
    */
    protected DynamicEntity(String path)
    {
        this(new PVector(0, 0), path);
    }
    /**
    * @see Scalable#setScale(float scale)
    */
    @Override
    public void setScale(float scale)
    {
        for (PImage image: entityAnim.images)
            image.resize((int)(scale*image.width), (int)(scale*image.height));
        this.scale.set((int)(scale*this.scale.x), (int)(scale*this.scale.y));
    }
    /**
    * @see Scalable#setScale(PVector scale)
    */
    @Override
    public void setScale(PVector scale)
    {
        for (PImage image: entityAnim.images)
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
        for (PImage image: entityAnim.images)
            image.resize((int)((1/scale.x)*image.width), (int)((1/scale.y)*image.height));
        scale.set(1, 1);
    }
    /**
    * @see Sizeable#setSize(PVector size)
    */
    @Override
    public void setSize(PVector size)
    {
        for (PImage image: entityAnim.images)
            image.resize((int)size.x, (int)size.y);
    }
    /**
    * @see Sizeable#setSize(int x, int y)
    */
    @Override
    public void setSize(int x, int y)
    {
        for (PImage image: entityAnim.images)
            image.resize(x, y);
    }
    /**
    * @see Sizeable#getSize()
    */
    @Override
    public PVector getSize()
    {
        return new PVector(entityAnim.images[0].width, entityAnim.images[0].height);
    }
    /**
    * @see Positionable#setPosition(PVector position)
    */
    @Override
    public void setPosition(PVector position)
    {
        this.position = position;
        if (position.x == Entity.X_CENTRE)
            this.position.set(width/2 - entityAnim.images[0].width/2, position.y);
    }
    /**
    * @see Positionable#setPosition(float x, float y)
    */
    @Override
    public void setPosition(float x, float y)
    {
        position.set(x, y);
        if (position.x == Entity.X_CENTRE)
            position.set(width/2 - entityAnim.images[0].width/2, position.y);
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
    * @see Entity#move()
    */
    @Override
    protected void move()
    {
        position.add(velocity);
        velocity.set(0, 0);
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
    /*
    * @see Entity#update()
    */
    @Override
    abstract public void update();

    // Reference types
    protected Anim entityAnim;
}