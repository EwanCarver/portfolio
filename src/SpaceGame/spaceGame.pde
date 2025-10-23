// Ewan Carver | 23 Sept 2025 | SpaceGame

// ** *** ATTENTION USER *** **
//
//  Make sure to add the GifAnimation and 
//  Sound libraries to run the project
//
//
//
//  To install libraries:
//
//  - Tools -> Manage Tools -> Libraries (tab)
//
//
// ** *** ************** *** **

import gifAnimation.*;
import processing.sound.*;

SoundFile crack;
SoundFile shoot;
SoundFile over;
SoundFile pickup;

SpaceShip ship;
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<PowerUp> powers = new ArrayList<PowerUp>();

int rockTime = 1500;
Timer rockTimer = new Timer(rockTime);
Timer ammoTimer = new Timer(500);
Timer healTimer = new Timer(500);
Timer powerTimer = new Timer(6000);
Timer turretTimer = new Timer(10000);
Timer difficultyTimer = new Timer(9000);

int score, rocksPassed;
float shotsFired, shotsHit, accuracy;
PImage bg, gameover, startscreen;
boolean play;

void setup() {
  pixelDensity(1);
  size(500, 500);
  
  // starting timers
  rockTimer.start();  
  ammoTimer.start();  
  healTimer.start();  
  powerTimer.start();  
  turretTimer.start();  
  difficultyTimer.start();
  
  rockTime = 1500;
  score = 0;
  rocksPassed = 0;  
  play = false;
  ship = new SpaceShip();
  
  bg = loadImage("spacebg.png");
  gameover = loadImage("GAMEoverSpace.png");
  startscreen = loadImage("StartSpace.png");

  shoot = new SoundFile(this, "laser1.wav");
  crack = new SoundFile(this, "crack1.wav");
  over = new SoundFile(this, "gameovr.wav");
  pickup = new SoundFile(this, "item1.wav");
}

void draw() {
  if (!play) {
    startScreen();
  } else {
    background(0);
    imageMode(CENTER);
    bg.resize(500, 500);
    image(bg, 250, 250);
    
    if (shotsFired>0) {
    accuracy = (shotsHit/shotsFired) * 100;
    }

  // difficulty timer 
  if (difficultyTimer.isFinished()) {
    rockTime = rockTime - 10;   
    difficultyTimer.start();
    println("Difficulty increasing");
  }
  
    //adding stars
    stars.add(new Star());

    // distribute rocks on timer
    if (rockTimer.isFinished()) {
      rocks.add(new Rock());
      rockTimer.start(rockTime);
    }
    //distributes powerups on timer
    if (powerTimer.isFinished()) {
      powers.add(new PowerUp());
      powerTimer.start();
    }
    //adds 1 ammo every half a second
    if (ammoTimer.isFinished()) {
      ship.reload();
      ammoTimer.start();
    }
    if (healTimer.isFinished()) {
      ship.heal();
      healTimer.start();
    }

    // display of stars
    for (int i = 0; i < stars.size(); i++) {
      Star star = stars.get(i);
      star.display();
      star.move();
      if (star.reachedBottom()) {
        stars.remove(star);
      }
    }

    // display of rocks
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);
      if (ship.intersect(rock)) {
        rocks.remove(rock);
        i--;

        ship.health = ship.health-20;
      }
      rock.display();
      rock.move();
      if (rock.reachedBottom()) {
        rocks.remove(rock);
        i--;
        rocksPassed++;
        ship.health = ship.health-10;
      }
    }

    // display of powerups
    for (int i = 0; i < powers.size(); i++) {
      PowerUp power = powers.get(i);
      if (power.intersect(ship)) {
                
        pickup.stop();
        pickup.play();
        
        //remove powerup
        powers.remove(power);
        //based on type, benefit user
        if (power.type == 'H') {
          ship.health+=30;
          if (ship.health>100) {
            ship.health=100;
          }
        } else if (power.type == 'T') {
          ship.turretCount+=1;
          if (ship.turretCount>3) {
            ship.turretCount=3;
          }
        } else if (power.type == 'A') {
          ship.ammo+=20;
        }
        i--;
      }
      power.display();
      power.move();
      if (power.reachedBottom()) {
        powers.remove(power);
        i--;
      }
    }




    // display of lasers
    for (int i = 0; i < lasers.size(); i++) {
      Laser laser = lasers.get(i);
      for (int j = 0; j < rocks.size(); j++) {
        Rock r = rocks.get(j);
        if (laser.intersect(r)) {

          crack.stop();
          crack.play();
          
          shotsHit += 1;
          
          r.w = r.w - 30;
          if (r.w<10) {
            rocks.remove(r);
          }

          lasers.remove(laser);
          score+=100;
        }
      }
      laser.display();
      laser.move();
      if (laser.reachedTop()) {
        lasers.remove(laser);
        i--;
      }
    }

    // turret cooldown timer
    
    if (turretTimer.isFinished()) {
      ship.turretCount--;
      turretTimer.start();
      if (ship.turretCount<1) {
        ship.turretCount=1;
      }
    }



    ship.display();
    ship.move(mouseX, mouseY);

    infoPanel();
    

    if (ship.health < 1) {
      gameOver();
    }
  }
}

void mousePressed() {
  
  if (ship.fire()) {
    
    shoot.stop();
    shoot.play();

    if (ship.turretCount == 1) {
      lasers.add(new Laser(ship.x, ship.y-70, this));
    } else if (ship.turretCount == 2) {
      lasers.add(new Laser(ship.x-10, ship.y-70, this));
      lasers.add(new Laser(ship.x+10, ship.y-70, this));
    } else {
      lasers.add(new Laser(ship.x, ship.y-70, this));
      lasers.add(new Laser(ship.x+20, ship.y-70, this));
      lasers.add(new Laser(ship.x-20, ship.y-70, this));
    }
    ship.ammo = ship.ammo-1;
    shotsFired++;
    println("Accuracy:"+ accuracy);
  }
}

void infoPanel() {
  rectMode(CENTER);
  fill(127, 127);
  rect(width/2, 25, width, 50);
  fill(220);
  textSize(30);
  text("Score: " + score, 5, 40);
  text("Rocks Passed: " + rocksPassed, 250, 40);
  textAlign(CENTER);
  text(ship.ammo, ship.x, ship.y+10);
  textAlign(LEFT);
  rect(ship.x, height-50, 100, 10);
  fill(255, 0, 50);
  rect(ship.x+ship.health/2-50, height-50, ship.health, 10);
}

void gameOver() {
   
  over.stop();
  over.play();
  
  ship.ammo = 0;
          
  image(gameover, 250, 250);
  textAlign(CENTER);
  translate(720, -150);
  rotate(radians(90));
  text("Score: " + score, 250, 250);
  textAlign(CENTER);
  noLoop();  
}

void startScreen() {
  background(0);
  fill(255);
  image(startscreen, 0, 0);
  if (mousePressed) {
    play = true;
  }
}
