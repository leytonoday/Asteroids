import java.util.Arrays;

/**
* The Player class is used for the main player
*
* @author Leyton O'Day
* @version 2.0
*/
class Player extends DynamicEntity
{
    /**
    * This method is the constructor, and is used to initialize all the instance fields of the AnimatedEntity class.
    * @param position Initial position of the Player.
    * @param path Path to the folder containing the various images of the Player.
    * @param speed Speed to be applied to the velocity vector when moving the Player.
    * @param health This is used as the health of the player during the game.
    * @param fuel This is used as the fuel of the player.
    */
    public Player(PVector position, String path, int speed, int health, int fuel)
    {
        super(position, path);
        this.speed = speed;
        this.health = health;
        this.fuel = fuel;
        this.powerUpTimer = new CountDownTimer(10000);
        this.powerUpTimer.start(); // must be started. Maybe change implementation later
        this.laserCooldownTimer = new StopWatchTimer();
        this.laserSound = audioManager.load("audio/laserSound.wav", false, 0.2);
        setScale(0.6);
    }
    /**
    * This method is the second constructor of Player, with default value of 100 for health, and 100 for fuel
    */
    public Player(PVector position, String path, int speed)
    {
        this(position, path, speed, 100, 100);
    }
    /**
    * This method is used to check if the timer for the speed up powerup has run out. 
    */
    void checkPowerUpTimer()
    {
        if (powerUpTimer.getTime() <= 0)
        {
            powerUpEnabled = false;
            speed = 8;
        }
    }
    void pausePowerUpTimer() 
    {
        powerUpTimer.pause();
    }
    void unpausePowerUpTimer()
    {
        powerUpTimer.unpause();
    }
    /**
    * This method is used to enable the power up and reset the timer for the power up. This is only used for the "God Mode" powerup
    */
    void enablePowerUp()
    {
        powerUpTimer.reset();
        powerUpEnabled = true;
    }
    /**
    * This method is called every frame to move the player, and shoot lasers.
    */
    @Override
    public void update()
    {
        entityAnim.update();
        move();
        if (powerUpEnabled)
        {
            checkPowerUpTimer();
            speed = 10;
        }

        if (keyArray[0] && laserCooldownTimer.getTime() >= 100 && fuel >=  4)
        {
            laserCooldownTimer.reset();
            if (!powerUpEnabled)
                fuel -= 4;
            Laser laser = new Laser("laser.png", 4, speed * 1.5);
            laser.setPosition(new PVector(getPosition().x + getSize().x/2 - laser.getSize().x/2, getPosition().y ));
            lasers.add(laser);
            audioManager.play(laserSound);
        }
        if (keyArray[1] || getPosition().y + getSize().y > height) //up
            velocity.add(new PVector(0.0, -speed));
        if (keyArray[2] || getPosition().y < 0) //down
            velocity.add(new PVector(0.0, speed));
        if (keyArray[3] || getPosition().x + getSize().x > width) //left
            velocity.add(new PVector(-speed, 0.0));
        if (keyArray[4] || getPosition().x < 0) //right
            velocity.add(new PVector(speed, 0.0));

        for(int i = lasers.size()-1; i > 0; i--)
        {
            lasers.get(i).update();
            if (lasers.get(i).getPosition().y < -20)
                lasers.remove(lasers.get(i));
        }
    }

    // Reference Types
    private CountDownTimer powerUpTimer;
    private StopWatchTimer laserCooldownTimer;
    public ArrayList<Laser> lasers = new ArrayList<Laser>();

    // Primitive Types
    public boolean moving = false;
    public boolean[] keyArray = {false, false, false, false, false}; //space, up, down, left, right
    public boolean powerUpEnabled;
    private int laserSound;
    public int fuel;
    public int health;
}