//loot class

class Loot {
  float  x, y;
  int    size     = 12;
  int    lifespan = 60000;
  int    spawnTime;
  String rarity;   
  color  col;

  Loot(float x, float y, String rarity) {
    this.x         = x;
    this.y         = y;
    this.rarity    = rarity;
    this.spawnTime = millis();
    this.col       = rarity.equals("rare") ? color(80, 140, 255) : color(255, 215, 0);
  }

  boolean isExpired() {
    if (millis() - spawnTime > lifespan) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    stroke(red(col), green(col), blue(col));
    strokeWeight(1.5);
    fill(red(col), green(col), blue(col), 180);
    rect(x - size / 2, y - size / 2, size, size);
  }
}
