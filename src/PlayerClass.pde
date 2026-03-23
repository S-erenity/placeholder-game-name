

class Player extends Entity {

  final float SPEED = 3.5;

  boolean movingUp, movingDown, movingLeft, movingRight;

  int maxHP = 10;
  int hp    = 10;

  
  boolean swinging      = false;
  float   swordAngle    = 0;
  int     swingStart    = 0;
  int     swingDuration = 200;   
  float   swordLength   = 50;    
  float   swipeArc      = PI / 2; // 90 degrees arc

  Player(float startX, float startY, int bx, int by, int bw, int bh) {
    super(startX, startY, 16, bx, by, bw, bh);
  }


  void update() {
    if (movingUp)    y -= SPEED;
    if (movingDown)  y += SPEED;
    if (movingLeft)  x -= SPEED;
    if (movingRight) x += SPEED;
    clampToBounds();

   
    if (swinging && millis() - swingStart > swingDuration) {
      swinging = false;
    }
  }

  // mouse click = sword swings
  void swing() {
    if (!swinging) {
      swinging   = true;
      swingStart = millis();
      swordAngle = atan2(mouseY - y, mouseX - x); // angle toward mouse
    }
  }

  
  boolean swordHits(Enemy e) {
    if (!swinging) return false;

    // sword collision check 
    for (float a = swordAngle - swipeArc / 2; a <= swordAngle + swipeArc / 2; a += 0.1) {
      float tipX = x + cos(a) * swordLength;
      float tipY = y + sin(a) * swordLength;
      if (dist(tipX, tipY, e.x, e.y) < e.radius + 6) {
        return true;
      }
    }
    return false;
  }

  
  void display() {
 
    if (swinging) drawSword();

   

  
    stroke(220);
    strokeWeight(2);
    fill(255);
    ellipse(x, y, radius * 2, radius * 2);

    // Direction dot thing
    float dx = 0, dy = 0;
    if (movingRight) dx =  1;
    if (movingLeft)  dx = -1;
    if (movingDown)  dy =  1;
    if (movingUp)    dy = -1;
    if (dx != 0 || dy != 0) {
      float mag = sqrt(dx * dx + dy * dy);
      fill(50);
      noStroke();
      ellipse(x + (dx / mag) * (radius * 0.55),
              y + (dy / mag) * (radius * 0.55), 5, 5);
    }
  }

  void drawSword() {
    float progress = (float)(millis() - swingStart) / swingDuration; // 0 to 1
    float startArc = swordAngle - swipeArc / 2;
    float endArc   = swordAngle + swipeArc / 2;
    float currentAngle = lerp(startArc, endArc, progress);

    // trail arc from sword
    noFill();
    stroke(200, 200, 255, 160);
    strokeWeight(3);
    arc(x, y, swordLength * 2, swordLength * 2, startArc, currentAngle);

    // Sword blade line
    stroke(220, 220, 255);
    strokeWeight(3);
    float tipX = x + cos(currentAngle) * swordLength;
    float tipY = y + sin(currentAngle) * swordLength;
    line(x, y, tipX, tipY);

    // Blade tip dot
    fill(255);
    noStroke();
    ellipse(tipX, tipY, 6, 6);
  }


  void onKeyPressed(int k) {
    if (k == UP    || k == 'W' || k == 'w') movingUp    = true;
    if (k == DOWN  || k == 'S' || k == 's') movingDown  = true;
    if (k == LEFT  || k == 'A' || k == 'a') movingLeft  = true;
    if (k == RIGHT || k == 'D' || k == 'd') movingRight = true;
  }

  void onKeyReleased(int k) {
    if (k == UP    || k == 'W' || k == 'w') movingUp    = false;
    if (k == DOWN  || k == 'S' || k == 's') movingDown  = false;
    if (k == LEFT  || k == 'A' || k == 'a') movingLeft  = false;
    if (k == RIGHT || k == 'D' || k == 'd') movingRight = false;
  }


  void takeDamage(int amount) {
    hp = max(0, hp - amount);
  }

  boolean isDead() {
    return hp <= 0;
  }
}
