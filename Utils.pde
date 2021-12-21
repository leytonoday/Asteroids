public class Utils 
{
    /**
    * This method is used to create an array of Strings, containing all of the file names of a folder.
    * @param path The path containing the files.
    * @exception java.lang.NullPointerException Thrown if the path cannot be found.
    * @return String[] An array of all the file names in the folder.
    */
    public String[] loadImagePaths(String path) throws NullPointerException
    {
        File folder = new File(dataPath(path));
        String[] files = folder.list();
        if (files == null)
            throw new NullPointerException("Could Not Load Files At: " + dataPath(path));
        return files;
    }
    /**
    * This method is used to create an array of Strings, containing all of the file names of a folder.
    * @param path The path containing the files.
    * @exception java.lang.NullPointerException Thrown if the path cannot be found.
    * @return String[] An array of all the file names in the folder.
    */
    public PImage[] loadFolderToPImage(String path) throws NullPointerException
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
    private void setCursorVisibility(GameState gameState) 
    {
        if (gameState == GameState.PLAYING) 
            noCursor();
        else
            cursor();
    }
}