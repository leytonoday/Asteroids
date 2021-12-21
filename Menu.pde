/**
* The Menu class is used for the Start, Pause, Win and Lose menus.
*
* @author Leyton O'Day
* @version 2.0
*/
class Menu
{
    /**
    * This method is the constructor, and is used to initialize all the instance fields of the StaticEntity class.
    * @param images The unique images to be displayed on each menu. Every menu has the same backround and rotating Earth image by default.
    * @param otherButton A secondary button to the defaulyt Quit button.
    * @param Anim The animated title of the menu.
    */
    public Menu(SmartImage[] images, Button otherButton, Anim title)
    {
        this.images = images;
        this.otherButton = otherButton;
        this.title = title;
        this.title.play();
        background = new SmartImage(new PVector(-width/2, -height/2), "menuImages/menuBackground.jpg", new PVector(1.5, 1.5));
        background.setRotating(true, 0.2);
        smallEarth = new SmartImage(new PVector(Entity.X_CENTRE, 400), "menuImages/smallEarth.png");
        quitButton = new Button(new PVector(Entity.X_CENTRE, otherButton == null? 200: 320), "buttonImages/quitButtonImages/", GameState.QUIT);
        smallEarth.setRotating(true, -0.2);
    }
    /**
    * This method is the second constructor of Menu, with default values null for otherButton.
    */
    public Menu(SmartImage[] images, Anim title)
    {
        this(images, null, title);
    }
    /**
    * This method is the second constructor of Menu, with default values of an empty array for images.
    */
    public Menu(Button otherButton, Anim title)
    {
        this(new SmartImage[]{}, otherButton, title);
    }
    /**
    * This method is the second constructor of Menu, with default values null for otherButton and an empty array for images.
    */
    public Menu(Anim title)
    {
        this(new SmartImage[]{}, null, title);
    }
    /**
    * This method is called every frame to check the buttons, animate the title, and rotate the background.
    */
    public void update()
    {
        background.update();
        smallEarth.update();

        for (SmartImage image: images)
            image.update();
        
        quitButton.update();

        if (otherButton != null)
            otherButton.update();
    
        title.update();
    }

    // Reference Types
    private SmartImage[] images;
    private Button otherButton;
    private Anim title;
    private SmartImage background;
    private SmartImage smallEarth;
    public Button quitButton; //This is public because in one instance of the menu, we need to adjust the y position of this button

    // Primitive Types
    private float backgroundRotation = 0;
}