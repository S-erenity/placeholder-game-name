//enemy class

class Enemy extends Entity {

  final float WANDER_SPEED = 1.0;
  float chaseSpeed;
  final float AGGRO_RANGE  = 150;

  float wanderAngle;
  int   wanderChangeTime = 0;
  int   wanderInterval   = 1500;

  boolean aggroed  = false;
  boolean defeated = false;

  float maxHp;
  float hp;

  Enemy(float startX, float startY, int bx, int by, int bw, int bh) {
    super(startX, startY, 14, bx, by, bw, bh);
    maxHp      = 3;
    hp         = maxHp;
    chaseSpeed = 2.2;
    wanderAngle = random(TWO_PI);
  }

  void takeDamage(float amount) {
    hp = max(0, hp - amount);
    if (hp <= 0) defeated = true;
  }

  boolean isDead() { return defeated; }

  void update() {}

  void update(Player p) {
    float d = dist(x, y, p.x, p.y);
    aggroed = (d <= AGGRO_RANGE);

    if (aggroed) {
      float dx  = p.x - x;
      float dy  = p.y - y;
      float mag = sqrt(dx * dx + dy * dy);
      x += (dx / mag) * chaseSpeed;
      y += (dy / mag) * chaseSpeed;
    } else {
      if (millis() - wanderChangeTime > wanderInterval) {
        wanderAngle      = random(TWO_PI);
        wanderChangeTime = millis();
      }
      x += cos(wanderAngle) * WANDER_SPEED;
      y += sin(wanderAngle) * WANDER_SPEED;

      if (x - radius < bx || x + radius > bx + bw) {
        wanderAngle = PI - wanderAngle;
        clampToBounds();
      }
      if (y - radius < by || y + radius > by + bh) {
        wanderAngle = -wanderAngle;
        clampToBounds();
      }
    }
  }

  boolean hits(Player p) { return overlaps(p); }

  void display() {}

  void display(Player p) {
    if (!aggroed) {
      noFill();
      stroke(255, 60, 60, 55);
      strokeWeight(1);
      ellipse(x, y, AGGRO_RANGE * 2, AGGRO_RANGE * 2);
    }
    if (aggroed) {
      noStroke();
      fill(255, 0, 0, 50);
      ellipse(x, y, (radius + 12) * 2, (radius + 12) * 2);
    }

    stroke(180, 0, 0);
    strokeWeight(2);
    fill(aggroed ? color(255, 40, 40) : color(200, 60, 60));
    ellipse(x, y, radius * 2, radius * 2);

    float angle = atan2(p.y - y, p.x - x);
    fill(255);
    noStroke();
    ellipse(x + cos(angle) * (radius * 0.45),
            y + sin(angle) * (radius * 0.45), 5, 5);

    float barW  = radius * 2.5;
    float barX  = x - barW / 2;
    float barY  = y - radius - 14;
    float ratio = hp / maxHp;

    noStroke();
    fill(50);
    rect(barX, barY, barW, 7, 2);
    fill(lerpColor(color(255, 50, 50), color(80, 200, 80), ratio));
    rect(barX, barY, barW * ratio, 7, 2);
    stroke(100);
    strokeWeight(0.5);
    noFill();
    rect(barX, barY, barW, 7, 2);
  }
}
