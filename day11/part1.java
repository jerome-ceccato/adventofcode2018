import java.awt.Point;

public class part1 {
  private static int powerLevelAt(int x, int y, int GSN) {
    int rackID = x + 10;
    int powerLevel = (rackID * y + GSN) * rackID;

    return ((powerLevel % 1000) / 100) - 5;
  }

  private static void populateMap(int[][] map, int GSN) {
    for (int x = 0; x < 300; x++) {
      for (int y = 0; y < 300; y++) {
        map[x][y] = powerLevelAt(x, y, GSN);
      }
    }
  }

  private static int squarePowerAt(int x, int y, int[][] map) {
    int total = 0;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        total += map[x + i][y + j];
      }
    }
    return total;
  }

  private static Point solve(int[][] map) {
    int highest = Integer.MIN_VALUE;
    int targetX = 0, targetY = 0;

    for (int x = 0; x < 300 - 2; x++) {
      for (int y = 0; y < 300 - 2; y++) {
        int current = squarePowerAt(x, y, map);

        if (current > highest) {
          highest = current;
          targetX = x;
          targetY = y;
        }
      }
    }
    return new Point(targetX, targetY);
  }

  public static void main(String[] args) {
    int[][] map = new int[300][300];
    int GSN = 9110;

    populateMap(map, GSN);
    System.out.println(solve(map));
  }
}
