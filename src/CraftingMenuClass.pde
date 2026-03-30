//crafting menu

class CraftingParticle {
  float x, y, vx, vy, life, maxLife;
  color col;

  CraftingParticle(float cx, float cy, color c) {
    float angle = random(TWO_PI);
    float spd   = random(2, 6);
    x = cx; y = cy;
    vx = cos(angle) * spd;
    vy = sin(angle) * spd;
    maxLife = life = random(30, 60);
    col = c;
  }

  void update() { x += vx; y += vy; vy += 0.1; life--; }
  boolean dead() { return life <= 0; }

  void display() {
    float alpha = map(life, 0, maxLife, 0, 255);
    noStroke();
    fill(red(col), green(col), blue(col), alpha);
    ellipse(x, y, 6, 6);
  }
}


class CraftingMenu {

  boolean visible = false;

  float panelX, panelY, panelW, panelH;

  String state       = "idle";
  int    spinStart   = 0;
  int    spinDuration = 5000;  
  float  spinAngle   = 0;
  int    targetTier  = 1;      

  int resultStart    = 0;
  int resultDuration = 2000;

  ArrayList<CraftingParticle> particles;

  float[] slotX = new float[10];
  float   slotY;
  float   slotSize = 32;

  CraftingMenu() {
    particles = new ArrayList<CraftingParticle>();
    panelW = 500;
    panelH = 540;
    panelX = width  / 2 - panelW / 2;
    panelY = height / 2 - panelH / 2;

    float startX = panelX + (panelW - (10 * (slotSize + 6) - 6)) / 2;
    slotY = panelY + 200;
    for (int i = 0; i < 10; i++) {
      slotX[i] = startX + i * (slotSize + 6);
    }
  }

  void toggle() { visible = !visible; }

  
  boolean attemptCraft(Inventory inv, int tier) {
    if (state.equals("spinning")) return false;
    if (inv.commonFragments < 10)  return false;

    inv.spendCommon(10);
    targetTier = tier;
    state      = "spinning";
    spinStart  = millis();
    spinAngle  = 0;
    particles.clear();
    return true;
  }

  Sword update(Inventory inv) {
    for (int i = particles.size() - 1; i >= 0; i--) {
      particles.get(i).update();
      if (particles.get(i).dead()) particles.remove(i);
    }

    if (!state.equals("spinning")) return null;

    float elapsed  = millis() - spinStart;
    float progress = elapsed / spinDuration; 

    float spinSpeed = lerp(0.03, 0.25, progress);
    spinAngle += spinSpeed;

    if (frameCount % 3 == 0) {
      float px = panelX + panelW / 2 + cos(spinAngle) * 50;
      float py = panelY + 310       + sin(spinAngle) * 50;
      particles.add(new CraftingParticle(px, py, color(255, 215, 0)));
    }

    if (elapsed >= spinDuration) {
      float roll = random(100);
      if (roll < 5) {  // 5% success chance
        state       = "success";
        resultStart = millis();
        spawnResultParticles(color(80, 255, 120));
        Sword newSword = new Sword(targetTier);
        return newSword;
      } else {          // 95% fail
        state       = "fail";
        resultStart = millis();
        spawnResultParticles(color(255, 60, 60));
        int penalty = (int) random(1, 11);
        inv.commonFragments = max(0, inv.commonFragments - penalty);
      }
    }

   
    if ((state.equals("success") || state.equals("fail")) &&
         millis() - resultStart > resultDuration) {
      state = "idle";
    }

    return null;
  }

  void spawnResultParticles(color c) {
    float cx = panelX + panelW / 2;
    float cy = panelY + 310;
    for (int i = 0; i < 60; i++) {
      particles.add(new CraftingParticle(cx, cy, c));
    }
  }

 
  int handleClick(float mx, float my, Inventory inv) {
    if (!visible) return -1;


    if (mx > panelX + panelW - 30 && mx < panelX + panelW &&
        my > panelY && my < panelY + 30) {
      visible = false;
      return -1;
    }

 
    float btnX = panelX + panelW / 2 - 70;
    float btnY = panelY + 380;
    if (mx > btnX && mx < btnX + 140 && my > btnY && my < btnY + 40) {
      return targetTier;
    }


    for (int t = 1; t <= 5; t++) {
      float tbx = panelX + 20 + (t - 1) * 88;
      float tby = panelY + 430;
      if (mx > tbx && mx < tbx + 78 && my > tby && my < tby + 34) {
        targetTier = t;
      }
    }

    return -1;
  }

  boolean isOverPanel(float mx, float my) {
    return visible && mx > panelX && mx < panelX + panelW &&
                      my > panelY && my < panelY + panelH;
  }


  void display(Inventory inv) {
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
    text("CRAFTING", panelX + 20, panelY + 16);

  
    fill(180, 60, 60);
    noStroke();
    rect(panelX + panelW - 28, panelY + 6, 22, 22, 4);
    fill(255);
    textSize(13);
    textAlign(CENTER, CENTER);
    text("X", panelX + panelW - 17, panelY + 17);

  
    fill(255, 215, 0);
    textSize(13);
    textAlign(LEFT, TOP);
    text("Sword Fragments: x" + inv.commonFragments, panelX + 20, panelY + 52);

    stroke(60, 60, 90);
    line(panelX + 10, panelY + 80, panelX + panelW - 10, panelY + 80);

    noStroke();
    fill(160);
    textSize(11);
    textAlign(CENTER, TOP);
    text("10 fragments per attempt  •  5% success chance", panelX + panelW / 2, panelY + 90);
    text("On fail: 1–10 extra fragments destroyed", panelX + panelW / 2, panelY + 106);

   
    int filled = min(10, inv.commonFragments);
    for (int i = 0; i < 10; i++) {
      boolean hasFrag = (i < filled && !state.equals("idle") || inv.commonFragments >= 10);
     
      boolean showFilled = (inv.commonFragments + (state.equals("idle") ? 0 : 10)) > i;

      stroke(showFilled ? color(255, 215, 0) : color(80, 80, 100));
      strokeWeight(1.5);
      fill(showFilled ? color(80, 65, 10) : color(30, 30, 40));
      rect(slotX[i], slotY, slotSize, slotSize, 4);

      if (showFilled) {
        fill(255, 215, 0);
        noStroke();
        rect(slotX[i] + 8, slotY + 8, slotSize - 16, slotSize - 16, 2);
      }
    }

   
    float cx = panelX + panelW / 2;
    float cy = panelY + 310;


    noFill();
    stroke(50, 50, 80);
    strokeWeight(2);
    ellipse(cx, cy, 110, 110);

    if (state.equals("spinning")) {
      float elapsed  = millis() - spinStart;
      float progress = elapsed / spinDuration;
      float spd      = lerp(0.03, 0.25, progress);
      spinAngle += spd;

  
      float ox = cx + cos(spinAngle) * 55;
      float oy = cy + sin(spinAngle) * 55;
      noStroke();
      fill(255, 215, 0);
      ellipse(ox, oy, 16, 16);

      float pulse = sin(millis() * 0.01) * 10 + 20;
      fill(255, 215, 0, 60);
      ellipse(cx, cy, pulse * 2, pulse * 2);

    } else if (state.equals("success")) {
      fill(80, 255, 120);
      textSize(16);
      textAlign(CENTER, CENTER);
      text("SUCCESS!", cx, cy);
    } else if (state.equals("fail")) {
      fill(255, 80, 80);
      textSize(16);
      textAlign(CENTER, CENTER);
      text("FAILED", cx, cy);
    } else {
      fill(100);
      textSize(12);
      textAlign(CENTER, CENTER);
      text("Ready", cx, cy);
    }

    for (CraftingParticle p : particles) p.display();

  
    float btnX = panelX + panelW / 2 - 70;
    float btnY = panelY + 380;
    boolean canCraft = inv.commonFragments >= 10 && state.equals("idle");
    fill(canCraft ? color(60, 160, 80) : color(50, 50, 60));
    noStroke();
    rect(btnX, btnY, 140, 40, 6);
    fill(canCraft ? color(255) : color(100));
    textSize(14);
    textAlign(CENTER, CENTER);
    text(state.equals("spinning") ? "Crafting..." : "CRAFT  (10x)", btnX + 70, btnY + 20);

   
    noStroke();
    fill(160);
    textSize(11);
    textAlign(LEFT, TOP);
    text("Select tier to craft:", panelX + 20, panelY + 426);

    for (int t = 1; t <= 5; t++) {
      float tbx = panelX + 20 + (t - 1) * 88;
      float tby = panelY + 442;
      boolean selected = (t == targetTier);
      fill(selected ? color(60, 100, 160) : color(35, 35, 50));
      noStroke();
      rect(tbx, tby, 78, 34, 5);
      fill(selected ? color(255) : color(160));
      textSize(11);
      textAlign(CENTER, CENTER);
      text("Tier " + t, tbx + 39, tby + 17);
    }
  }
}
