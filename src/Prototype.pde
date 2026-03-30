//boss class
class Boss extends Enemy {

  float maxHp;
  float hp;
  color bossColor = color(120, 0, 200);

  Boss(float startX, float startY, int bx, int by, int bw, int bh, int wave) {
    super(startX, startY, bx, by, bw, bh);
    radius      = 28;
    maxHp       = 50 + wave * 20;
    hp          = maxHp;
  }

  void takeDamage(float amount) {
    hp = max(0, hp - amount);
    if (hp <= 0) defeated = true;
  }

  boolean isDead() { return defeated; }

  void display(Player p) {
    noStroke();
    fill(120, 0, 200, 40);
    ellipse(x, y, (radius + 18) * 2, (radius + 18) * 2);

    stroke(80, 0, 160);
    strokeWeight(2.5);
    fill(aggroed ? color(150, 0, 255) : color(120, 0, 200));
    ellipse(x, y, radius * 2, radius * 2);

    noStroke();
    fill(255, 215, 0);
    for (int i = 0; i < 5; i++) {
      float a  = -HALF_PI + i * TWO_PI / 5;
      float sx = x + cos(a) * radius;
      float sy = y + sin(a) * radius;
      ellipse(sx, sy, 8, 8);
    }

    float angle = atan2(p.y - y, p.x - x);
    fill(255, 50, 50);
    noStroke();
    ellipse(x + cos(angle) * (radius * 0.45),
            y + sin(angle) * (radius * 0.45), 9, 9);

    float barW  = radius * 3;
    float barX  = x - barW / 2;
    float barY  = y - radius - 22;
    float ratio = hp / maxHp;

    noStroke();
    fill(50);
    rect(barX, barY, barW, 10, 3);
    fill(lerpColor(color(255, 50, 50), color(150, 0, 255), ratio));
    rect(barX, barY, barW * ratio, 10, 3);
    stroke(120);
    strokeWeight(1);
    noFill();
    rect(barX, barY, barW, 10, 3);

    fill(255, 215, 0);
    noStroke();
    textSize(10);
    textAlign(CENTER, BOTTOM);
    text("BOSS", x, barY - 2);
  }
}
