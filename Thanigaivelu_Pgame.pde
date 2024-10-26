/*
POTION RUSH!!!
---Help the wizard find her ingredients to complete making her visibility potion.---
1. The wizard follows the direction of the mouse.
2. Upon clicking the mouse button, she can shoot spells in the direction in which it was clicked which can destroy toads in her way
3. Make the character move over the ingredients to collect them!
4. Finish all three levels! Destroy more toads to increase your score!
5. Collecting the ingredients increases the score by 10, 20 and 30 points for levels 1, 2 and 3 respectively. Destroying toads by 2 points.
6. Colliding into toads makes you lose a lifeline and decreases the score by 1. You have only 3 lifelines so be careful!
*/

//Statements to import audio files
import ddf.minim.*;
Minim minim;
AudioPlayer introMusic, gameMusic, spellSound, collisionSound, collectSound, loseMusic, winMusic;

//Game setup
int width = 800;
int height = 800;

//variables to import images into the game
PImage wLeft, wSpellLeft, wRight, wSpellRight, spellImg, t1Left, t1Right, t2Left, t2Right, crystalImg, featherImg, plantImg;
//variables to change the lifeline images
PImage live1, live2, live3;
//variables to import images for the different screens
PImage introScreen, levelOne, levelTwo, levelThree, loseScreen, winScreen;
//to import font
PFont pixelFont;

//to keep track of the direction
int dir;

//to track the x and y positions of spells
float xShoot = 0, yShoot = 0;

//to track the score
int score;

//to keep track of the lives
int lives;

//to track the levels
int level = 0;
//to keep track of the number of times mouse is clicked
int count = 0;
//to check if the wizard is shooting a spell or not
boolean shootWizard = false;

boolean startGame = false; //to determine when the game starts
boolean gameOver = false; //to track if the game is over
boolean shotToad = false; //to check if a toad has been shot
boolean touch = false; //to check if the wizard has touched the toad

//Creating the character
Wizard w1 = new Wizard(width-50, (height/2)-50, 1);

//Creating an array list to shoot spells from the character
ArrayList<Spell> spells = new ArrayList<Spell>();

//image array to store the 4 different orientations of 2 different images of toads
PImage[] toadImg = new PImage[4];

//Creating 3 different toad arrays to display for the 3 different levels
Toad[] toads = new Toad[3]; //Level 1 would spawn 3 toads
Toad[] toads2 = new Toad[6]; //Level 2 would spawn 6 toads
Toad[] toads3 = new Toad[10]; //Level 3 would spawn 10 toads

//Creating the different ingredients that the wizard has to pick up
Ingredient i1 = new Ingredient(); //Ingredient to collect in Level 1
Ingredient i2 = new Ingredient(); //Ingredient to collect in Level 2
Ingredient i3 = new Ingredient(); //Ingredient to collect in Level 3

void setup(){
  size(800, 800); //setting up the canvas size
  //levelSetup(1);
  
  //importing the images into the variables
  wLeft = loadImage("wizardLeft.png");
  wSpellLeft = loadImage("wizardSpellLeft.png");
  wRight = loadImage("wizardRight.png");
  wSpellRight = loadImage("wizardSpellRight.png");
  spellImg = loadImage("spellLeft.png");
  t1Left = loadImage("toad1Left.png");
  t1Right = loadImage("toad1Right.png");
  t2Left = loadImage("toad2Left.png");
  t2Right = loadImage("toad2Right.png");
  crystalImg = loadImage("crystal.png");
  featherImg = loadImage("feather.png");
  plantImg = loadImage("plant.png");
  live1 = loadImage("heart1.png");
  live2 = loadImage("heart2.png");
  live3 = loadImage("heart3.png");
  introScreen = loadImage("introScreen.png");
  levelOne = loadImage("Level1.png");
  levelTwo = loadImage("Level2.png");
  levelThree = loadImage("Level3.png");
  loseScreen = loadImage("loseScreen.png");
  winScreen = loadImage("winScreen.png");
  toadImg[0] = t1Left;
  toadImg[1] = t1Right;
  toadImg[2] = t2Left;
  toadImg[3] = t2Right;
  pixelFont = createFont("Early GameBoy.ttf", 32);
  
  minim = new Minim(this);
  //importing the audio files
  introMusic = minim.loadFile("introMusic.mp3");
  gameMusic = minim.loadFile("gamePlay.mp3");
  spellSound = minim.loadFile("spell.wav");
  collisionSound = minim.loadFile("collision.mp3");
  collectSound = minim.loadFile("collect.mp3");
  loseMusic = minim.loadFile("loseGame.mp3");
  winMusic = minim.loadFile("winGame.mp3");

}

void draw(){
  
  //to check the levels 
  if(level==0 || level ==4 || level ==5){
    
    //screens for non-game screens
    if(level==0){
    image(introScreen, 0, 0);
    //playing intro music
    if(!introMusic.isPlaying() && startGame == false){
      introMusic.rewind();
      introMusic.play();
    }
    count = 0;
}
  else if(level == 4){
    //takes care of the code for when the player wins the game
    background(0);
    image(winScreen, 0, 0); //display the winning screen
    textAlign(CENTER); // aligning the text to the center
    textFont(pixelFont); //using custom font
    textSize(32);  // setting the text size to 32
    fill(#FFFFFF); //setting text color to white
    text("Your score is:"+score, width/2, height/2); //displaying score
    if(!winMusic.isPlaying() && startGame == false){
      //playing the background music when the player wins the game
      winMusic.rewind();
      winMusic.play();
    }
    //reinitializing mouse pressed count number to 0 in case the player wants to restart the game 
    count = 0;
}
  else if(level==5){
    //takes care of the code for when the player loses the game
    background(0);
    image(loseScreen, 0, 0);
    textAlign(CENTER); // aligning the text to the center
    textFont(pixelFont); //using custom font
    textSize(32);  // setting text size to 32
    fill(#FFFFFF);  // setting text color to white
    text("Your score is:"+score, width /2, height/2);  // displaying the score
    if(!loseMusic.isPlaying() && startGame == false){
      //playing the background music when the player loses the game
      loseMusic.rewind();
      loseMusic.play();
    }
    //reinitializing mouse pressed count number to 0 in case the player wants to restart the game 
    count = 0;
    }
  }
  //block of code that takes care of the levels in the actual game rather than just the screens
  else{
  fill(#FFFFFF);
  background(#cacf97);
  winMusic.pause(); //pausing the winning game music
  loseMusic.pause(); //pausing the losing game music
  gameMusic.play(); //playing the game background music
  introMusic.close(); //stopping the intro music
  
  //block of code that takes care of the first level
  if(level == 1){
    image(levelOne, 0, 0); //display background for level 1
    i1.displayIngredient(); //display the first ingredient to collect i.e. crystal
    //for loop to display and check if toads have been touched in level one
    for(int i =0; i<3; i++){
      toads[i].displayToad();
      toads[i].checkTouchToad();
    }
    
    //code to check if the ingredient has been collected
    float dIng = dist(i1.ingX, i1.ingY, w1.xPos, w1.yPos);
    if(i1.ingActive && dIng<50){
    i1.ingActive = false;
    score += 10; //increase score by 10
    collectSound.rewind(); //use the collect sound audio
    collectSound.play();
    level++; //increase the level once the ingredient has been collected
    levelSetup(2); //call the level setup function
    }
  }
  
  //code to check if the ingredient has been collected
  else if(level == 2){
    image(levelTwo, 0, 0); //display background for level 2
    i2.displayIngredient(); //display the second ingredient to collect i.e. feather
    //for loop to display and check if toads have been touched in level two
    for(int i =0; i<6; i++){
      toads2[i].displayToad();
      toads2[i].checkTouchToad();
    }
    
    //code to check if the ingredient has been collected
    float dIng = dist(i2.ingX, i2.ingY, w1.xPos, w1.yPos);
    if(i2.ingActive && dIng<50){
    i2.ingActive = false;
    score+=20; //increase score by 20
    collectSound.rewind();
    collectSound.play();
    level++;
    levelSetup(3); //call the level setup function
    }
  }
  
  //code to check if the ingredient has been collected
   else if (level ==3){
     image(levelThree, 0, 0); //display background for level 2
     i3.displayIngredient();  //display the third ingredient to collect i.e. plant
     //for loop to display and check if toads have been touched in level three
     for(int i=0; i<10; i++){
       toads3[i].displayToad();
       toads3[i].checkTouchToad();
     }
     //code to check if the ingredient has been collected
      float dIng = dist(i3.ingX, i3.ingY, w1.xPos, w1.yPos);
      if(i3.ingActive && dIng<50){
      i3.ingActive = false;
      score+=30;
      startGame = false; //game has ended
      collectSound.rewind();
      collectSound.play();
      level = 4;
      gameMusic.pause(); //pausing the general game background music
      }
   }
   
   //checking if the player has lost the game by having lost all three lives
   if(lives==0){
    startGame = false;
    gameMusic.pause();
    level = 5;
  }
  
  //to shoot the spells, adding a new object to the ArrayList
  for(Spell s1 : spells){
    s1.displaySpell();
    s1.moveSpell();
  }
  
  //code to check when to remove a spell that has been fired, i.e. when it reaches a certain amount of pixels, it would get removed
  for(int i = spells.size()-1; i>=0; i--)
  {
    Spell s1 = spells.get(i);
     if(s1.removeSpell == true){
      spells.remove(s1);
    }
    xShoot = s1.xSpell;
    yShoot = s1.ySpell;
  }
  displayScore(); //calling the function to display the score
  w1.drawCharacter(); //calling the function to draw the wizard character
  w1.direction(); //calling the function to update the movement of the wizard character
  w1.updateBlinking(); //calling the function to show character blinking when she touches the toad
  }
}

void levelSetup(int lv){
  //function that takes care of the setting up of levels
  if(lv ==1){
    for(int i  = 0; i<3; i++){
    toads[i] =  new Toad(); //create 3 toads for level 1
    println("Level 1 intialized");
    }
    i1.ingActive = true; //making ingredient 1 active
    //resetting the character's position
    w1.xPos = width-50;
    w1.yPos = (height/2)-50;
  }
  
  else if(lv ==2){
    for(int i = 0; i<6; i++){
    toads2[i] = new Toad(); //create 6 toads for level 2
    println("Level 2 initialized");
    }
    i2.ingActive = true; //making ingredient 2 active
    //resetting the character's position
    w1.xPos = width-50;
    w1.yPos = (height/2)-50;
  }
  
  else if(lv ==3){
    for(int i =0; i<10; i++){
    toads3[i] = new Toad(); //create 10 toads for level 3
    println("Level 3 initialized");
    }
    i3.ingActive = true; //making ingredient 2 active
    //resetting the character's position
    w1.xPos = width-50;
    w1.yPos = (height/2)-50;
  }
}

void displayScore(){
  textAlign(RIGHT); // aligning the text to the right
  textSize(32);  // setting text size to 32
  fill(#FFFFFF);  // setting text color to white
  textFont(pixelFont); // using custom font
  text("Score:"+score, width - 50, 70);  // displaying the score at the top-right corner of the canvas
  
  //displaying the images for the lifelines
  if(lives == 3)
  image(live3, 50, 30);
  else if (lives == 2)
  image(live2, 50, 30);
  else if (lives == 1)
  image(live1, 50, 30);
}

void mouseClicked()
{
  //function to keep track of when the mouse is clicked
  count++;
  if(count == 1){
  //to signify that the game has begun
  startGame = true;
  lives = 3;
  score = 0;
  level =1;
  levelSetup(1);
  if(level == 0)
  introMusic.close();
  else if (level == 4)
  winMusic.close();
  else if(level == 5)
  loseMusic.close();
  }
  else if (count>1){
  //mouse clicks after the game has begun 
  spellSound.rewind();
  spellSound.play();
  shootWizard = true;
  spells.add(new Spell(w1.xPos, w1.yPos, 8));
  }
}

//class that takes care of the main character
class Wizard{
  float velocity; //to take care of the velocity of the character's movement
  float xPos, yPos;
  boolean isBlinking = false; //to take care of the animation when the character collides with toads
  int blinkTimer = 0; //blinking animation timing
  int blinkDuration = 3000;
  
  //wizard class constructor
  Wizard(float x, float y, float v){
    velocity = v;
    xPos = x;
    yPos = y;
  }
  
  void drawCharacter(){
    //to draw the character when she collides with the toad
    if(isBlinking){
      int currentTimeWizard = millis();
      //calculating the amount of time when the character displays and then disappears to give a blinking animation
      if((currentTimeWizard - blinkTimer)% 500 < 250){
        fill(255);
        //takes care of the orientation of the character 
        if(shootWizard){
          if(mouseX>xPos){
        //right
        image(wSpellRight, xPos, yPos);
      }
        else if(mouseX<xPos){
        //left
        image(wSpellLeft, xPos, yPos);
      }
      else
      image(wSpellLeft, xPos, yPos);
          
        }
        else{
        if(mouseX>xPos){
        //right
        image(wRight, xPos, yPos);
      }
        else if(mouseX<xPos){
        //left
        image(wLeft, xPos, yPos);
      }
      else
      image(wLeft, xPos, yPos);
      //circle(xPos, yPos, 50);
        //circle(xPos, yPos, 50);
      }
      }
    }
    else
    { //when the character is not blinking i.e. during normal times
      if(shootWizard){
          if(mouseX>xPos){
        //right
        image(wSpellRight, xPos, yPos);
      }
        else if(mouseX<xPos){
        //left
        image(wSpellLeft, xPos, yPos);
      }
      else
      image(wSpellLeft, xPos, yPos);
      }
      
      else{
      if(mouseX>xPos){
        //right
        image(wRight, xPos, yPos);
      }
      else if(mouseX<xPos){
        //left
        image(wLeft, xPos, yPos);
      }
      else
      image(wRight, xPos, yPos);
      //circle(xPos, yPos, 50);
    }
  }
  }
  
  void startBlinking(){
    //function that takes care of starting the blinking animation
    isBlinking = true;
    blinkTimer = millis();
  }
  
  void updateBlinking(){
    //function that takes care of updating the blinking animation i.e. when the blinking is in process
    if(isBlinking && millis() - blinkTimer >= blinkDuration){
      isBlinking = false;
    }
  }
  
  //function that takes care of the direction of the wizard
  void direction(){
    if(startGame){
      if(mouseX>xPos){
        //right
        xPos +=velocity;
        dir=0;
      }
      else if(mouseX<xPos){
        //left
        xPos -= velocity;
        dir = 1;
      }
      if(mouseY>yPos){
        //down
        yPos += velocity;
        dir = 2;
      }
      else if(mouseY<yPos){
        //up
        yPos -= velocity;
        dir = 3;
      }
      //takes care of the movement of the character
      if(xPos<0)
      xPos += 5;
      if(xPos>width)
      xPos -= 5;
      if(yPos<0)
      yPos += 5;
      if(yPos>height)
      yPos -= 5;
    }
  }
}

//class that takes care of the spell that the wizard shoots
class Spell{
  float xSpell, ySpell, velSpell;
  float initialX, initialY; //to store the beginning points of the spells
  boolean removeSpell = false; //to denote when to remove a spell from the ArrayList
  float distance; //to determine the distance that the spell has travelled
  int directionSpell; //to determine in which direction the spell has been fired from 
  
  Spell(float x, float y, float v){
    //constructor
    this.xSpell = x;
    this.ySpell = y;
    initialX = x;
    initialY = y;
    this.velSpell = v;
    this.distance = 0;
    if(mouseY<this.initialY-80){
        //up
        directionSpell = 0;
      }
      else if(mouseY>this.initialY+80){
        //down
        directionSpell = 1;
      }
      else if (mouseX<this.initialX-80){
        //left
        directionSpell = 2;
      }
      else if (mouseX>this.initialX+80){
        //right
        directionSpell = 3;
      }
  }
    void displaySpell(){
      
      //function to display the spell
      image(spellImg, xSpell, ySpell);
    }
    
    void moveSpell(){
      //switch case to check in which direction the spell moves
      switch(directionSpell){
        case 0: this.ySpell -=this.velSpell;
                break;
        case 1: this.ySpell += this.velSpell;
                break;
        case 2: this.xSpell -= this.velSpell;
                break;
        case 3: this.xSpell += this.velSpell;
                break;
        default: this.xSpell -= this.velSpell;
                break;
      }
      
      //updating the movement of the spell
      this.distance +=this.velSpell;
      
      //to check if a spell has collided with a toad
      if(this.distance>width/2 || shotToad == true){
      this.removeSpell = true;
      shootWizard = false;
      shotToad = false;
      }
    }
  }
  
//toad class to take care of the creation of toads
class Toad{
  float toadX, toadY;
  int randToad=0; //random variable to randomly choose one of the 4 orientations of the 2 types of toads available to spawn them
  boolean active = true; //to check if a toad is active or not
  boolean touchToad = false; //to check if a toad has been touched by the wizard or not
  int cooldownTime = 3000, lastTouchedTime = 0; //to give a cooldown time for the wizard after touching a toad
  float startY, speed = 1, moveRange = 5; //to spawn them and make them move around on the screen
  int movement = 1; //speed that the toad moves in 
  
  Toad(){
    //toad constructor
    this.toadX = random(50, width - 50);
    this.toadY= random(50, height -20);
    this.randToad = int(random(0,4));
    this.startY = this.toadX;
  }
  
  void displayToad(){
    //function to display the toad
    this.toadY +=this.movement*this.speed; //toad moving
    
    //for up and down movements of the toad
    
    if(this.toadY>this.startY + this.moveRange){
      this.movement = -1;
    }
    else if(this.toadY<this.startY - this.moveRange){
      this.movement = 1;
    }
    
    //to check if a toad has been shot by a spell or not, deactivate if a spell has touched the toad
    float d = dist(this.toadX, this.toadY, xShoot, yShoot);
    if(this.active && d<50){
    score += 2;
    this.active = false;
    shotToad = true;
    }

    if(this.active){
      fill(#008000);
      stroke(0);
      image(toadImg[this.randToad], this.toadX, this.toadY); //display the toad only if it hasn't been shot by the wizard
    }
  }
  
  //to check if the wizard has collided with a toad
  void checkTouchToad(){
    float dt = dist(this.toadX, this.toadY, w1.xPos, w1.yPos);
    if(dt<50 && this.active){
      int currentTimeToad = millis();
      if(currentTimeToad - lastTouchedTime > cooldownTime){
        if(score>0)
        score--; //decreasing the score
        if(lives>0)
        lives--; //decreasing the number of lives
        lastTouchedTime = currentTimeToad;
        collisionSound.rewind(); //collision sound
        collisionSound.play();
        w1.startBlinking(); //begin blinking animation of character which also signifies the cooldown time
      }
      }
  }
}

//class ingredient that takes care of the ingredients the wizard has to collect
class Ingredient{
  float ingX, ingY; //to store the locations of the ingredient
  boolean ingActive = true;
  
  Ingredient(){
    
    //randomly spawn them on the screen
    ingX = random(50, width-50);
    ingY = random(50, height-50);
  }
  
  void displayIngredient(){
    if(ingActive){
      
      //display the appropriate ingredients as per the level
      
      if(level ==1)
      image(crystalImg, ingX, ingY);
      
      else if (level == 2)
      image(featherImg, ingX, ingY);
      
      else if (level ==3)
      image(plantImg, ingX, ingY);
    }
   }
}
