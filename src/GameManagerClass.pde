
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

  WaveBar      waveBar;
  ScoreManager scoreManager;

  GameManager() {
    player       = new Player(MAP_X + MAP_W / 2, MAP_Y + MAP_H / 2,
                              MAP_X, MAP_Y, MAP_W, MAP_H);
    enemies      = new ArrayList<Enemy>();
    loots        = new ArrayList<Loot>();
    waveBar      = new WaveBar(MAP_X, MAP_Y + MAP_H + 20, MAP_W, 24);
    scoreManager = new ScoreManager();
  }

  void update() {
    handleWaves();
    player.update();
    updateEnemies();
    updateLoot();
  }

  void updateEnemies() {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update(player);

      // sword kill enemy = loot drop
      if (player.swordHits(e)) {
        loots.add(new Loot(e.x, e.y));
        scoreManager.addScore(100);
        enemies.remove(i);
        continue;
      }

      // enemy touch player = no loot drop
      if (e.hits(player)) {
        player.takeDamage(1);
        enemies.remove(i);
      }
    }
  }

  void updateLoot() {
    for (int i = loots.size() - 1; i >= 0; i--) {
      if (loots.get(i).isExpired()) {
        loots.remove(i);
      }
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

    if (waveInProgress && enemiesSpawned >= currentWaveSize() && enemies.isEmpty()) {
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

  void display() {
    drawMap();

    // Loot drawn first so it appears under entities
    for (Loot l : loots) {
      l.display();
    }

    for (Enemy e : enemies) {
      e.display(player);
    }

    player.display();
    waveBar.display(waveNumber, waveInProgress, waveInterval);
    drawHUD();
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
    text("Enemies alive: " + enemies.size(), MAP_X + 110, MAP_Y + 6);
    scoreManager.display(MAP_X + MAP_W, MAP_Y + 6);
  }
}
