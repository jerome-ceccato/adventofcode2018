<?php

class Car {
  var $x;
  var $y;
  var $direction;
  var $turn = -1;

  function __construct($x, $y, $direction) {
    $this->x = $x;
    $this->y = $y;

    switch ($direction) {
      case '^': $this->direction = 0; break;
      case '>': $this->direction = 1; break;
      case 'v': $this->direction = 2; break;
      case '<': $this->direction = 3; break;
    }
  }

  function move_once($track) {
    switch ($this->direction) {
      case 0: $this->y--; break;
      case 1: $this->x++; break;
      case 2: $this->y++; break;
      case 3: $this->x--; break;
    }

    switch ($track[$this->y][$this->x]) {
      case '+':
        $this->direction = ($this->direction + $this->turn + 4) % 4;
        $this->turn++;
        break;
      case '/':
        $table = [0 => 1, 1 => 0, 2 => 3, 3 => 2];
        $this->direction = $table[$this->direction];
        break;
      case '\\':
        $table = [0 => 3, 1 => 2, 2 => 1, 3 => 0];
        $this->direction = $table[$this->direction];
        break;
    }

    if ($this->turn > 1) {
      $this->turn = -1;
    }
  }
}

class Game {
  var $track;
  var $cars;

  var $line_size = 0;
  var $index = array();

  function __construct($filename) {
    $this->track = file($filename, FILE_IGNORE_NEW_LINES);
    $this->cars = array();

    $nlines = sizeof($this->track);
    for ($linei = 0; $linei < $nlines; $linei++) {
      $nchar = strlen($this->track[$linei]);
      $this->line_size = max($this->line_size, $nchar);
      for ($characteri = 0; $characteri < $nchar; $characteri++) {
        $c = $this->track[$linei][$characteri];
        if ($c === '^' || $c === 'v') {
          array_push($this->cars, new Car($characteri, $linei, $c));
          $c = '|';
        }
        else if ($c === '<' || $c === '>') {
          array_push($this->cars, new Car($characteri, $linei, $c));
          $c = '-';
        }
        $this->track[$linei][$characteri] = $c;
      }
    }

    foreach ($this->cars as $car) {
      $this->index[$this->indexOfCar($car)] = $car;
    }
  }

  function printTrack() {
    $nlines = sizeof($this->track);
    for ($linei = 0; $linei < $nlines; $linei++) {
      $nchar = strlen($this->track[$linei]);
      for ($characteri = 0; $characteri < $nchar; $characteri++) {
        $index = $linei * $this->line_size + $characteri;
        if (array_key_exists($index, $this->index)) {
          print $this->index[$index]->direction;
        }
        else {
          print $this->track[$linei][$characteri];
        }
      }
      print "\n";
    }
  }

  function indexOfCar($car) {
    return $car->y * $this->line_size + $car->x;
  }

  function updateIndexOfCar($car) {
    $oldIndex = $this->indexOfCar($car);
    if (array_key_exists($oldIndex, $this->index)) {
      unset($this->index[$oldIndex]);
    }

    $car->move_once($this->track);

    $newIndex = $this->indexOfCar($car);
    if (array_key_exists($newIndex, $this->index)) {
      return false;
    }
    else {
      $this->index[$newIndex] = $car;
      return true;
    }
  }

  function run() {
    while (true) {
      $current_keys = array_keys($this->index);
      sort($current_keys);

      foreach ($current_keys as $k) {
        $car = $this->index[$k];
        if (!$this->updateIndexOfCar($car)) {
          return $car;
        }
      }
    }
  }
}

$game = new Game('input');
$car = $game->run();
echo "$car->x,$car->y\n";

?>
