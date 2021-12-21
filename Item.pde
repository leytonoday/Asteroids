/**
* The Item class is used for all power up items.
*
* @author Leyton O'Day
* @version 2.0
*/
class Item extends SmartImage
{
    /**
    * This method is the constructor, and is used to initialize all the instance fields of the Item class.
    * @param position Initial position of the Item.
    * @param path The path of the Item image.
    */
    Item(PVector position, String path)
    {
        super(position, path, new PVector(1, 1));
        this.velocity = new PVector(random(-10, 10), 0);
        speed = random(2, 4);
    }
    /**
    * This method is called every frame to move the Item.
    */
    private void move()
    {
        position.add(velocity);
        velocity.set(velocity.x, 0);
    }
    /**
    * This method is called every frame to move and draw the Item.
    */
    public void update()
    {
        super.update();
        velocity.y += speed;
        if (getPosition().x < 0 || getPosition().x + getSize().x > width)
            velocity.x *= -1;
        move();
    }

    PVector velocity;
    float speed;
}

/**
* The FuelItem class is used to identify a FuelItem powerup. This gives the player fuel for lasers.
*
* @author Leyton O'Day
* @version 2.0
*/
class FuelItem extends Item
{
    FuelItem(PVector position, String path)
    {
        super(position, path);
    }
}

/**
* The GodModeItem class is used to identify a GodModeItem powerup. This stops the player taking damage, and they have 0 fuel consumption.
*
* @author Leyton O'Day
* @version 2.0
*/
class GodModeItem extends Item
{
    GodModeItem(PVector position, String path)
    {
        super(position, path);
    }
}

/**
* The HealItem class is used to identify a HealItem powerup. This heals the Earth and the player.
*
* @author Leyton O'Day
* @version 2.0
*/
class HealItem extends Item
{
    HealItem(PVector position, String path)
    {
        super(position, path);
    }
}
