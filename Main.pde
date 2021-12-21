Game game;
AudioManager audioManager;
boolean mouseDown;

void setup()
{
  size(640, 660);
  frameRate(60);
  surface.setTitle("Defender!");
  textFont(createFont("GameFont.ttf", 15));
  audioManager = new AudioManager();;
  game = new Game();
}

void draw()
{
  game.draw();
}

void mousePressed()
{
  mouseDown = true;
}

void mouseReleased()
{
  mouseDown = false;
}

void keyPressed()
{
  if (key == 'p') //If the user presses p, pause the game
  {
    if (game.gameState == GameState.PAUSED)
      game.setGameState(GameState.PLAYING);
    else if (game.gameState == GameState.PLAYING)
      game.setGameState(GameState.PAUSED);
  }
  if (key == ' ') //If the user presses space, shoot
  {
    game.player.keyArray[0] = true;
  }
  if (key == CODED) //If the user presses the arrow keys (which are coded), move appropriately.
  {
    if (keyCode == UP)
      game.player.keyArray[1] = true;
    if (keyCode == DOWN)
      game.player.keyArray[2] = true;
    if (keyCode == LEFT)
      game.player.keyArray[3] = true;
    if (keyCode == RIGHT)
      game.player.keyArray[4] = true;
  }
}

void keyReleased()
{
  if (key == ' ')
  {
    game.player.keyArray[0] = false;
  }
  if (key == CODED)
  {
    if (keyCode == UP)
      game.player.keyArray[1] = false;
    if (keyCode == DOWN)
      game.player.keyArray[2] = false;
    if (keyCode == LEFT)
      game.player.keyArray[3] = false;
    if (keyCode == RIGHT)
      game.player.keyArray[4] = false;
  }
}