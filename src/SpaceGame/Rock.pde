class Rock {
  // Member Variables
  int x, y, w, speed;
  PImage r, r2, r3;

  // Constructor
  Rock() {
    x = int(random(width));
    y = -100;
    w = int(random(10, 100));
    speed = int(random(1, 10));
    if (random(10)>7) {
      r = loadImage("Rock01.png");
    } else if (random(10)>5) {
      r = loadImage("Rock02.png");
    } else {
      r = loadImage("Rock03.png");
    }
  }
  // Member Methods
  void move() {
    y = y+speed;
  }

  void display() {
    if (w<15) {
      w=15;
    }
    r.resize(w, w);
    imageMode(CENTER);
    image(r, x, y);
  }


  boolean reachedBottom() {
    if (y>height+w+5) {
      return true;
    } else {
      return false;
    }
  }
}
