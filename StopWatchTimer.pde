/**
* The StopWatchTimer class is used for all tracking the deltaTime between game events
*
* @author Leyton O'Day
* @version 1.0
*/
public class StopWatchTimer
{
    /**
    * This method is the constructor, and is used to initialize all the instance fields of the StopWatchTimer class.
    */
    public StopWatchTimer()
    {
        this.startTime = millis();
    }
    /**
    * This method calculates the amount of time since the StopWatchTimer was initialized.
    * @return int This is the amount of time on the timer, in milliseconds.
    */
    public int getTime()
    {
        return Math.max(0, millis() - startTime);
    }
    /**
    * This method resets the time left on the timer to 0.
    */
    public void reset()
    {
        this.startTime = millis();
    }

    private int startTime;
}