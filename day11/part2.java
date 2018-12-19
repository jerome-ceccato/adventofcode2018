import java.awt.Point;

public class part2 {
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

  private static int squarePowerAt(int x, int y, int[][] map, int squareSize) {
    int total = 0;

    for (int i = 0; i < squareSize; i++) {
      for (int j = 0; j < squareSize; j++) {
        total += map[x + i][y + j];
      }
    }
    return total;
  }

  private static Point solveMap(int[][] map, int squareSize) {
    int highest = Integer.MIN_VALUE;
    int targetX = 0, targetY = 0;

    for (int x = 0; x < 300 - (squareSize - 1); x++) {
      for (int y = 0; y < 300 - (squareSize - 1); y++) {
        int current = squarePowerAt(x, y, map, squareSize);

        if (current > highest) {
          highest = current;
          targetX = x;
          targetY = y;
        }
      }
    }
    return new Point(targetX, targetY);
  }

  private static void solve(int GSN) {
    int highest = Integer.MIN_VALUE;
    Point targetPoint = new Point(0, 0);
    int targetSize = 0;

    for (int size = 1; size <= 300; size++) {
      System.out.println(size);
      int[][] map = new int[300][300];
      populateMap(map, GSN);
      Point p = solveMap(map, size);

      int current = squarePowerAt(p.x, p.y, map, size);
      if (current > highest) {
        highest = current;
        targetPoint = p;
        targetSize = size;
      }
    }

    System.out.println(targetPoint);
    System.out.println(targetSize);
  }

  public static void main(String[] args) {
    solve(9110);
  }
}
