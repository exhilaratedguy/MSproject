import processing.video.*;

public class MovementAmount extends Filter{
  private PImage prv;
  
  public MovementAmount(PApplet aPa){
    myMovie = new Movie(aPa, "movie.mp4");
    
    //movie has to starting playing immediatly due to library-related bug
    myMovie.play();
    myMovie.volume(0);
  }
  
  
  ///Analyse the video and select which frames to turn into thumbnails
  void analyseMovie(){
    myMovie.play();
    isPlaying = true;
    myMovie.volume(volume);
     
    img = createImage(180, 135, RGB);
    img.loadPixels();
    for(int i=0; i<img.pixels.length; i++){
      img.pixels[i] = color(0, 0, 0);
    }
    img.updatePixels();
    
    prv = createImage(180, 135, RGB);
    prv.loadPixels();
    for(int i=0; i<prv.pixels.length; i++){
      prv.pixels[i] = color(0, 0, 0);
    }
    prv.updatePixels();
    
    //for each 2 seconds in the video
    for(float time=0.0; time<myMovie.duration(); time+=2)
    {
      int count = 0;
      myMovie.jump(time);
      
      img.copy(myMovie, 0, 0, 320, 240, 0, 0, 180,135);
      img.loadPixels();
      prv.loadPixels();
      
      //get number of how many pixels are different between frames
      count = compareFrames();
      
      //if more than 75% pixels are different
      //AND we haven't reached the limit of thumbnails
      //AND it's not too close to last thumbnail created
      if(count > (long)(75*img.pixels.length)/100 && thumbnails < MAX_THUMBNAILS && countdown == 3){ 
        updateThumbnailsInfo();
        countdown--;
      }
      
      if(countdown == 0){ //not too close to last thumbnail anymore -> reset counter
        countdown = 3;
      } else if(countdown != 3 && countdown != 0){
        countdown--;
      }
      
      prv.updatePixels();
      img.updatePixels();
      prv.copy(myMovie, 0, 0, 320, 240, 0, 0, 180, 135);
    }
    
    //Movie is about to be played and displayed so restart it and reset volume
    myMovie.jump(0.0);
    volume = 1;
    myMovie.volume(volume);
  }
  
  
  /// returns how many pixels are different from previous frame
  int compareFrames(){
    int count = 0;
    
    for(int i=0; i<img.pixels.length; i++)
    {
      img.pixels[i] = color(abs(red(img.pixels[i])-red(prv.pixels[i])),
                            abs(green(img.pixels[i])-green(prv.pixels[i])),
                            abs(blue(img.pixels[i])-blue(prv.pixels[i])));
                           
      //count how many pixels are not black (aka different from previous frame)
      if(img.pixels[i] != color(0,0,0))
        count++;
    }
    
    return count;
  }
  
  ///runs every frame - prints screen to display
  void display(){
    background(235);
    textSize(26);
    text("Mudanças de cena / cenas com muito movimento", 20, 30);
    textSize(14);
    text("Pressione X para voltar atrás", 20, 50);
    
    //display the video with 320x240 resolution
    image(myMovie, 20, 80, 320, 240);
    
    drawThumbnails();
    drawButtons();
  }
}
