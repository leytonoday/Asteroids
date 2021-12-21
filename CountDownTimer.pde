/**
* The CountDownTimer class is used for all countdowns
*
* @author Leyton O'Day
* @version 1.0
*/
public class CountDownTimer
{
    public CountDownTimer(int duration) 
    {
        this.duration = duration; 
    }
    public void start() 
    {
        startTime = millis();
    }
    public boolean isStarted() 
    {
        return startTime != -1;
    }
    public boolean isPaused() 
    {
        return timePausedAt != -1;
    }
    public int getTime()
    {
        if (isPaused())
            return timePausedAt;
        return Math.max(0, (startTime + duration) - millis());
    }
    public void reset()
    {
        startTime = millis();
    }
    public void pause() 
    {
        timePausedAt = millis();
    }
    public void unpause() 
    {
        startTime += (millis() - timePausedAt);
        timePausedAt = -1;
    }

    // Primitive types
    private int duration;
    private int startTime = -1; // default value of -1

    private int timePausedAt = -1;
}