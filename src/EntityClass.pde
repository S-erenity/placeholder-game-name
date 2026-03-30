//entity class

interface Drawable {
  void display();
}

abstract class Entity implements Drawable {

  float x, y;
  float radius;
  int   bx, by, bw, bh;   

  Entity(float x, float y, float radius, int bx, int by, int bw, int bh) {
    this.x      = x;
    this.y      = y;
    this.radius = radius;
    this.bx     = bx;
    this.by     = by;
    this.bw     = bw;
    this.bh     = bh;
  }

  abstract void update();

  boolean overlaps(Entity other) {
    return dist(x, y, other.x, other.y) < radius + other.radius;
  }

  void clampToBounds() {
    x = constrain(x, bx + radius, bx + bw - radius);
    y = constrain(y, by + radius, by + bh - radius);
  }
}
