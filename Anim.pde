/**
* The Anim class is used for all animations.
* 
* @author Leyton O'Day
* @version 2.0
*/
public class Anim implements Scalable, Sizeable, Positionable
{
    public Anim(PVector position, String path, int frameDelta, boolean looping)
    {
        this.looping = looping;
        this.frameDelta = frameDelta;
        this.animState = AnimState.STOPPED;
        this.countDownTimer = new CountDownTimer(this.frameDelta);
        this.countDownTimer.start();
        this.imageIndex = 0;
        scale = new PVector(1, 1);
        try
        {
            this.images = loadFolder(path);
        }
        catch (NullPointerException e)
        {
            println(e.getMessage());
            e.printStackTrace();
            this.images = new PImage[] {loadImage("imageMissing.png")}; // If the images for the animation cannot be found, initize the array with a single image (imageMissing.png).
        }
        setPosition(position);
    }
    public Anim(PVector position, String path)
    {
        this(position, path, 100, true);
    }
    public Anim(String path)
    {
        this(new PVector(0, 0), path, 100, true);
    }
    /**
    * This method loads all images from a given directory.
    * @param path The path of the directory to be loaded.
    * @exception java.lang.NullPointerException Thrown when directory not found.
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
    * @see Scalable#setScale(float scale)
    */
    @Override
    public void setScale(float scale)
    {
        for(PImage image: images)
            image.resize((int)(scale*image.width), (int)(scale*image.height));
        this.scale.set((int)(scale*this.scale.x), (int)(scale*this.scale.y));
    }
    /**
    * @see Scalable#setScale(PVector scale)
    */
    @Override
    public void setScale(PVector scale)
    {
        for(PImage image: images)
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
        for(PImage image: images)
        {
            image.resize((int)((1/scale.x)*image.width), (int)((1/scale.y)*image.height));
            scale.set(1, 1);
        }
    }
    /**
    * @see Sizeable#setSize(PVector size)
    */
    @Override
    public void setSize(PVector size)
    {
        for(PImage image: images)
            image.resize((int)size.x, (int)size.y);
    }
    /**
    * @see Sizeable#setSize(int x, int y)
    */
    @Override
    public void setSize(int x, int y)
    {
        for(PImage image: images)
            image.resize(x, y);
    }
    /**
    * @see Sizeable#getSize()
    */
    @Override
    public PVector getSize()
    {
        return new PVector(images[0].width, images[0].height);
    }
    /**
    * @see Positionable#setPosition(PVector position)
    */
    @Override
    public void setPosition(PVector position)
    {
        this.position = position;
        if (position.x == Entity.X_CENTRE)
            this.position.set(width/2 - images[0].width/2, position.y);
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
    * This method sets animState to AnimState.PLAYING. 
    * If the current animState is AnimState.STOPPED, then it is changed to AnimState.PLAYING, and the image index is set to 0.
    */
    public void play()
    {
        if (animState == AnimState.STOPPED)
        {
            animState = AnimState.PLAYING;
            imageIndex = 0; //Reset the image index
        }
        if (animState == AnimState.PAUSED)
            animState = AnimState.PLAYING;
        if (animState == AnimState.HIDDEN)
            animState = AnimState.PLAYING;
    }
    /**
    * This method stops the animation.
    */
    public void stop()
    {
        animState = AnimState.STOPPED;
        imageIndex = 0; //Reset the image index
    }
    /**
    * This method pauses the animation.
    */
    public void pause()
    {
        animState = AnimState.PAUSED;
    }
    /**
    * This method hides the animation, so it doesn't get drawn on the screen.
    */
    public void hide()
    {
        animState = AnimState.HIDDEN;
    }
    /**
    * This method returns the animState value.
    * @return AnimState This is the current value of the animState.
    */
    public AnimState getState()
    {
        return animState;
    }
    /**
    * This method returns if the animation loops.
    * @return boolean The looping field.
    */
    public boolean getLooping()
    {
        return looping;
    }
    /**
    * This method sets the looping of the animation loop.
    * @param looping Used to set the value of the looping field.
    */
    public void setLooping(boolean looping)
    {
        this.looping = looping;
    }
    /**
    * This method is called every frame, to change the frame of the animation.
    */
    public void update()
    {
        if (animState == AnimState.HIDDEN) //If the animation is hidden, then there is no point in running any other update code
            return;

        image(images[imageIndex % images.length], position.x, position.y);

        if (animState == AnimState.STOPPED || animState == AnimState.PAUSED) //If the animation is stopped or paused, then just return. We don't care about incrementing the imageIndex, we just need to display the image
            return;

        if (countDownTimer.getTime() <= 0)
        {
            if (looping)
                imageIndex++;
            else 
            {
                if (imageIndex != images.length-1)
                    imageIndex++;
                else
                    animState = AnimState.FINISHED;
            }
            countDownTimer.reset();
        }

    }

    // Reference types
    private PVector position;
    private PVector scale;
    private PImage[] images;
    private AnimState animState;
    private CountDownTimer countDownTimer;

    // Primitive Types
    private boolean looping;
    private int frameDelta;
    private int imageIndex;
}