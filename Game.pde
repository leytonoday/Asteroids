import java.util.*;
import java.util.concurrent.ThreadLocalRandom;
import java.io.*;

/**
* The Game class is used to run the game, and only one instance is ever made.
*
* @author Leyton O'Day
* @version 2.0
*/
class Game
{
    public Game()
    {
        gameStateSwitchCounter  = new GameStateSwitchCounter();
        collectableItems        = new ArrayList<Item>();
        enemies                 = new ArrayList<Enemy>();
        utils                   = new Utils();

        initializePlayer();
        initializeGameTimers();
        initializeGameImages();
        initializeGameMenus();

        loadGameAudio();
        loadHighScore();
        loadLevels(3, 0.5, 6);

        setGameState(GameState.START); // Start the game
    }
    // ********** Constructor Methods **********
    private void initializePlayer()
    {
        player = new Player(new PVector(Entity.X_CENTRE, 400), "animationImages/playerAnim/", 10, 10, 100);
        player.entityAnim.play();
    }
    private void initializeGameTimers() 
    {
        levelTimer = new CountDownTimer(LEVEL_DURATION);
        enemySpawnTimer = new CountDownTimer(ENEMY_SPAWN_DELTA);
        stateSwitchTimer = new StopWatchTimer();
    }
    private void initializeGameMenus() 
    {
        startMenu   = new Menu(new Button(new PVector(Entity.X_CENTRE, 200), "buttonImages/startButtonImages/", GameState.PLAYING, false), new Anim(new PVector(Entity.X_CENTRE, 50), "animationImages/titleAnim/"));
        pauseMenu   = new Menu(new SmartImage[]{new SmartImage(new PVector(Entity.X_CENTRE, 120), "menuImages/pausedBlock.png")}, new Anim(new PVector(Entity.X_CENTRE, 50), "animationImages/pausedAnim/"));
        loseMenu    = new Menu(new Anim(new PVector(Entity.X_CENTRE, 50), "animationImages/youloseAnim/"));
        winMenu     = new Menu(new Anim(new PVector(Entity.X_CENTRE, 50), "animationImages/youwinAnim/"));
        
        // Disable these immediately. They are re-enabled when the splashscreen is done
        startMenu.otherButton.setEnabled(false);
        startMenu.quitButton.setEnabled(false);

        pauseMenu.quitButton.setPosition(new PVector(Entity.X_CENTRE, 325)); // We lower this here because of the box on the pause screen
    }
    private void initializeGameImages()
    {
        playingBackground   = new SmartImage("playingImages/playingBackground.png");
        splashScreen        = new SmartImage("menuImages/splashScreen.png");
        bigEarth            = new SmartImage(new PVector(Entity.X_CENTRE, height), "playingImages/bigEarth.png");
        
        playingBackground.setPosition(0, -playingBackground.getSize().y+height); // Set background to show the bottom to allow scrolling
        bigEarth.setRotating(true, 0.1); // set the earth to rotate clockwise

        try
        {
            playerHealthBarImages   = utils.loadFolderToPImage("healthBars/playerHealthBar");
            earthHealthBarImages    = utils.loadFolderToPImage("healthBars/earthHealthBar");
            laserFuelBarImages      = utils.loadFolderToPImage("healthBars/laserFuelBar");
            levelImages             = utils.loadFolderToPImage("levelImages/");
            enemyImagePaths         = utils.loadImagePaths("asteroidImages/");
            emptyBarImage           = loadImage("healthBars/zeroBar.png");
        }
        catch (NullPointerException e)
        {
            println(e.getMessage());
            e.printStackTrace();
            System.exit(-1);
        }
    }
    private void loadGameAudio()
    {
        explosionSound  = audioManager.load("audio/explosionSound.wav", false, 0.5f);
        playingMusic    = audioManager.load("audio/playingMusic.wav", true, 0f);
        introSound      = audioManager.load("audio/breathingSound.wav");
        menuMusic       = audioManager.load("audio/menuMusic.wav", true, 0f);
    }
    private void loadHighScore()
    {
        highScore = Integer.parseInt(loadStrings("highScore.txt")[0]); 
    }
    private void setHighScore() 
    {
        saveStrings("data/highScore.txt", new String[]{String.valueOf(score)});
    }
    private void loadLevels(float baseStat, float statIncrement, int count)
    {
        levels = new Level[count];
        for(int i = 0; i < count; i++) 
            levels[i] = new Level(baseStat + (i * statIncrement));
    }
    /**
    * This method is used to change game states, and handle the fading of audio.
    * @param gameState The gameState to switch to
    */
    public void setGameState(GameState gameState)
    {
        this.gameState = gameState;
        gameStateSwitchCounter.counter++;

        stateSwitchTimer.reset();
        utils.setCursorVisibility(gameState);

        setAudioByGameState(gameState);

        switch(gameState)
        {
            case PLAYING:
            {
                if(!gameStarted)
                {
                    gameStarted = true;
                    audioManager.play(playingMusic);
                    levelTimer.start();
                    enemySpawnTimer.start();
                }
                else
                    unpauseAllGameTimers();
                break;
            }
            case PAUSED: 
            {
                pauseAllGameTimers();
                break;
            }
        }
    }
    /**
    * This method will fade and start the audio between the menus and actually playing when the game state is switched
    * @param gameState The gameState to switch to
    */
    public void setAudioByGameState(GameState gameState) 
    {
        switch(gameState)
        {
            case START:
            {
                audioManager.play(introSound);
                break;
            }
            case PLAYING:
            {
                setMusicFade(menuMusic, playingMusic);
                break;
            }
            case QUIT:
            {
                audioManager.stopAll();
                break;
            }
            default: // This will run for the following GameState values: PAUSED, WIN and LOSE
            {
                setMusicFade(playingMusic, menuMusic);
                break;
            }
        }
    }
    private void setMusicFade(int fromAudioID, int toAudioID) 
    {
        audioManager.setFade(fromAudioID, AudioManagerFadeDirection.DOWN, gameStateSwitchCounter);
        audioManager.setFade(toAudioID, AudioManagerFadeDirection.UP, gameStateSwitchCounter);
    }


    // ********** Start Menu Methods **********
    private void startMenu() 
    {
        startMenu.update();
        
        if (waitingForSplashScreeen())
            splashScreen.update();
        else
        {
            fadeOutSplashScreen();
            
            // if we aren't already playing the menuMusic, play it. This function is ran every frame, and this if statement will
            // prevent this block of code from running more than once, because of course we only wanna play the music and enable buttons once.
            if (audioManager.getState(menuMusic) != AudioState.PLAYING) 
            {
                audioManager.play(menuMusic);
                setMusicFade(introSound, menuMusic);
                startMenu.otherButton.setEnabled(true);
                startMenu.quitButton.setEnabled(true);
            }
        }

        startMenu.title.update();
    }
    private void fadeOutSplashScreen()
    {
        if (splashScreen.getAlpha() > 0)
        {
            splashScreen.setAlpha(splashScreen.getAlpha() - (256/frameRate));
            splashScreen.update();
        }
    }
    private boolean waitingForSplashScreeen() 
    {
        return stateSwitchTimer.getTime() < SPLASH_SCREEN_DURATION && key != ' '; // Key is global. If space is pressed, skip intro
    }


    // ********** Playing Methods **********
    private void playingGameLoop()
    {
        animateBackground();
        animateEarth();

        player.update();
        if (player.health <= 0 || earthHealth <= 0) // If player dead or earth dead, you lose
        {
            setGameState(GameState.LOSE);
            return;
        }

        updateEnemies();
        updateCollectables();
        spawnEnemiesAndCollectables();
        
        if (levelTimer.getTime() <= 0) //This is the main game timer. Once the 60 seconds are over, reset the timer, increment the level, and check if game is over
        {
            levelTimer.reset();
            currentLevel++;
            if (currentLevel == levels.length)
            {
                setGameState(GameState.WIN);
                return;
            }
        }

        displayUI();
    }
    private void animateBackground() 
    {
        float currentY = playingBackground.getPosition().y;
        playingBackground.setPosition(0, currentY+1);
        if (currentY >= 0) // If the background starts going off the screen, put it back onto the screen
            playingBackground.setPosition(0, -playingBackground.getSize().y+height);
        playingBackground.update();
    }
    private void animateEarth() 
    {
        if (bigEarth.getPosition().y > 450)
            bigEarth.setPosition(bigEarth.getPosition().x, bigEarth.getPosition().y-1);
        bigEarth.update();
    }
    private void updateEnemies() 
    {
        for (int i = enemies.size()-1; i > 0; i--)
        {
            /* Throughout this loop, I say "remove enemy". In reality, the explosion animation begins to play. 
            Once this animation is over, *then* then enemy is removed */
            Enemy currentEnemy = enemies.get(i);
            currentEnemy.update();

            if (currentEnemy.isOffScreen()) 
            {
                enemies.remove(currentEnemy);
                earthHealth -= currentEnemy.damage;
            }

            handleLaserCollidedWithEnemy(currentEnemy);
            handleEnemyHasCollidedWithPlayer(currentEnemy);

            if (currentEnemy.explosionAnim.getState() == AnimState.FINISHED)
                enemies.remove(currentEnemy);
        }
    }
    private void handleLaserCollidedWithEnemy(Enemy enemy) 
    {
        for (int j = player.lasers.size()-1; j > 0; j--) // For each enemy, check if each laser has collided with it.
        {
            Laser currentLaser = player.lasers.get(j);

            if (currentLaser.isOffScreen()) 
            {
                player.lasers.remove(currentLaser);
                continue;
            }

            if (enemy.hasCollided(currentLaser)) //If laser has colluded with enemy, damage enemy and remove laser
            {
                enemy.health -= currentLaser.damage;
                if (enemy.health <= 0)
                    if (enemy.explosionAnim.getState() == AnimState.STOPPED)
                    {
                        enemy.explosionAnim.play();
                        audioManager.play(explosionSound);
                        score++;
                    }

                if (enemy.explosionAnim.getState() != AnimState.PLAYING) //This is so lasers can pass through an enemy whilst explostion animation is occuring
                    player.lasers.remove(currentLaser);
            }
        }
    }
    private void handleEnemyHasCollidedWithPlayer(Enemy enemy) 
    {
        if (player.hasCollided(enemy)) // If enemy has collided with player, damange player and remove enemy.
        {
            if (enemy.explosionAnim.getState() == AnimState.STOPPED)
            {
                enemy.explosionAnim.play();
                if (!player.powerUpEnabled)
                    player.health -= enemy.damage;
                audioManager.play(explosionSound);
            }
        }
    }
    private void updateCollectables() 
    {
        for (int i = collectableItems.size()-1; i > 0; i--)
        {
            Item currentItem = collectableItems.get(i);

            collectableItems.get(i).update();

            if (currentItem.hasCollided(player))
            {
                if (currentItem instanceof FuelItem)
                {
                    player.fuel = 100;
                    collectableItems.remove(currentItem);
                    //Do upgrade sound
                }
                else if (currentItem instanceof GodModeItem)
                {
                    player.enablePowerUp();
                    collectableItems.remove(currentItem);
                    // Do upgrade sound
                }
                else if (currentItem instanceof HealItem)
                {
                    player.health += (player.health < 5? 5: 10 - player.health);
                    earthHealth += (earthHealth < 5? 5: 10 - earthHealth);
                    collectableItems.remove(currentItem);
                    //Do upgrade sound
                }
            }
        }
    }
    private void spawnEnemiesAndCollectables() 
    {
        if (enemySpawnTimer.getTime() <= 100*currentLevel) // If the timer is over, spawn a new enemy. As you can see, an enemy will spawn faster as the levels get higher
        {
            Enemy enemy = new Enemy("asteroidImages/"+enemyImagePaths[(int)random(0, enemyImagePaths.length)], levels[currentLevel]);
            enemy.setRotating(true, random(-2, 2));
            enemies.add(enemy);
            enemySpawnTimer.reset();

            if (player.fuel < 100) // Every time an enemy spawns, refuel just a little
                player.fuel += (player.fuel < 80? 20: 100 - player.fuel);

            int randomNum = ThreadLocalRandom.current().nextInt(0, 4 + 1);
            if (randomNum == 1) //25% chance
            {
                randomNum = ThreadLocalRandom.current().nextInt(0, 2 + 1);
                switch(randomNum)
                {
                case 0:
                {
                    collectableItems.add(new FuelItem(new PVector(random(0, width), 0), "items/fuel.png"));
                    break;
                }
                case 1:
                {
                    collectableItems.add(new GodModeItem(new PVector(random(0, width), 0), "items/godmode.png"));
                    break;
                }
                case 2:
                {
                    collectableItems.add(new HealItem(new PVector(random(0, width), 0), "items/heal.png"));
                    break;
                }
                default:
                    break;
                }
            }
        }
    }
    private void displayUI() 
    {
        // Display level image
        image(levelImages[currentLevel], width - levelImages[currentLevel].width - 10, height - levelImages[currentLevel].height - 10);
        
        //Display transparent highscore, and controls instructions in the top right corner
        fill(255, 255, 255, 100);
        text("High Score: " + highScore, width - textWidth("High Score: " + highScore) - 10, 30);
        text("P to Pause", width - textWidth("P to Pause") - 10, 70);
        text("↑ ↓ ← → Space", width - textWidth("↑ ↓ ← → Space") - 10, 110);
        tint(255);

        // Player health bar
        fill(50, 255, 50);
        text("Player Health: ", 10, 30);
        image(playerHealthBarImages[Math.max(player.health-1, 0)], textWidth("Player Health: ") + 10, 10);

        // Earth health bar
        fill(109, 268, 255);
        text("Earth Health: ", 10, 70);
        image(earthHealthBarImages[Math.max(earthHealth-1, 0)], textWidth("Earth Health: ") + 10, 50);

        // Laser fuel bar
        fill(255, 50, 50);
        text("Laser Fuel: ", 10, 110);
        if (player.fuel > 5)
            image(laserFuelBarImages[Math.max(player.fuel/10-1, 0)], textWidth("Laser Fuel: ") + 10, 90);
        else
            image(emptyBarImage, textWidth("Laser Fuel: ") + 10, 90);

        // Timer
        fill(255, 255, 255);
        text("Timer: " + levelTimer.getTime()/1000, 10, 150);

        // Display score
        text("Score: " + score, 10, 190);

        // if the player has the god mode powerup, then show the timer for it
        if (player.powerUpEnabled)
            text("God Mode: " + player.powerUpTimer.getTime()/1000, 10, 230);
    }

    private void pauseAllGameTimers() 
    {
        levelTimer.pause();
        enemySpawnTimer.pause();
        player.pausePowerUpTimer();
    }
    private void unpauseAllGameTimers() 
    {
        levelTimer.unpause();
        enemySpawnTimer.unpause();
        player.unpausePowerUpTimer();
    }


    /*
    * This method is called every frame automatically by Processing. It handles updating the game as the game state changes. 
    */
    public void draw()
    {
        switch(gameState)
        {
            case START:
            {
                startMenu();
                break;
            }
            case PLAYING:
            {   
                playingGameLoop();
                break;
            }
            case PAUSED:
            {
                pauseMenu.update();
                break;
            }
            case WIN:
            {
                winMenu.update();
                break;
            }
            case LOSE:
            {
                loseMenu.update();
                break;
            }
            case QUIT:
            {
                if (score > highScore)
                    setHighScore();
                System.exit(0);
                break;
            }
        }
    }

    private GameState gameState;
    private GameStateSwitchCounter gameStateSwitchCounter;
    public Player player;

    private Menu startMenu;
    private Menu pauseMenu;
    private Menu loseMenu;
    private Menu winMenu;

    private CountDownTimer levelTimer;
    private CountDownTimer enemySpawnTimer;
    private StopWatchTimer stateSwitchTimer;

    private ArrayList<Enemy> enemies;
    private ArrayList<Item> collectableItems;

    private Level levels[]; 

    private SmartImage splashScreen;
    private SmartImage playingBackground;
    private SmartImage bigEarth;

    private Utils utils;

    private String[] enemyImagePaths;
    private PImage[] levelImages;

    /*
    The following three PImage arrays are used to show health and fuel. There are 10 images in each one. There would have been ``, however due to me being unable to
    implement my own "natural" alphanumeric sorting algorithm, and the built in sort algorithms being insufficient I have gotten rid of the 0% image making it 10 images.
    The actual pngs are names 0 - 10, and the built in java sort algorithms were sorting the array as [0, 1, 10, 2, ..., 9], which is obviously a problem. So I got rid of 
    0%, because (in the case of health bars) at 0% you're dead anyway and the game ends. I have an "emptyBar" png used solely for the 0% fuel. This is my only work around 
    I'm not proud of.
    */
    private PImage[] playerHealthBarImages;
    private PImage[] earthHealthBarImages;
    private PImage[] laserFuelBarImages;
    private PImage emptyBarImage;

    private boolean gameStarted = false;
    private int currentLevel = 0;
    private int earthHealth = 10;
    private int score = 0;
    private int highScore;

    //Audio Manager fields
    private int introSound;
    private int menuMusic;
    private int playingMusic;
    private int explosionSound;

    private final int LEVEL_DURATION = 60000;
    private final int ENEMY_SPAWN_DELTA = 2000;
    private final int SPLASH_SCREEN_DURATION = 5000;
}