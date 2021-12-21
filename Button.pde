/**
* The Button class is used for all buttons in the game. It doesn't implement sizable or scalable, because all button images are already the correct size.
*
* @author Leyton O'Day
* @version 2.0
*/
class Button implements Positionable
{
    /**
    * This method is the constructor, and is used to initialize all the instance fields of the Button class.
    * @param position Initial position of the Entity.
    * @param path Path to the image of the Entity.
    * @param action The GameState to switch to once the button is clicked.
    * @param enabled Boolean flag that enables or disabled the action of the button.
    */
    public Button(PVector position, String path, GameState action, boolean enabled)
    {
        this.action = action;
        this.enabled = enabled;
        this.imageIndex = 0;
        hoverSound = audioManager.load("audio/hoverSound.wav");
        selectSound = audioManager.load("audio/selectSound.wav");
        try
        {
            images = loadFolder(path);
        }
        catch (NullPointerException e)
        {
            println(e.getMessage());
            e.printStackTrace();
            images = new PImage[] {loadImage("imageMissing.png"), loadImage("imageMissing.png"), loadImage("imageMissing.png")};
        }
        setPosition(position);
    }
    /**
    * This method is the second constuctor of Button, with a default true for enabled.
    */
    public Button(PVector position, String path, GameState action)
    {
        this(position, path, action, true);
    }
    /**
    * This method loads all images from a given directory.
    * @param path The path of the directory to be loaded.
    * @exception java.lang.NullPointerException Thrown when directory not found
    * @return PImage[] Returns an array of PImage objects.
    */
    private PImage[] loadFolder(String path) throws NullPointerException
    {
        File folder = new File(dataPath(path));
        String[] files = folder.list();
        if (files == null)
            throw new NullPointerException("Could Not Load Files At: " + dataPath(path));
        
        PImage[] loadedImages = new PImage[files.length];
        for (int i = 0; i < files.length; i++)
            loadedImages[i] = loadImage(dataPath(path) + "\\" + files[i]);
        
        return loadedImages;
    }
    /**
    * @see Positionable#setPosition(PVector position)
    */
    @Override
    public void setPosition(PVector position)
    {
        this.position = position;
        if (position.x == Entity.X_CENTRE)
            this.position.set(width/2 - images[0].width/2, this.position.y);
    }
    /**
    * @see Positionable#setPosition(float x, float y)
    */
    @Override
    public void setPosition(float x, float y)
    {
        position.set(x, y);
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
    * This method is the setter for the private field {@code private boolean enabled}. 
    * @param enabled Boolean used to set the enabled flag.
    */
    public void setEnabled(boolean enabled)
    {
        this.enabled = enabled;
    }
    /**
    * This method is used to get the value of the enabled flag.
    * @return boolean The value of the enabled flag.
    */
    public boolean getEnabled()
    {
        return enabled;
    }
    /**
    * This method is used to detect if the mouse is hovering over the this Button.
    * @return boolean If the mouse is hovering over the Button.
    */
    public boolean isHovering()
    {
        if (mouseX > position.x && mouseX < position.x + images[0].width && mouseY < position.y + images[0].height && mouseY > position.y)
            return true;
        return false;
    }
    /**
    * This method is called every frame, to test isHovering() and change the images of the buttons.
    */
    void update()
    {
        if (isHovering() && enabled)
        {
            if (!hoverSoundPlayed)
            {
                audioManager.play(hoverSound);
                hoverSoundPlayed = true;
            }
            imageIndex = 1;
            if (mouseButton == LEFT && mouseDown)
            {
                imageIndex = 2;
                audioManager.play(selectSound);
                game.setGameState(action);
            }
        }
        else
        {
            imageIndex = 0;
            hoverSoundPlayed = false;
        }
        image(images[imageIndex], position.x, position.y);
    }

    // Reference types
    private GameState action;
    private PVector position;
    private PImage images[];
    
    // Reference types
    private boolean enabled;
    private int imageIndex;
    private boolean hoverSoundPlayed = false; 
    private int hoverSound;
    private int selectSound;
}