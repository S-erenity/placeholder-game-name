
class Loot {

  float x, y;
  int   size     = 12;
  int   lifespan = 60000;
  int   spawnTime;
  String rarity;

  Loot(float x, float y) {
    this.x         = x;
    this.y         = y;
    this.spawnTime = millis();  //moment loot spawn
    this.rarity    = "common";
  }

  // loot disssapeares after 60 second has  elapsed
  boolean isExpired() {
    if (millis() - spawnTime > lifespan) {
      return true;
    } else {
      return false;
    }
  }

  // render square (aka the loot) on ground
  void display() {
    stroke(255, 215, 0);
    strokeWeight(1.5);
    fill(255, 215, 0, 180);
    rect(x - size / 2, y - size / 2, size, size);
  }
}
