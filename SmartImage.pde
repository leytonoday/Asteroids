/**
* The SmartImage class is used for all images that need advanced functionality.
*
* @author Leyton O'Day
* @version 2.0
*/
class SmartImage implements Scalable, Sizeable, Positionable
{
    /**
    * This method is the constructor, and is used to initialize all the instance fields of the SmartImage class.
    * @param position Initial position of the SmartImage.
    * @param path Path to the image of the SmartImage.
    * @param scale Initial scale of the SmartImage image.
    */
    public SmartImage(PVector position, String path, PVector scale)
    {
        this.image = loadImage(path);
        this.path = path;
        setPosition(position);
        this.scale = scale;
        setScale(this.scale);
    }
    /**
    * This method is the second constructor of Entity, with default values of 1 for scale, 0 for velocity and 5 for speed.
    */
    protected SmartImage(PVector position, String path)
    {
        this(position, path, new PVector(1, 1));
    }
    /**
    * This method is the third constructor of Entity, envoking the second constructor and passing a default value of 0, 0 for the position
    */
    protected SmartImage(String path)
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
    * This method is used to keep a given value between a max and a min.
    * @param value The value to be clamped.
    * @param value The minimum value of the return.
    * @param value The maximum value of the return.
    * @return float The clamped value.
    */
    private float clamp(float value, float min, float max)
    {
        return Math.max(min, Math.min(max, value));
    }
    /**
    * This method is used to set the alpha value for the image.
    * @param alpha The value to set as the alpha.
    */
    public void setAlpha(float alpha)
    {
        this.alpha = clamp(alpha, 0, 255);
    }
    /**
    * This method is used to get the value of the image alpha.
    * @return float The alpha of the image.
    */
    public float getAlpha()
    {
        return alpha;
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
    * This method is used to set if the enemy rotates, and the direction and speed at which they rotate.
    * @param rotate If the enemy will rotate.
    * @param rotationValue The direction and how fast the enemy will rotate.
    */
    public void setRotating(boolean rotate, float rotationValue)
    {
        this.rotate = rotate;
        this.rotationValue = rotationValue;
    }
    /**
    * This method returns if the enemy is set to rotate.
    * @return boolean If the enemy is rotating.
    */
    public boolean getRotating()
    {
        return rotate;
    }
    /*
    * This method is called every frame, to display and rotate the image.
    */
    public void update()
    {
        //maybe change this and just get rid of the else. debugging
        if (getAlpha() < 255)
        {
            tint(255, getAlpha());
            if (rotate)
            {
                //translate to the centre of the image, rotate, translate back, draw image, translate to the centre of image again, rotate in the opposite direction (so everything else isn't rotated), then translate back
                translate(getPosition().x + getSize().x/2, getPosition().y + getSize().y/2);
                rotate(imageRotation*TWO_PI/360);
                translate(-(getPosition().x + getSize().x/2), -(getPosition().y + getSize().y/2));
                image(image, position.x, position.y);
                translate(getPosition().x + getSize().x/2, getPosition().y + getSize().y/2);
                rotate(imageRotation*TWO_PI/360);
                translate(-(getPosition().x + getSize().x/2), -(getPosition().y + getSize().y/2));
                imageRotation += rotationValue;
            }
            else
                image(image, position.x, position.y);
            tint(255, 255);
        }
        else
        {
            if (rotate)
            {
                //translate to the centre of the image, rotate, translate back, draw image, translate to the centre of image again, rotate in the opposite direction (so everything else isn't rotated), then translate back
                translate(getPosition().x + getSize().x/2, getPosition().y + getSize().y/2);
                rotate(imageRotation*TWO_PI/360);
                translate(-(getPosition().x + getSize().x/2), -(getPosition().y + getSize().y/2));
                image(image, position.x, position.y);
                translate(getPosition().x + getSize().x/2, getPosition().y + getSize().y/2);
                rotate(-imageRotation*TWO_PI/360);
                translate(-(getPosition().x + getSize().x/2), -(getPosition().y + getSize().y/2));
                imageRotation += rotationValue;
            }
            else
                image(image, position.x, position.y);
        }
    }

    // Reference types
    protected String path;
    protected PVector position;
    protected PVector scale;
    protected PImage image;

    // Primitive types
    public static final int X_CENTRE = 1;
    private float alpha = 255;
    private float imageRotation = 0;
    private float rotationValue;
    private boolean rotate = false;
}