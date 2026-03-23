
class WaveBar {

  float x, y, w, h;
  float   fillRatio = 0;
  boolean spawning  = false;

  WaveBar(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void setCountdown(float elapsed, float interval) {
    spawning  = false;
    fillRatio = constrain(elapsed / interval, 0, 1);
  }

  void setSpawning(int spawned, int total) {
    spawning  = true;
    fillRatio = (total > 0) ? constrain((float) spawned / total, 0, 1) : 1;
  }

  void display(int waveNumber, boolean waveInProgress, int waveInterval) {
    noStroke();
    fill(60);
    rect(x, y, w, h, 4);

    fill(spawning ? color(255, 80, 80) : color(80, 200, 120));
    rect(x, y, w * fillRatio, h, 4);

    stroke(160);
    strokeWeight(1.5);
    noFill();
    rect(x, y, w, h, 4);

    fill(255);
    noStroke();
    textSize(13);
    textAlign(CENTER, CENTER);

    String label;
    if (waveNumber == 0) {
      label = "First wave incoming...";
    } else if (waveInProgress) {
      label = "Wave " + waveNumber + " in progress";
    } else {
      int secsLeft = ceil((1 - fillRatio) * (waveInterval / 1000.0));
      label = "Next wave in " + secsLeft + "s  (Wave " + (waveNumber + 1) + ")";
    }
    text(label, x + w / 2, y + h / 2);
  }
}
