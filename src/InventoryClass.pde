//inventory class

class Inventory {

  final int MAX_FRAGMENTS = 1000000;

  int commonFragments = 0;
  int rareFragments   = 0;

  ArrayList<Sword> swords;  

  boolean visible = false;

  
  float panelX, panelY, panelW, panelH;

  Inventory() {
    swords = new ArrayList<Sword>();
    panelW = 420;
    panelH = 500;
    panelX = width  / 2 - panelW / 2;
    panelY = height / 2 - panelH / 2;
  }

 
  void addCommon(int amount) {
    commonFragments = min(MAX_FRAGMENTS, commonFragments + amount);
  }

  void addRare(int amount) {
    rareFragments = min(MAX_FRAGMENTS, rareFragments + amount);
  }

  boolean spendCommon(int amount) {
    if (commonFragments >= amount) {
      commonFragments -= amount;
      return true;
    }
    return false;
  }

  void addSword(Sword s) {
    swords.add(s);
  }

  void removeSword(Sword s) {
    swords.remove(s);
  }

  
  void toggle() {
    visible = !visible;
  }

  
  Sword handleClick(float mx, float my) {
    if (!visible) return null;

   
    if (mx > panelX + panelW - 30 && mx < panelX + panelW &&
        my > panelY && my < panelY + 30) {
      visible = false;
      return null;
    }

    
    for (int i = 0; i < swords.size(); i++) {
      float btnX = panelX + panelW - 110;
      float btnY = panelY + 130 + i * 52;
      if (mx > btnX && mx < btnX + 90 &&
          my > btnY && my < btnY + 30) {
        Sword s = swords.get(i);
        if (!s.equipped) {
          swords.remove(i);
          return s; 
        }
      }
    }
    return null;
  }

  boolean isOverPanel(float mx, float my) {
    return visible && mx > panelX && mx < panelX + panelW &&
                      my > panelY && my < panelY + panelH;
  }

  
  void display(Sword equipped) {
    if (!visible) return;

    
    noStroke();
    fill(20, 22, 30, 235);
    rect(panelX, panelY, panelW, panelH, 10);
    stroke(80, 80, 120);
    strokeWeight(1.5);
    noFill();
    rect(panelX, panelY, panelW, panelH, 10);

    
    fill(255);
    noStroke();
    textSize(18);
    textAlign(LEFT, TOP);
    text("INVENTORY", panelX + 20, panelY + 16);

    fill(180, 60, 60);
    noStroke();
    rect(panelX + panelW - 28, panelY + 6, 22, 22, 4);
    fill(255);
    textSize(13);
    textAlign(CENTER, CENTER);
    text("X", panelX + panelW - 17, panelY + 17);

    textAlign(LEFT, TOP);
    textSize(13);
    fill(255, 215, 0);
    text("Sword Fragments:  x" + commonFragments, panelX + 20, panelY + 55);
    fill(80, 140, 255);
    text("Blue Fragments:   x" + rareFragments,   panelX + 20, panelY + 75);

    stroke(60, 60, 90);
    strokeWeight(1);
    line(panelX + 10, panelY + 100, panelX + panelW - 10, panelY + 100);

    textAlign(LEFT, CENTER);
    for (int i = 0; i < swords.size(); i++) {
      Sword s   = swords.get(i);
      float row = panelY + 118 + i * 52;

      noStroke();
      fill(s.equipped ? color(30, 50, 30) : color(30, 30, 45));
      rect(panelX + 10, row, panelW - 20, 42, 6);

      fill(s.bladeColor);
      rect(panelX + 20, row + 11, 20, 20, 3);

      fill(255);
      textSize(12);
      text(s.name, panelX + 50, row + 14);
      fill(160);
      textSize(10);
      text("DMG: " + s.damage + "   SPD: " + s.swingCooldown + "ms", panelX + 50, row + 30);

      if (s.equipped) {
        fill(80, 200, 120);
        textSize(10);
        textAlign(RIGHT, CENTER);
        text("EQUIPPED", panelX + panelW - 120, row + 21);
        textAlign(LEFT, CENTER);
      }

      if (!s.equipped) {
        fill(160, 80, 40);
        noStroke();
        rect(panelX + panelW - 110, row + 6, 90, 30, 5);
        fill(255);
        textSize(11);
        textAlign(CENTER, CENTER);
        text("RECYCLE (+7)", panelX + panelW - 65, row + 21);
        textAlign(LEFT, CENTER);
      }
    }

    if (swords.isEmpty()) {
      fill(120);
      textSize(12);
      textAlign(CENTER, CENTER);
      text("No swords yet. Try crafting!", panelX + panelW / 2, panelY + 200);
    }
  }
}
