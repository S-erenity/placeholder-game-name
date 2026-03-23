

class ScoreManager {

  int   score     = 0;
  int   highScore = 0;

  final String SAVE_FILE = "highscore.txt";

  ScoreManager() {
    loadHighScore();
  }

  void addScore(int points) {
    score += points;
    if (score > highScore) {
      highScore = score;
    }
  }

  void reset() {
    score = 0;
  }


  void saveHighScore() {
    try {
      PrintWriter writer = createWriter(SAVE_FILE);
      writer.println(highScore);
      writer.flush();
      writer.close();
      println("High score saved: " + highScore);
    } catch (Exception e) {
      println("Error saving high score: " + e.getMessage());
    }
  }

  void loadHighScore() {
    try {
      BufferedReader reader = createReader(SAVE_FILE);
      String line = reader.readLine();
      if (line != null) {
        highScore = Integer.parseInt(line.trim());
      }
      reader.close();
      println("High score loaded: " + highScore);
    } catch (Exception e) {
      println("No save file found, starting fresh.");
      highScore = 0;
    }
  }


  void display(float x, float y) {
    fill(255);
    noStroke();
    textSize(14);
    textAlign(RIGHT, TOP);
    text("Score: " + score + "   Best: " + highScore, x, y);
  }
}
