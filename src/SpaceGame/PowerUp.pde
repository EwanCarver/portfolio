class PowerUp {
  // Member Variables
  int x, y, w, speed;
  char type;
  color c1;
  PImage pow;

  // Constructor
  PowerUp() {
    x = int(random(width));
    y = -100;
    w = 60;
    speed = 3;
    if (random(10)>7) {
      //  r = loadImage("Rock01.png");
      type = 'H';
        pow = loadImage("healpower.png");
    } else if (random(10)>5) {
      //  r = loadImage("Rock02.png");
      type = 'T';
        pow = loadImage("gearpower.png");
    } else {
      //  r = loadImage("Rock03.png");
      type = 'A';
        pow = loadImage("bulletpower.png");
    }
  }
  // Member Methods
  void move() {
    y = y+speed;
  }

  void display() {
    imageMode(CENTER);
   image(pow, x, y, w, w);
    //r.resize(w,w);
    //image(r,x,y);
  }

  boolean intersect(SpaceShip ship) {
    float d = dist(x, y, ship.x, ship.y );
    if (d<w/2+ship.w/2) {
      return true;
    } else {
      return false;
    }
  }

  boolean reachedBottom() {
    if (y>height+w+5) {
      return true;
    } else {
      return false;
    }
  }
}
