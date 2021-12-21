/**
* The Enemy class is used for all enemies in the game, which are asteroids.
*
* @author Leyton O'Day
* @version 2.0
*/
class Enemy extends StaticEntity
{
    /**
    * This method is the constructor, and is used to initialize the instance fields of the Enemy class.
    * @param path The path of the enemy image.
    * @param level The level in which the enemy will spawn, which dictates the strength of the enemy.
    */
    public Enemy(String path, Level level)
    {
        super(new PVector(random(0, width-50), -30), path, new PVector(random(1, 2), random(1, 2)), new PVector(random(-10, 10), 0), level.enemySpeed);
        this.health = level.enemyHealth;
        this.damage = level.enemyDamage;
        setScale(0.5);
        explosionAnim = new Anim(new PVector(0, 0), "animationImages/explosionAnim/", 50, false);
        explosionAnim.setSize(getSize());
        explosionAnim.setScale(1.5);
    }
    /**
    * @see Entity#move()
    */
    @Override
    void move()
    {
        position.add(velocity);
        velocity.set(velocity.x, 0);
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
    public boolean isOffScreen() 
    {
        return getPosition().y > height;
    }
    /**
    * @see Entity#update()
    */
    @Override
    void update()
    {
        if (explosionAnim.getState() == AnimState.STOPPED)
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
            velocity.y += speed;
            move();
            if (getPosition().x < 0 || getPosition().x + getSize().x > width) //Make the asteroids bounce off the walls
            {
                velocity.x *= -1;
                rotationValue *= -1;
            }
        }
        else
        {
            explosionAnim.setPosition(position);
            explosionAnim.update();
        }
    }

    // Reference types
    Anim explosionAnim;

    // Primitive types
    public float health;
    public float damage;    
    private boolean rotate = false;
    private float imageRotation = 0;
    private float rotationValue;
}