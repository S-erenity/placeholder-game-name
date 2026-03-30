//entry point

GameManager gm;

void setup() {
  size(900, 700);
  gm = new GameManager();
}

void draw() {
  background(30);
  gm.update();
  gm.display();
}

void keyPressed()  { gm.player.onKeyPressed(keyCode);  }
void keyReleased() { gm.player.onKeyReleased(keyCode); }
void mousePressed() { gm.handleClick(mouseX, mouseY); }
