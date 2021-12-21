
/**
* The AudioFader class is used to fade the audio up or down. It is ran in it's own thread. 
* @author Leyton O'Day
* @version 2
*/
public class AudioFader implements Runnable 
{
  public AudioFader(AudioData audioData, AudioManagerFadeDirection fadeDirection, GameStateSwitchCounter gameStateSwitchCounter) 
  {
    this.fadeDirection = fadeDirection;
    this.audioData = audioData;
    this.gameStateSwitchCounter = gameStateSwitchCounter;
    volumeGainControl = (FloatControl)audioData.audio.getControl(FloatControl.Type.MASTER_GAIN);
    originalStateSwitchCounter = this.gameStateSwitchCounter.counter;
  }

  private boolean IsGameStateSwitched()
  {
    return originalStateSwitchCounter != gameStateSwitchCounter.counter;
  }

  /**
  * This method gradually fades the audio volume up until it is at max volume.
  * @exception java.lang.InterruptedException Just because I call Thread.Sleep
  */
  private void fadeVolumeUp() throws InterruptedException
  {
    while (!IsGameStateSwitched() && volumeGainControl.getValue() < volumeGainControl.getMaximum()/4)
    {
      volumeGainControl.setValue(Math.max(volumeGainControl.getMinimum(), Math.min(volumeGainControl.getMaximum(), volumeGainControl.getValue() + 1/frameRate)));
      Thread.sleep(1);
    }
  }

  /**
  * This method gradually fades the audio volume down until it is at minimum volume.
  * @exception java.lang.InterruptedException Just because I call Thread.Sleep
  */
  private void fadeVolumeDown() throws InterruptedException
  {
    while (!IsGameStateSwitched() && volumeGainControl.getValue() > volumeGainControl.getMinimum())
    {
      volumeGainControl.setValue(Math.max(volumeGainControl.getMinimum(), Math.min(volumeGainControl.getMaximum(), volumeGainControl.getValue() - 1/frameRate))); 
      Thread.sleep(1);
    }
  }

  public void run() 
  {
    try 
    {
      if (fadeDirection == AudioManagerFadeDirection.UP)
        fadeVolumeUp();
      else 
        fadeVolumeDown();
    } catch (Exception e)
    {
      println(e);
    }
  }

  AudioManagerFadeDirection fadeDirection;
  FloatControl volumeGainControl;
  AudioData audioData;
  GameStateSwitchCounter gameStateSwitchCounter;
  int originalStateSwitchCounter;
}