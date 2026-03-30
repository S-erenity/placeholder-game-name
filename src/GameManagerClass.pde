//gamemanager class

class GameManager {

  final int MAP_X = 50,  MAP_Y = 50;
  final int MAP_W = 800, MAP_H = 560;

  int     waveNumber     = 0;
  int     enemiesPerWave = 3;
  int     waveInterval   = 8000;
  int     lastWaveTime   = -8000;
  boolean waveInProgress = false;
  int     enemiesSpawned = 0;
  int     spawnDelay     = 800;
  int     lastSpawnTime  = 0;

  Player           player;
  ArrayList<Enemy> enemies;
  ArrayList<Loot>  loots;
  Boss             boss;

  WaveBar      waveBar;
  ScoreManager scoreManager;
  Inventory    inventory;
  CraftingMenu craftingMenu;

  float btnInvX, btnCraftX, btnY, btnW, btnH;

  GameManager() {
    player       = new Player(MAP_X + MAP_W / 2, MAP_Y + MAP_H / 2,
                              MAP_X, MAP_Y, MAP_W, MAP_H);
    enemies      = new ArrayList<Enemy>();
    loots        = new ArrayList<Loot>();
    waveBar      = new WaveBar(MAP_X, MAP_Y + MAP_H + 20, MAP_W, 24);
    scoreManager = new ScoreManager();
    inventory    = new Inventory();
    craftingMenu = new CraftingMenu();

    btnW     = 120;
    btnH     = 36;
    btnY     = height - 52;
    btnInvX  = 20;
    btnCraftX = 150;
  }

  void update() {
    handleWaves();
    player.update();
    updateEnemies();
    updateBoss();
    updateLoot();

    Sword crafted = craftingMenu.update(inventory);
    if (crafted != null) {
      inventory.addSword(crafted);
    }
  }

  void updateEnemies() {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update(player);

      float dmg = player.swordDamage(e);
      if (dmg > 0) {
        e.takeDamage(dmg);
      }

      if (e.isDead()) {
        String rarity = random(1000) < 2 ? "rare" : "common";
        loots.add(new Loot(e.x, e.y, rarity));
        scoreManager.addScore(100);
        enemies.remove(i);
        continue;
      }

      if (e.hits(player)) {
        player.takeDamage(1);
        enemies.remove(i);
      }
    }
  }

  void updateBoss() {
    if (boss == null) return;

    boss.update(player);

    float dmg = player.swordDamage(boss);
    if (dmg > 0) boss.takeDamage(dmg);

    if (boss.isDead()) {
      loots.add(new Loot(boss.x, boss.y, "rare"));
      loots.add(new Loot(boss.x + 20, boss.y, "rare"));
      scoreManager.addScore(1000);
      boss = null;
      return;
    }

    if (boss.hits(player)) {
      player.takeDamage(2);
      boss = null;
    }
  }

  void updateLoot() {
    for (int i = loots.size() - 1; i >= 0; i--) {
      Loot l = loots.get(i);
      if (dist(player.x, player.y, l.x, l.y) < player.radius + 10) {
        if (l.rarity.equals("rare")) {
          inventory.addRare(1);
        } else {
          inventory.addCommon(1);
        }
        loots.remove(i);
        continue;
      }
      if (l.isExpired()) loots.remove(i);
    }
  }

  void handleWaves() {
    if (!waveInProgress) {
      float elapsed = millis() - lastWaveTime;
      waveBar.setCountdown(elapsed, waveInterval);
      if (elapsed >= waveInterval) startWave();
    } else {
      waveBar.setSpawning(enemiesSpawned, currentWaveSize());
      if (enemiesSpawned < currentWaveSize() &&
          millis() - lastSpawnTime >= spawnDelay) {
        spawnEnemy();
        lastSpawnTime = millis();
      }
    }

    if (waveInProgress && enemiesSpawned >= currentWaveSize() &&
        enemies.isEmpty() && boss == null) {
      waveInProgress = false;
      lastWaveTime   = millis();
      scoreManager.saveHighScore();
    }
  }

  void startWave() {
    waveNumber++;
    enemiesSpawned = 0;
    waveInProgress = true;
    lastSpawnTime  = millis() - spawnDelay;

    if (waveNumber % 5 == 0) {
      boss = new Boss(MAP_X + MAP_W / 2, MAP_Y + 40, MAP_X, MAP_Y, MAP_W, MAP_H, waveNumber);
    }
  }

  int currentWaveSize() {
    return enemiesPerWave + (waveNumber - 1) * 2;
  }

  void spawnEnemy() {
    float ex, ey;
    int edge = (int) random(4);
    switch (edge) {
      case 0: ex = random(MAP_X, MAP_X + MAP_W); ey = MAP_Y;           break;
      case 1: ex = random(MAP_X, MAP_X + MAP_W); ey = MAP_Y + MAP_H;   break;
      case 2: ex = MAP_X;         ey = random(MAP_Y, MAP_Y + MAP_H);   break;
      default:ex = MAP_X + MAP_W; ey = random(MAP_Y, MAP_Y + MAP_H);   break;
    }
    enemies.add(new Enemy(ex, ey, MAP_X, MAP_Y, MAP_W, MAP_H));
    enemiesSpawned++;
  }

  void handleClick(float mx, float my) {
    if (mx > btnInvX && mx < btnInvX + btnW &&
        my > btnY    && my < btnY + btnH) {
      inventory.toggle();
      craftingMenu.visible = false;
      return;
    }

    if (mx > btnCraftX && mx < btnCraftX + btnW &&
        my > btnY       && my < btnY + btnH) {
      craftingMenu.toggle();
      inventory.visible = false;
      return;
    }

    if (inventory.visible) {
      Sword recycled = inventory.handleClick(mx, my);
      if (recycled != null) {
        inventory.addCommon(recycled.recycleValue());
      }
      if (inventory.isOverPanel(mx, my)) return;

      for (int i = 0; i < inventory.swords.size(); i++) {
        float rowY = inventory.panelY + 118 + i * 52;
        if (mx > inventory.panelX + 10 && mx < inventory.panelX + inventory.panelW - 120 &&
            my > rowY && my < rowY + 42) {
          player.equipSword(inventory.swords.get(i));
          return;
        }
      }
      return;
    }

    if (craftingMenu.visible) {
      int tier = craftingMenu.handleClick(mx, my, inventory);
      if (tier > 0) {
        craftingMenu.attemptCraft(inventory, tier);
      }
      return;
    }

    player.swing();
  }

  void display() {
    drawMap();

    for (Loot l : loots)    l.display();
    for (Enemy e : enemies) e.display(player);
    if (boss != null) boss.display(player);

    player.display();
    waveBar.display(waveNumber, waveInProgress, waveInterval);
    drawHUD();

    inventory.display(player.equippedSword);
    craftingMenu.display(inventory);
  }

  void drawMap() {
    stroke(180);
    strokeWeight(3);
    fill(45);
    rect(MAP_X, MAP_Y, MAP_W, MAP_H, 6);
  }

  void drawHUD() {
    fill(255);
    noStroke();
    textSize(14);
    textAlign(LEFT, TOP);
    text("Wave: " + waveNumber, MAP_X + 6, MAP_Y + 6);
    text("Enemies: " + enemies.size(), MAP_X + 110, MAP_Y + 6);
    scoreManager.display(MAP_X + MAP_W, MAP_Y + 6);

    textAlign(RIGHT, TOP);
    fill(255, 215, 0);
    textSize(13);
    text("Fragments: x" + inventory.commonFragments, MAP_X + MAP_W, MAP_Y + 26);
    fill(80, 140, 255);
    text("Blue: x" + inventory.rareFragments, MAP_X + MAP_W, MAP_Y + 44);

    textAlign(LEFT, TOP);
    fill(200);
    textSize(12);
    text("Equipped: " + player.equippedSword.name +
         "  DMG:" + player.equippedSword.damage +
         "  SPD:" + player.equippedSword.swingCooldown + "ms",
         MAP_X + 6, MAP_Y + MAP_H + 52);

    fill(inventory.visible ? color(60, 100, 160) : color(40, 40, 60));
    noStroke();
    rect(btnInvX, btnY, btnW, btnH, 6);
    fill(255);
    textSize(13);
    textAlign(CENTER, CENTER);
    text("INVENTORY", btnInvX + btnW / 2, btnY + btnH / 2);

    fill(craftingMenu.visible ? color(60, 130, 60) : color(40, 40, 60));
    noStroke();
    rect(btnCraftX, btnY, btnW, btnH, 6);
    fill(255);
    text("CRAFTING", btnCraftX + btnW / 2, btnY + btnH / 2);
  }
}
