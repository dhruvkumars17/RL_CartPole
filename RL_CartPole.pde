import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;

VerletPhysics2D physics;

Bar bar;
Cart cart;

//2 weights for 2 parameters
float w1, w2;
float p1, p2;

//bias
float bias = 0.0;

//the game resets after this number of frames
int oneCycle = 1000;

//the current frame of the round
int currentFrame = 0;

//number of games played already
int cyclesDone = 0;

//rewards will be given every time, depending on the performance of the agent
long rewards;

//keeping track of the best played game
long highScore = 0;
float bestW1 = 0;
float bestW2 = 0;
float bestBias = 0.0;

//if the ball down, reset the game anyway
boolean reset = false;

//decides if the agent is exploring or trying to perform the best
int explore = 1; //-1 is exploit

void setup() {
  size(800, 360);
  // Initialize the physics world
  physics=new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior2D(new Vec2D(0, 0.2)));
  //physics.setWorldBounds(new Rect(0, 0, width, height));

  //Initialize the cart
  PVector cartPos = new PVector(width/2, height-10);
  cart = new Cart(cartPos, 100, 40);

  // Initialize the bar
  PVector barEnd = new PVector(width/2, 150);
  bar = new Bar(barEnd, cart.pos, 20);
  
  fill(127);
  stroke(0);
  strokeWeight(2);
  
  //force the initial values (to debug and issue with toxilibs)
  bar.tail.y = 150;
  bar.head.y = cartPos.y;
}

void draw() {
  //Run this loop to reset the game
  if ((currentFrame == oneCycle) || (reset == true)) {
    
    //increment the number of games done
    cyclesDone++;
    
    //compare the current score with high score
    if (highScore < rewards) {
      highScore = rewards;
      bestW1 = w1;
      bestW2 = w2;
      bestBias = bias;
    }
    
    // Print details
    println("Round " + cyclesDone);
    println("Rewards gained = " + rewards);
    println("Best Score = " + highScore);
    println("best w1 = " + bestW1);
    println("best w2 = " + bestW2);
    println("best Bias = " + bestBias);
    if (explore == 1) println("Mode = explore");
    else println("Mode = exploit");
    
    //Reset everything
    currentFrame = 0;
    rewards = 0;
    PVector cartPos = new PVector(width/2, height-10);
    cart = new Cart(cartPos, 100, 40);

    PVector barEnd = new PVector(width/2, 150);
    bar = new Bar(barEnd, cart.pos, 20);
    bar.tail.y = 150;
    bar.tail.x = random((width/2-20), width/2+20);
    bar.head.y = cartPos.y;
    reset = false;

    //assign new weights (depending on the nature of the agent)
    if (explore == 1) {
      w1 = random(-1, 1);
      w2 = random(-1, 1);
      bias = random(-1000, 1000);
    } else {
      w1 = bestW1;
      w2 = bestW2;
      bias = bestBias;
    }
  }
  
  //white background if agent is exploring. Grey if performing
  if (explore == 1)
    background(255);
  else
    background(210, 210, 210);

  // Update physics
  physics.update();
  bar.update(cart.pos);

  //GET PARAMETERS (initial bias inherited)
  p1 = cart.pos.x - width/2;
  p2 = degrees(bar.connect) - 90;

  //GET SUM
  float sumParameters = p1*w1 + p2*w2;
  int action;

  //ACT
  if (sumParameters < 0) action = 0;
  else action = 1;
  
  if (action == 0)
    cart.pos.x += 2;
  else
    cart.pos.x -= 2;

  //REWARD POLICY
  if (p2 == 90) rewards += 5;
  else if ((p2<15) && (p2>-15)) rewards += 1;

  // Display chain
  bar.display();
  cart.display();
  currentFrame++;
  if ((p2>90) || (p2<-90) || (cart.pos.x > width-10) || (cart.pos.x < 10)) reset = true;
  //delay(1);
}

void keyPressed() {
  //Swap between exploitative and exploring agents
  if (key == 's') {
    explore *= -1;
  }
}