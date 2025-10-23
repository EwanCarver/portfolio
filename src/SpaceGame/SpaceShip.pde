  class SpaceShip {
  // Member Variables
  int x, y, w, ammo, turretCount, health;
  PImage ship;

  // Constructor
  SpaceShip() {
    x = width/2;
    y = height/2;
    w = 100;
    ammo = 10;
    turretCount = 1;
    health = 100;
    ship = loadImage("spaceship.png");
  }
  // Member Methods
  void move(int x, int y) {
    this.x = x;
    this.y = 400;
  }

  void display() {
    imageMode(CENTER);
    ship.resize(w, w);
    image(ship, x, y);
  }

  boolean fire() {
    if (ammo>0) {
      return true;
    } else {
      return false;
    }
  }

  boolean intersect(Rock rock) {
    float d = dist(x, y, rock.x, rock.y );
    if (d<w/2+rock.w/2) {
      return true;
    } else {
      return false;
    }
  }
  void reload() {
    if (ammo<10) {
      ammo = ammo + 1;
    }
  }
  void heal() {
    if (health<50) {
      health = health + 1;
    }
  }
}
