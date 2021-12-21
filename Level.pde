/**
* The Level class is used to store the speed, health and damage of the enemies to be spawned in the level.
*
* @author Leyton O'Day
* @version 2.0
*/
class Level
{
    /**
    * This method is the constructor, and is used to initialize all the instance fields of the Level class.
    * @param stat Statistic. This singlular value applies to all stats of the enemies, thus making them harder as the game levels increase.
    */
    public Level(float stat)
    {
        this.enemySpeed = stat;
        this.enemyHealth = stat;
        this.enemyDamage = stat;
    }

    public float enemySpeed;
    public float enemyHealth;
    public float enemyDamage;
}