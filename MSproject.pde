import java.util.Arrays;

// variables to keep track of what screen is being displayed, used to know how to handle user inputs
private final int STATE_MENU = 0;
private final int STATE_FIRST_FILTER = 1;
private final int STATE_SECOND_FILTER = 2;
private int state = STATE_MENU;

private BlueColourAmount blueColourAmount;
private MovementAmount movementAmount;
private boolean isLoaded = false;


//!---------- PROCESSING METHODS ----------!

void setup(){
  size(1280, 720);
  blueColourAmount = new BlueColourAmount(this);
  movementAmount = new MovementAmount(this);
  
  //if movie isn't loaded, then delay 1s
  while(!isLoaded)
    delay(1);
}

void draw(){
  //always check which state we're in and show correct menu
  switch (state){
    case STATE_MENU:
      mainMenu(); break;
    case STATE_FIRST_FILTER:
      firstFilterMenu(); break;
    case STATE_SECOND_FILTER:
      secondFilterMenu(); break;
    default:
      break;
  }
}

void keyPressed(){
  //depends on which state we're in
  switch (state){
    case STATE_MENU:
      keyPressedMainMenu(); break;
    case STATE_FIRST_FILTER:
      keyPressedFirstFilter(); break;
    case STATE_SECOND_FILTER:
      keyPressedSecondFilter(); break;
    case 'x':
      exit(); break;
    default:
      break;
  }
}


/// to check if mouse is over any of the media player icons or thumbnails
void mouseMoved(){
  if(state == STATE_FIRST_FILTER){ 
    firstFilterMouseOver();
  } else if(state == STATE_SECOND_FILTER){
    secondFilterMouseOver();
  }
}


/// to check if any of the media player icons or thumbnails has been clicked
void mousePressed(){
  if(state == STATE_FIRST_FILTER){ 
    firstFilterMousePressed();
  } else if (state == STATE_SECOND_FILTER){
    secondFilterMousePressed();
  }
}


void movieEvent(Movie m){
  m.read();
  if(!isLoaded)
    isLoaded = true;
}






// !-------------------------- METHODS TO HANDLE KEY PRESSES --------------------------!

///handle the keyboard input while in the Main Menu (state 0)
void keyPressedMainMenu(){
  switch (key){
    case '1':
      state = STATE_FIRST_FILTER; //<>//
      println("clicked 1");
      movementAmount.analyseMovie();
      break;
    case '2':
      state = STATE_SECOND_FILTER;
      println("clicked 2");
      blueColourAmount.analyseMovie();
      break;
    case 'x':
      exit(); break;
    default:
      break;
  }
}


///handle the keyboard input while in MovementAmount (state 1)
void keyPressedFirstFilter(){
   switch(key){
      case 'x':
        state = STATE_MENU;
        movementAmount.myMovie.volume(0);
        movementAmount.volume = 0;
        break;
      default:
        break;
   }
}


///handle the keyboard input while in BlueColourAmount (state 2)
void keyPressedSecondFilter(){
   switch(key){
      case 'x':
        state = STATE_MENU;
        blueColourAmount.myMovie.volume(0);
        blueColourAmount.volume = 0;
        break;
      default:
        break;
   }
}











// !-------------------------- MENU METHODS --------------------------!

///display Main Menu screen
void mainMenu(){
  background(235, 235, 235);
  fill(0);
  
  textSize(32);
  text("Video Player++", 150, 100, 3);
  
  textSize(16);
  text("Pressione 1 - Movement Amount  (mudanças de cena / cenas com muito movimento)", 100, 200);
  text("Pressione 2 - Blue Colour Amount  (cenas composta maioritariamente (25%+) por azul)", 100, 220);
  
  textSize(14);
  text("(A aplicação irá utizilar o ficheiro de nome 'movie.mp4' na sua pasta 'data')", 100, 250);
  
  textSize(16);
  text("Pressione X para sair", 100, 300);
  
  textSize(13);
  text("Nota: A aplicação cria e mostra apenas as primeiras 12 thumbnails que satisfazem os requisitos.", 100, 360);
}


///display MovementAmount screen
void firstFilterMenu(){
  movementAmount.display();
}


///display BlueColourAmount screen
void secondFilterMenu(){
  blueColourAmount.display(); 
}














// !-------------------------- EXTRA METHODS --------------------------!

/// check if mouse is over the 'button' at these coordinates
boolean overButton(float x, float y, float width, float height){
  if(mouseX >= x && mouseX <= x+width &&
     mouseY >= y && mouseY <= y+height){
     return true;
  } else
    return false;
}


/// Method for 'mouseOver' the thumbnails in 'MovementAmount'
void thumbnailsFirstFilterMouseOver(){
  //cache the values to be used
  int thumbnails = movementAmount.getThumbnails();
  int MAX_THUMBNAILS = movementAmount.getMAX_THUMBNAILS();
  float THUMBN_WIDTH = (float)movementAmount.getTHUMBN_WIDTH();
  float THUMBN_HEIGHT = (float)movementAmount.getTHUMBN_HEIGHT();
  
  for(int i=0; i<thumbnails && i<MAX_THUMBNAILS; i++)
  {
    // 1st row of thumbnails
    if(i<6)
    { 
      if(overButton(20+i*(THUMBN_WIDTH+20), 100+240+20, THUMBN_WIDTH, THUMBN_HEIGHT)){
        Arrays.fill(movementAmount.thumbnailsOver, false); //set all flags to false except the one we want
        movementAmount.thumbnailsOver[i] = true;
        cursor(HAND);
        return;
      }
    }
    //2nd row of thumbnails
    else if(i>=6 && i<12)
    {
      if(overButton(20+(i-6)*(THUMBN_WIDTH+20), 100+240+20+THUMBN_HEIGHT+40, THUMBN_WIDTH, THUMBN_HEIGHT)){
        Arrays.fill(movementAmount.thumbnailsOver, false);
        movementAmount.thumbnailsOver[i] = true;
        cursor(HAND);
        return;
      }
    }
  }
  Arrays.fill(movementAmount.thumbnailsOver, false);
}



/// Method for 'mouseOver' the thumbnails in 'BlueColourAmount'
void thumbnailsSecondFilterMouseOver(){
  //cache the values to be used
  int thumbnails = blueColourAmount.getThumbnails();
  int MAX_THUMBNAILS = blueColourAmount.getMAX_THUMBNAILS();
  float THUMBN_WIDTH = (float)blueColourAmount.getTHUMBN_WIDTH();
  float THUMBN_HEIGHT = (float)blueColourAmount.getTHUMBN_HEIGHT();
  
  for(int i=0; i<thumbnails && i<MAX_THUMBNAILS; i++)
  {
    // 1st row of thumbnails
    if(i<6)
    { 
      if(overButton(20+i*(THUMBN_WIDTH+20), 100+240+20, THUMBN_WIDTH, THUMBN_HEIGHT)){
        Arrays.fill(blueColourAmount.thumbnailsOver, false); //set all flags to false except the one we want
        blueColourAmount.thumbnailsOver[i] = true;
        cursor(HAND);
        return;
      }
    }
    //2nd row of thumbnails
    else if(i>=6 && i<12)
    {
      if(overButton(20+(i-6)*(THUMBN_WIDTH+20), 100+240+20+THUMBN_HEIGHT+40, THUMBN_WIDTH, THUMBN_HEIGHT)){
        Arrays.fill(blueColourAmount.thumbnailsOver, false);
        blueColourAmount.thumbnailsOver[i] = true;
        cursor(HAND);
        return;
      }
    }
  }
  Arrays.fill(blueColourAmount.thumbnailsOver, false);
}



/// Method for 'mouseOver' when in 'MovementAmount'
void firstFilterMouseOver(){
  //cache the values to be used
  textSize(14);
  float btnXpos = 20+movementAmount.myMovie.width+45;
  float btnYpos = 80+(movementAmount.myMovie.height/2.0);
  float restartWidth = textWidth("Restart")+10;
  float backWidth = textWidth("Back")+10;
  float playWidth = textWidth("Play/Pause")+10;
  float forwardWidth = textWidth("Forward")+10;
  float soundWidth = textWidth("Sound")+10;
  float loopWidth = textWidth("Looping")+10;
  float noLoopWidth = textWidth("Not looping")+10;
  
  //over the 'Restart' button
  if ( overButton(btnXpos, btnYpos, restartWidth, 30) )
  {
    movementAmount.overRestart = true;
    cursor(HAND);
  }
  //over the 'Back' button
  else if( overButton(btnXpos+restartWidth+15, btnYpos, backWidth, 30) )
  {
    movementAmount.overBack = true;
    cursor(HAND);
  }
  //over the 'Play/Pause' button
  else if( overButton(btnXpos+restartWidth+backWidth+30, btnYpos, playWidth, 30) )
  {
    movementAmount.overPlay = true;
    cursor(HAND);
  }
  //over the 'Forward' button
  else if( overButton(btnXpos+restartWidth+backWidth+playWidth+45, btnYpos, forwardWidth, 30) )
  {
    movementAmount.overForward = true;
    cursor(HAND);
  }
  //over the 'Sound' button
  else if( overButton(btnXpos+restartWidth+backWidth+playWidth+forwardWidth+60, btnYpos, forwardWidth, 30) )
  {
    movementAmount.overSound = true;
    cursor(HAND);
  }
  //over the 'Looping' button
  else if( movementAmount.isLooping && overButton(btnXpos+restartWidth+backWidth+playWidth+forwardWidth+soundWidth+75, btnYpos, loopWidth, 30) )
  {
    movementAmount.overLoop = true;
    cursor(HAND);
  }
  //over the 'Not looping' button
  else if(!movementAmount.isLooping && overButton(btnXpos+restartWidth+backWidth+playWidth+forwardWidth+soundWidth+75, btnYpos, noLoopWidth, 30))
  {
    movementAmount.overLoop = true;
    cursor(HAND);
  }
  //not over any button
  else
  {
    movementAmount.overRestart = false;
    movementAmount.overBack = false;
    movementAmount.overPlay = false;
    movementAmount.overForward = false;
    movementAmount.overSound = false;
    movementAmount.overLoop = false;
    cursor(ARROW);
  }
  
  //check if over any thumbnails
  thumbnailsFirstFilterMouseOver();
}




/// Method for 'mouseOver' when in 'GreenColourAmount'
void secondFilterMouseOver(){
  //cache the values to be used
  textSize(14);
  float btnXpos = 20+blueColourAmount.myMovie.width+45;
  float btnYpos = 80+(blueColourAmount.myMovie.height/2.0);
  float restartWidth = textWidth("Restart")+10;
  float backWidth = textWidth("Back")+10;
  float playWidth = textWidth("Play/Pause")+10;
  float forwardWidth = textWidth("Forward")+10;
  float soundWidth = textWidth("Sound")+10;
  float loopWidth = textWidth("Looping")+10;
  float noLoopWidth = textWidth("Not looping")+10;
  
  //over the 'Restart' button
  if ( overButton(btnXpos, btnYpos, restartWidth, 30) )
  {
    blueColourAmount.overRestart = true;
    cursor(HAND);
  }
  //over the 'Back' button
  else if( overButton(btnXpos+restartWidth+15, btnYpos, backWidth, 30) )
  {
    blueColourAmount.overBack = true;
    cursor(HAND);
  }
  //over the 'Play/Pause' button
  else if( overButton(btnXpos+restartWidth+backWidth+30, btnYpos, playWidth, 30) )
  {
    blueColourAmount.overPlay = true;
    cursor(HAND);
  }
  //over the 'Forward' button
  else if( overButton(btnXpos+restartWidth+backWidth+playWidth+45, btnYpos, forwardWidth, 30) )
  {
    blueColourAmount.overForward = true;
    cursor(HAND);
  }
  //over the 'Sound' button
  else if( overButton(btnXpos+restartWidth+backWidth+playWidth+forwardWidth+60, btnYpos, forwardWidth, 30) )
  {
    blueColourAmount.overSound = true;
    cursor(HAND);
  }
  //over the 'Looping' button
  else if( blueColourAmount.isLooping && overButton(btnXpos+restartWidth+backWidth+playWidth+forwardWidth+soundWidth+75, btnYpos, loopWidth, 30) )
  {
    blueColourAmount.overLoop = true;
    cursor(HAND);
  }
  //over the 'Not looping' button
  else if(!blueColourAmount.isLooping && overButton(btnXpos+restartWidth+backWidth+playWidth+forwardWidth+soundWidth+75, btnYpos, noLoopWidth, 30))
  {
    blueColourAmount.overLoop = true;
    cursor(HAND);
  }
  //not over any button
  else
  {
    blueColourAmount.overRestart = false;
    blueColourAmount.overBack = false;
    blueColourAmount.overPlay = false;
    blueColourAmount.overForward = false;
    blueColourAmount.overSound = false;
    blueColourAmount.overLoop = false;
    cursor(ARROW);
  }
  
  //check if over any thumbnails
  thumbnailsSecondFilterMouseOver();
}




/// Method for 'mousePressed' when over thumbnails in 'MovementAmount'
void thumbnailsFirstFilterMousePressed(){
   for(int i=0; i<movementAmount.thumbnailsOver.length; i++) //find which thumbnail is behing highlighted
   {
     if(movementAmount.thumbnailsOver[i]) //if it's this one
       movementAmount.myMovie.jump(movementAmount.framesTime[i]); //jump to its according time
   }
}




/// Method for 'mousePressed' when over thumbnails in 'BlueColourAmount'
void thumbnailsSecondFilterMousePressed(){
   for(int i=0; i<blueColourAmount.thumbnailsOver.length; i++) //find which thumbnail is behing highlighted
   {
     if(blueColourAmount.thumbnailsOver[i]) //if it's this one
       blueColourAmount.myMovie.jump(blueColourAmount.framesTime[i]); //jump to its according time
   }
}



/// Methods for 'mousePressed' when in 'MovementAmount'
void firstFilterMousePressed(){
  //clicking on Restart button
  if(movementAmount.overRestart)
  {
    movementAmount.myMovie.jump(0.0);
  }
  //clicking on Back button
  else if(movementAmount.overBack)
  {
    float time = movementAmount.myMovie.time();
    movementAmount.myMovie.jump(time - 10);
  }
  //clicking on Play/Pause button
  else if(movementAmount.overPlay)
  {
    if(movementAmount.isPlaying){
      movementAmount.pause();
      movementAmount.isPlaying = false;
    } else{
      movementAmount.play();
      movementAmount.isPlaying = true;
    }
  }
  //clicking on Forward button
  else if(movementAmount.overForward)
  {
    float time = movementAmount.myMovie.time();
    movementAmount.myMovie.jump(time + 10);
  }
  //clicking on Sound button
  else if(movementAmount.overSound)
  {
    if(movementAmount.volume == 0){
      movementAmount.myMovie.volume(1);
      movementAmount.volume = 1;
    } else{
      movementAmount.myMovie.volume(0);
      movementAmount.volume = 0;
    }
  }
  //clicking on Loop button
  else if(movementAmount.overLoop)
  {
    if(movementAmount.isLooping){
      movementAmount.myMovie.noLoop();
      movementAmount.isLooping = false;
    } else{
      movementAmount.myMovie.loop();
      movementAmount.isLooping = true;
    }
  }
  
  //clicking on any of the thumbnails
  thumbnailsFirstFilterMousePressed();
}




/// Methods for 'mousePressed' when in 'BlueColourAmount'
void secondFilterMousePressed(){
  //clicking on Restart button
  if(blueColourAmount.overRestart)
  {
    blueColourAmount.myMovie.jump(0.0);
  }
  //clicking on Back button
  else if(blueColourAmount.overBack)
  {
    float time = blueColourAmount.myMovie.time();
    blueColourAmount.myMovie.jump(time - 10);
  }
  //clicking on Play/Pause button
  else if(blueColourAmount.overPlay)
  {
    if(blueColourAmount.isPlaying){
      blueColourAmount.pause();
      blueColourAmount.isPlaying = false;
    } else{
      blueColourAmount.play();
      blueColourAmount.isPlaying = true;
    }
  }
  //clicking on Forward button
  else if(blueColourAmount.overForward)
  {
    float time = blueColourAmount.myMovie.time();
    blueColourAmount.myMovie.jump(time + 10);
  }
  //clicking on Sound button
  else if(blueColourAmount.overSound)
  {
    if(blueColourAmount.volume == 0){
      blueColourAmount.myMovie.volume(1);
      blueColourAmount.volume = 1;
    } else{
      blueColourAmount.myMovie.volume(0);
      blueColourAmount.volume = 0;
    }
  }
  //clicking on Loop button
  else if(blueColourAmount.overLoop)
  {
    if(blueColourAmount.isLooping){
      blueColourAmount.myMovie.noLoop();
      blueColourAmount.isLooping = false;
    } else{
      blueColourAmount.myMovie.loop();
      blueColourAmount.isLooping = true;
    }
  }
  
    //clicking on any of the thumbnails
    thumbnailsSecondFilterMousePressed();
}
