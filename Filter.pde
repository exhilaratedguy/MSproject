import processing.video.*;

public class Filter{
  //constants about the thumbnails to be used by both filters
  protected final int THUMBN_WIDTH = 180;
  protected final int THUMBN_HEIGHT = 135;
  protected final int MAX_THUMBNAILS = 12;
  
  protected PImage img;
  protected PImage[] frames = new PImage[MAX_THUMBNAILS];
  protected float[] framesTime = new float[MAX_THUMBNAILS];
  protected int thumbnails = 0;
  protected int countdown = 3;
  
  //the following variables have to be public to be set by main class
  public Movie myMovie;
  public float volume = 0.0; 
  public boolean isPlaying = false;
  public boolean isLooping = false;

  // mouse is over icon X
  public boolean overRestart = false;
  public boolean overBack = false;
  public boolean overPlay = false;
  public boolean overForward = false;
  public boolean overSound = false;
  public boolean overLoop = false;
  public boolean[] thumbnailsOver = new boolean[12]; //default value is false
  
  /// update thumbnails arrays info (frame image + time in video)
  protected void updateThumbnailsInfo(){
    if(thumbnails >= MAX_THUMBNAILS-1) return; //if we've reached the limit of thumbnails then do nothing
    
    frames[thumbnails] = createImage(THUMBN_WIDTH, THUMBN_HEIGHT, RGB);
    frames[thumbnails].copy(myMovie,0,0,myMovie.width, myMovie.height,
                            0,0,THUMBN_WIDTH,THUMBN_HEIGHT);
    framesTime[thumbnails] = myMovie.time();
    thumbnails++;
  }
  
  /// draws the thumbnails on screen
  protected void drawThumbnails(){
    for(int i=0; i<thumbnails && i<MAX_THUMBNAILS; i++)
    {
      //get the thumbnail frame's time in video
      float time = framesTime[i];
      
      //translate it to display in 'minutes:seconds' format
      int mins = floor(time/60);
      int secs = (int)time;
      secs -= mins*60;
      String thumbTime = mins + ":" + secs;
      textSize(22);
      fill(255);
      
      if(i<6){ //1st row of thumbnails
        image(frames[i], 20+i*(THUMBN_WIDTH+20), 100+240+20);
        text(thumbTime, 5+i*(THUMBN_WIDTH+20)+(THUMBN_WIDTH/2), 100+240+20+(THUMBN_HEIGHT/2));
      }
      else{ //2nd row of thumbnails
        image(frames[i], 20+(i-6)*(THUMBN_WIDTH+20), 100+240+20+THUMBN_HEIGHT+40);
        text(thumbTime, 5+(i-6)*(THUMBN_WIDTH+20)+(THUMBN_WIDTH/2), 100+240+20+THUMBN_HEIGHT+40+(THUMBN_HEIGHT/2));
      }
    }
  }
  
  /// draws video player associated buttons
  public void drawButtons(){
    textSize(14);
    
    String btnText = "Restart";
    float btnStart = 20+myMovie.width+45;
    float btnYpos = 80+myMovie.height/2;
    float btnWidth = textWidth(btnText)+10;
    float btnHeight = 30;
    fill(215);
    rect(btnStart, btnYpos, btnWidth, btnHeight, 7);
    fill(0);
    text(btnText, btnStart+5, btnYpos+20);
    
    btnText = "Back";
    btnStart = btnStart + btnWidth + 15;
    btnWidth = textWidth(btnText)+10;
    fill(215);
    rect(btnStart, btnYpos, btnWidth, btnHeight, 7);
    fill(0);
    text(btnText, btnStart+5, btnYpos+20);
    
    btnText = "Play/Pause";
    btnStart = btnStart + btnWidth + 15;
    btnWidth = textWidth(btnText)+10;
    fill(215);
    rect(btnStart, btnYpos, btnWidth, btnHeight, 7);
    fill(0);
    text(btnText, btnStart+5, btnYpos+20);
    
    btnText = "Forward";
    btnStart = btnStart + btnWidth + 15;
    btnWidth = textWidth(btnText)+10;
    fill(215);
    rect(btnStart, btnYpos, btnWidth, btnHeight, 7);
    fill(0);
    text(btnText, btnStart+5, btnYpos+20);
    
    btnText = "Sound";
    btnStart = btnStart + btnWidth + 15;
    btnWidth = textWidth(btnText)+10;
    if(volume > 0)
      fill(170, 255, 170);
    else
      fill(255, 170, 170);
    rect(btnStart, btnYpos, btnWidth, btnHeight, 7);
    fill(0);
    text(btnText, btnStart+5, btnYpos+20);
    
    if(isLooping){
      btnText = "Looping";
      fill(170, 255, 170);
    }
    else{
      btnText = "Not looping";
      fill(255, 170, 170);
    }
    btnStart = btnStart + btnWidth + 15;
    btnWidth = textWidth(btnText)+10;
    rect(btnStart, btnYpos, btnWidth, btnHeight, 7);
    fill(0);
    text(btnText, btnStart+5, btnYpos+20);
  }
  
  public void pause(){
    myMovie.pause();
  }
  
  public void play(){
    myMovie.play();
  }
  
  public int getThumbnails(){
    return thumbnails;
  }
  
  public int getMAX_THUMBNAILS(){
    return MAX_THUMBNAILS;
  }
  
  public int getTHUMBN_HEIGHT(){
    return THUMBN_HEIGHT;
  }
  
  public int getTHUMBN_WIDTH(){
    return THUMBN_WIDTH;
  }
}
