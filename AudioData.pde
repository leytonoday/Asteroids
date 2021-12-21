import java.io.File;
import java.io.IOException;
import javax.sound.sampled.*;

/**
* The AudioState enum will be used to indicate the current state of any audio file being handled by the AudioManager class.
*
* @author Leyton O'Day
* @version 2.0
*/
public static enum AudioState { STOPPED, PAUSED, PLAYING };

/**
* The AudioError class is simply used to indicate an error. Any field could be returned from an AudioManager method due to erroneous parameters or conditions.
*
* @author Leyton O'Day
* @version 2.0
*/
public static class AudioError
{
    public static final int SUCCESS = 0;
    public static final int INVALID_AUDIO_ID = -1;
    public static final int AUDIO_LIMIT_EXCEEDED = -2;
    public static final int UNSUPPORTED_FILE = -3;
    public static final int AUDIO_NOT_PLAYED = -4;
    public static final int AUDIO_NOT_PAUSED = -5;
    public static final int AUDIO_STOPPED = -7;
}

/**
* The AudioData class is used to store all the data associated with a sound or a piece of music being managed by the AudioManager.
*
* @author Leyton O'Day
* @version 2.0
*/
public class AudioData
{
    /**
    * This method is the constructor, and is used to initialize the instance AudioData of the StaticEntity class.
    * @param path The path of the audio file to be loaded.
    * @param looping A boolean used to indicate wether or not the audio should loop when played.
    */
    public AudioData(String path, boolean looping)
    {
        this.path = path;
        this.looping = looping;
    }
    /**
    * This method is the second constructor of Entity, with default values of true for looping.
    */
    public AudioData(String path)
    {
        this(path, false);
    }
    
    // Reference types
    public AudioState state = AudioState.STOPPED;
    public String path;
    public AudioInputStream inputStream;
    public Clip audio;

    // Primitive types
    public long pausedTimeStamp;
    public int ID;
    public int duration;
    public boolean looping;
    public boolean played;
}
