/**
* The Laser class is only used by the Player class to shoot projectiles towards enemies
*
* @author Leyton O'Day
* @version 2.0
*/
class Laser extends StaticEntity
{
    public Laser(PVector position, String path, float damage, float speed)
    {
        super(position, path, new PVector(1, 1), new PVector(0, 0), speed);
        this.damage = damage;
    }
    public Laser(String path, float damage, float speed)
    {
        this(new PVector(0, 0), path, damage, speed);
    }
    public boolean isOffScreen() 
    {
        return getPosition().y < -20;
    }
    @Override
    public void update()
    {
        image(image, position.x, position.y);
        velocity.y -= speed;
        move();
    }

    float damage;
}