import java.util.LinkedHashMap;
import java.util.ArrayList;
import java.util.Arrays;

public enum AudioManagerFadeDirection { DOWN, UP }; 

/**
* The AudioManager class is used to easily handle audio in the game. All methods require the audioID of the sound you with to manipulate.
*
* @author Leyton O'Day
* @version 2.0
*/
public class AudioManager
{
  public AudioManager()
  {
    audioMap = new LinkedHashMap<Integer,AudioData>();
    supportedFileExtensions = new String[] {"aifc", "aiff", "au", "snd", "wav"};
  }
  /**
  * This method is used to return a unique ID to be assigned to a newly loaded audio file.
  * @return int The audioID of the newly loaded audio.
  */
  public int generateID()
  {
    IDCounter++;
    return IDCounter;
  }
  private <T> boolean contains(T array[], T item)
  {
    for(T i: array)
        if (i.equals(item))
            return true;
    return false;
  }
  public boolean isTypeSupported(String path) 
  {
      String tokens[] = path.split("\\.");
      return contains(supportedFileExtensions, tokens[tokens.length-1]);
  }
  private AudioData getAudioData(int audioID) 
  {
      return audioMap.get(audioID);
  }
  /**
  * This method loads audio files and creates an AudioData object containing all relevent data.
  * @param path The path of the audio file to load.
  * @param looping If the sound should loop or not.
  * @param initVolume The initial volume of the audio.
  * @return int The audioID of the newly created AudioData object.
  */
  public int load(String path, boolean looping, float initVolume)
  {
      //Check if file is supported
      if (!isTypeSupported(path))
        return AudioError.UNSUPPORTED_FILE;
      
      //Check if audio limit has not been reached
      if (audioMap.size() >= AUDIO_LIMIT)
        return AudioError.AUDIO_LIMIT_EXCEEDED;

      AudioData audioData = new AudioData(path, looping);
      audioData.ID = generateID();

      try 
      {
        //Initialize Clip object
        audioData.inputStream = AudioSystem.getAudioInputStream(new File(dataPath(path)));
        audioData.audio =  AudioSystem.getClip(); 
        audioData.audio.open(audioData.inputStream);
        if (looping)
          audioData.audio.loop(Clip.LOOP_CONTINUOUSLY);
      }
      catch (UnsupportedAudioFileException e)
      {
        println(e.getMessage());
        e.printStackTrace(System.out);
      }
      catch (IOException e)
      {
        println(e.getMessage());
        e.printStackTrace(System.out);
      }
      catch (LineUnavailableException e)
      {
        println(e.getMessage());
        e.printStackTrace(System.out);
      }

  
      //Get the duration of the sound. This was a little hard.
      audioData.duration = (int)(audioData.inputStream.getFrameLength() / audioData.inputStream.getFormat().getFrameRate()) * 1000;
      audioMap.put(audioData.ID, audioData);
      setVolume(audioData.ID, initVolume);
      // Add a line event listener to the clip object, so I can set the audioState of the AudioData object to AudioState.STOPPED.
      audioData.audio.addLineListener(new LineListener() 
      { //Clip is actually a Line, which is an audio feed into a mixer. The mixer just mixes audio signals, and outputs them via the standard audio output of a device (I think)
        Integer[] arrayKeys = audioMap.keySet().toArray(new Integer[audioMap.size()]);
        AudioData audioData = getAudioData(audioMap.get(arrayKeys[arrayKeys.length-1]).ID);
        public void update(LineEvent event)
        {
          if (event.getType() == LineEvent.Type.STOP)
            audioData.state = AudioState.STOPPED;
        }
      });

      return audioData.ID;
  }
  /**
  * This method is an overload of load(String, boolean, float) of AudioManager, with default value of 1 for initVolume.
  * @return int The audioID of the newly created AudioData object.
  */
  public int load(String path, boolean looping)
  {
      return load(path, looping, 1);
  }
  /**
  * This method is an overload of load(String, boolean, float) of AudioManager, with default values of 1 for initVolume and false for looping.
  * @return int The audioID of the newly created AudioData object.
  */
  public int load(String path)
  {
      return load(path, false, 1);
  }
  /**
  * This method is used to unload audio from the AudioManager. 
  * @param audioID The audioID of the audio to be unloaded. 
  * @return int The error code indicating the success of the method.
  */
  public int unload(int audioID)
  {
      AudioData audioData = getAudioData(audioID);
      if (audioData == null)
        return AudioError.INVALID_AUDIO_ID;
      audioMap.remove(audioID);
      return AudioError.SUCCESS;
  }
  /**
  * This method is used to play audio. 
  * @param audioID The audioID of the audio to be played. 
  * @return int The error code indicating the success of the method.
  */
  public int play(int audioID)
  {
      AudioData audioData = getAudioData(audioID);
      if (audioData == null)
        return AudioError.INVALID_AUDIO_ID;
      if (audioData.played)
        audioData.audio.setMicrosecondPosition(0);
      audioData.audio.start();
      audioData.played = true;
      audioData.state = AudioState.PLAYING;
      return AudioError.SUCCESS;
  }
  /**
  * This method is used to play all audio in the AudioManager. 
  * @return int The error code indicating the success of the method.
  */
  public int playAll() 
  {
    for(HashMap.Entry<Integer, AudioData> entry: audioMap.entrySet())
    {
      if (entry.getValue().played)
        entry.getValue().audio.setMicrosecondPosition(0);
      entry.getValue().audio.start();
      entry.getValue().played = true;
      entry.getValue().state = AudioState.PLAYING;
    }
    return AudioError.SUCCESS;
  }
  /**
  * This method is used to . 
  * @param audioID The audioID of the audio to be . 
  * @return int The error code indicating the success of the method.
  */
  public int pause(int audioID)
  {
    AudioData audioData = getAudioData(audioID);
    if (audioData == null)
        return AudioError.INVALID_AUDIO_ID;
    if (!audioData.played)
      return AudioError.AUDIO_NOT_PLAYED;

    audioData.pausedTimeStamp = audioData.audio.getMicrosecondPosition();
    audioData.audio.stop();
    audioData.state = AudioState.PAUSED;
    return AudioError.SUCCESS;
  }
  /**
  * This method is used to pause all audio in the AudioManager. 
  * @return int The error code indicating the success of the method.
  */
  public int pauseAll()
  {
    for(HashMap.Entry<Integer, AudioData> entry: audioMap.entrySet())
    {
      if (!entry.getValue().played)
        return AudioError.AUDIO_NOT_PLAYED;
      
      entry.getValue().pausedTimeStamp = entry.getValue().audio.getMicrosecondPosition();
      entry.getValue().audio.stop();
      entry.getValue().state = AudioState.PAUSED;
    }
    return AudioError.SUCCESS;
  }
  /**
  * This method is used to pause. 
  * @param audioID The audioID of the audio to be paused. 
  * @return int The error code indicating the success of the method.
  */
  public int unpause(int audioID)
  {
    AudioData audioData = getAudioData(audioID);
    if (audioData == null)
        return AudioError.INVALID_AUDIO_ID;
    if (audioData.played && audioData.state == AudioState.PLAYING)
      return AudioError.AUDIO_NOT_PAUSED;
    if (audioData.played && audioData.state == AudioState.STOPPED)
      return AudioError.AUDIO_STOPPED;
    if(!audioData.played)
      return AudioError.AUDIO_NOT_PLAYED;
    
    audioData.audio.setMicrosecondPosition(audioData.pausedTimeStamp);
    audioData.audio.start(); 
    audioData.state = AudioState.PLAYING;
    return AudioError.SUCCESS;
  }
  /**
  * This method is used to unpause all audio in the AudioManager. 
  * @return int The error code indicating the success of the method.
  */
  public int unpauseAll()
  {
    for(HashMap.Entry<Integer, AudioData> entry: audioMap.entrySet())
    {
      if (entry.getValue().played && entry.getValue().state == AudioState.PLAYING)
        return AudioError.AUDIO_NOT_PAUSED;
      if (entry.getValue().played && entry.getValue().state == AudioState.STOPPED)
        return AudioError.AUDIO_STOPPED;
      if(!entry.getValue().played)
        return AudioError.AUDIO_NOT_PLAYED;
        
      entry.getValue().audio.setMicrosecondPosition(entry.getValue().pausedTimeStamp);
      entry.getValue().audio.start();
      entry.getValue().state = AudioState.PLAYING;
    }
    return AudioError.SUCCESS;
  }
  /**
  * This method is used to unpause. 
  * @param audioID The audioID of the audio to be unpaused. 
  * @return int The error code indicating the success of the method.
  */
  public int stop(int audioID)
  {
    AudioData audioData = getAudioData(audioID);
    if (audioData == null)
        return AudioError.INVALID_AUDIO_ID;
    if (!audioData.played)
      return AudioError.AUDIO_NOT_PLAYED;
      
    audioData.audio.setMicrosecondPosition(0);
    audioData.audio.stop();
    audioData.state = AudioState.STOPPED;
    return AudioError.SUCCESS;
  }
  /**
  * This method is used to stop all audio in the AudioManager. 
  * @return int The error code indicating the success of the method.
  */
  public int stopAll()
  {
    for(HashMap.Entry<Integer, AudioData> entry: audioMap.entrySet())
    {
      if (!entry.getValue().played)
        return AudioError.AUDIO_NOT_PLAYED;
      
      entry.getValue().audio.setMicrosecondPosition(0);
      entry.getValue().audio.stop();
      entry.getValue().state = AudioState.STOPPED;
    }
    return AudioError.SUCCESS;
  }
  /**
  * This method is used to change the volume of audio.
  * @param audioID The audioID of the audio to be affected. 
  * @param volume The deired volume.
  * @return int The error code indicating the success of the method.B
  */
  public int setVolume(int audioID, float volume)
  {
    AudioData audioData = getAudioData(audioID);
    if (audioData == null)
        return AudioError.INVALID_AUDIO_ID;

    //the gain on an audio signal is amplification upon the base singal. Changing this acts as changing the volume
    FloatControl gainControl = (FloatControl)audioData.audio.getControl(FloatControl.Type.MASTER_GAIN);
    float newVolume = 20f * (float)Math.log10((float)clamp(volume, 0, 1)); // convert decimal to decibels
    gainControl.setValue(clamp(newVolume, gainControl.getMinimum(), gainControl.getMaximum()));

    return AudioError.SUCCESS;
  }
  /**
  * This method is used to change the volume of all audio in the AudioManager.
  * @param volume The deired volume.
  * @return int The error code indicating the success of the method.
  */
  public int setVolumeAll(float volume) 
  {
    for(HashMap.Entry<Integer, AudioData> entry: audioMap.entrySet())
      setVolume(entry.getKey(), volume);
    return AudioError.SUCCESS;
  }
  /**
  * This method is used to get the volume of a particular audio.
  * @param audioID The deired audio.
  * @return float The volume of the desired audio.
  */
  public float getVolume(int audioID)
  {
    AudioData audioData = getAudioData(audioID);
    if (audioData == null)
      return AudioError.INVALID_AUDIO_ID;

    FloatControl gainControl = (FloatControl)audioData.audio.getControl(FloatControl.Type.MASTER_GAIN); //the gain on an audio signal is amplification upon the base singal. Changing this acts as changing the volume
    return (float)Math.pow(10f, gainControl.getValue() / 20f);
  }
  /**
  * This method is used to set the playing position of all audio.
  * @return float The volume of the desired audio.
  */
  public int setPlayingPositionAll(int position)
  {
    for(HashMap.Entry<Integer, AudioData> entry: audioMap.entrySet())
      entry.getValue().audio.setMicrosecondPosition(clamp(position, 0, getDuration(entry.getKey()))*1000);
    return AudioError.SUCCESS;
  }
  /**
  * This method is used to set the playing position of audio.
  * @param audioID The deired audio.
  * @return int The error code indicating the success of the method.
  */
  public int setPlayingPosition(int audioID, int position)
  {
    AudioData audioData = getAudioData(audioID);
    if (audioData == null)
        return AudioError.INVALID_AUDIO_ID;
    audioData.audio.setMicrosecondPosition(clamp(position, 0, getDuration(audioID))*1000); //I'm doing my position variable in milliseconds because that is what I'm used to
    return AudioError.SUCCESS;
  }
  /**
  * This method is used to get the playing position of audio.
  * @param audioID The deired audio.
  * @return long The playing position in milliseconds of the desired audio.
  */
  public long getPlayingPosition(int audioID)
  {
    AudioData audioData = getAudioData(audioID);
    if (audioData == null)
      return AudioError.INVALID_AUDIO_ID;
      
    return audioData.audio.getMicrosecondPosition();
  }
  /**
  * This method is used to get the duration of audio.
  * @param audioID The deired audio.
  * @return long The duration in milliseconds of the desired audio.
  */
  public int getDuration(int audioID)
  {
    AudioData audioData = getAudioData(audioID);
    if (audioData == null)
      return AudioError.INVALID_AUDIO_ID;
      
    return audioData.duration;
  }
  /**
  * This method is used to get the amount of AudioData objects currently loaded into the AudioManager system.
  * @return int The amount of AudioData objects currently loaded into the AudioManager system.
  */
  public int getAudioCount()
  {
    return audioMap.size();
  }
  /**
  * This method is used to get the state of an audio.
  * @param audioID The deired audio.
  * @exception java.lang.IllegalArgumentException Used to indicate that the given audioID is invalid. Used instead of an AudioError field becuase I am not returning an integer.
  * @return long The state of the desired audio.
  */
  public AudioState getState(int audioID) throws IllegalArgumentException
  {
    AudioData audioData = getAudioData(audioID);
    if (audioData == null) //In this instance, I can't return AudioError.INVALID_AUDIO_ID, because it is an integer. I cannot attatch numerical value to an enum, so I have to throw an exception in this case
      throw new IllegalArgumentException("INVALID_AUDIO_ID: " + audioID);
    return audioData.state;
  }
  /**
  * This method is used to keep a given value between a max and a min.
  * @param value The value to be clamped.
  * @param value The minimum value of the return.
  * @param value The maximum value of the return.
  * @return int The clamped value.
  */
  public int clamp(int value, int min, int max)
  {
    if (value < min)
      return min;
    else if (value > max)
      return max;
    return value;
  }
  /**
  * This method is used to keep a given value between a max and a min.
  * @param value The value to be clamped.
  * @param value The minimum value of the return.
  * @param value The maximum value of the return.
  * @return float The clamped value.
  */
  public float clamp(float value, float min, float max)
  {
    if (value < min)
      return min;
    else if (value > max)
      return max;
    return value;
  }
  /**
  * This method is put an audio into a certain fade "direction" {@see AudioData#fade}.
  * @param audioID The audio to be affected.
  * @param fade The desired fade direction; fade up or down in volume.
  * @param gameStateSwtichCounter Used to check if the game state has switched in the AudioFader thread. If so, the thread ends. 
  * @return int The error code indicating the success of the method.
  */
  public int setFade(int audioID, AudioManagerFadeDirection fadeDirection, GameStateSwitchCounter gameStateSwitchCounter) 
  {
    AudioData audioData = getAudioData(audioID);
    if (audioData == null)
      return AudioError.INVALID_AUDIO_ID;

    AudioFader af = new AudioFader(audioData, fadeDirection, gameStateSwitchCounter);
    new Thread(af).start();

    return AudioError.SUCCESS;
  }
  // Reference types
  private LinkedHashMap <Integer, AudioData> audioMap;
  private String[] supportedFileExtensions;

  // Primitive types
  private int IDCounter = 0;
  private final int AUDIO_LIMIT = 32; //As far as I'm aware, Java only allows me to use 32 Lines simultaneously. Each sound has a Clip, which is a subclass of Line. So this is the max
  private final int MAX_VOLUME = 1;
  private final float MIN_VOLUME = 0.1;
}
