//sword class

class Sword {
  String name;
  int    tier;
  float  damage;        
  int    swingCooldown; 
  color  bladeColor;
  boolean equipped;

  Sword(int tier) {
    this.tier     = tier;
    this.equipped = false;
    applyTierStats();
  }

  void applyTierStats() {
    switch (tier) {
      case 0:  
        name         = "Starter Sword";
        damage       = 1;
        swingCooldown = 600;
        bladeColor   = color(180, 180, 180);
        break;
      case 1:
        name         = "Tier 1";
        damage       = 2;
        swingCooldown = 500;
        bladeColor   = color(255, 215, 0);
        break;
      case 2:
        name         = "Tier 2";
        damage       = 4;
        swingCooldown = 420;
        bladeColor   = color(80, 200, 120);
        break;
      case 3:
        name         = "Tier 3";
        damage       = 7;
        swingCooldown = 350;
        bladeColor   = color(80, 140, 255);
        break;
      case 4:
        name         = "Tier 4";
        damage       = 12;
        swingCooldown = 280;
        bladeColor   = color(180, 80, 255);
        break;
      case 5:
        name         = "Tier 5";
        damage       = 20;
        swingCooldown = 220;
        bladeColor   = color(255, 80, 80);
        break;
      default: 
        name         = "Tier " + tier;
        damage       = 20 + (tier - 5) * 15;
        swingCooldown = max(100, 220 - (tier - 5) * 20);
        bladeColor   = color(255, 140 + (tier * 10) % 115, 0);
        break;
    }
  }

 
  int fragmentCost() {
    return 10;
  }

 
  int recycleValue() {
    return 7; // returns 7 fragments when recycled
  }

  void display(float x, float y, float angle, boolean swinging, float progress, float swordLength) {
    if (!swinging) return;

    float swipeArc  = PI / 2;
    float startArc  = angle - swipeArc / 2;
    float endArc    = angle + swipeArc / 2;
    float curAngle  = lerp(startArc, endArc, progress);

    
    noFill();
    stroke(red(bladeColor), green(bladeColor), blue(bladeColor), 130);
    strokeWeight(3);
    arc(x, y, swordLength * 2, swordLength * 2, startArc, curAngle);

   
    stroke(bladeColor);
    strokeWeight(3 + tier * 0.4);
    float tipX = x + cos(curAngle) * swordLength;
    float tipY = y + sin(curAngle) * swordLength;
    line(x, y, tipX, tipY);

   
    noStroke();
    fill(bladeColor);
    ellipse(tipX, tipY, 6 + tier, 6 + tier);
  }
}
