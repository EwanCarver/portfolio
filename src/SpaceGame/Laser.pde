class Laser {
  // Member Variables
  int x, y, w, h, speed;
  PImage l1;
 Gif laserGif;
 
  // Constructor
  Laser(int x, int y, PApplet parent) {
    this.x = x;
    this.y = y;
    w = 70;
    h = 10;
    speed = 14;
    
    laserGif = new Gif(parent, "laser.gif");
    laserGif.play();
  }
  // Member Methods
  void move() {
    y = y-speed;
  }

  void display() {
    
    displayGif();
  }
  
  void displayGif() {
    image(laserGif,x,y,w,w);
  }

  void fire() {
  }

  boolean reachedTop() {
    if (y<-20) {
      return true;
    } else {
      return false;
    }
  }

  boolean intersect(Rock r) {
    float d = dist(x, y, r.x, r.y );
    if (d<w/2+r.w/2) {
      return true;
    } else {
      return false;
    }
  }
}
