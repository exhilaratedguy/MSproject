import processing.video.*;

public class BlueColourAmount extends Filter{  
  
  public BlueColourAmount(PApplet aPa){
    myMovie = new Movie(aPa, "movie.mp4");

    //movie has to starting playing immediatly due to library-related bug
    myMovie.play();
    myMovie.volume(0);
  }
  
  
  ///Analyse the video and select which frames to turn into thumbnails
  void analyseMovie(){
    myMovie.play();
    myMovie.volume(0);
    
    //for each 2 seconds in the video
    for(float time=0.0; time<myMovie.duration(); time+=2)
    {
      int count = 0;
      myMovie.jump(time);
      
      push(); //limit the following colorMode to this region until pop()
      colorMode(HSB, 360, 100, 100);
      img = createImage(320, 240, HSB);
      img.copy(myMovie, 0, 0, 320, 240, 0, 0, 320, 240);
      img.loadPixels();
      
      for(int i=0; i<img.pixels.length; i++)
      {
        float h = hue(img.pixels[i]);
        float s = saturation(img.pixels[i]);
        float b = brightness(img.pixels[i]);
                             
        //check hue, saturation and brightness for arbitrary definition of 'blueish' colour
        if( (h > 170 || h < 260) && s > 40 && b > 40)
          count++;
      }
      
      //if more than 25% pixels are considered blue
      //AND we haven't reached the limit of thumbnails
      //AND it's not too close to last thumbnail created
      if(count > (long)(0.25*img.pixels.length) && thumbnails < MAX_THUMBNAILS && countdown == 3){
        updateThumbnailsInfo();
        countdown--;
      }
      
      if(countdown == 0){ //not too close to last thumbnail anymore -> reset counter
        countdown = 3;
      } else if(countdown != 3 && countdown != 0){
        countdown--;
      }
      
      //reset colorMode to RGB
      pop();
    }
    
    //Movie is about to be played and displayed so restart it and reset volume
    myMovie.jump(0.0);
    volume = 1;
    myMovie.volume(volume);
  }
  
  
  ///runs every frame - prints screen to display
  public void display(){
    background(235);
    textSize(26);
    text("Cenas compostas maioritariamente (25%+) por azul", 20, 30);
    textSize(14);
    text("Pressione X para voltar atrás", 20, 50);
    
    //display the video with 320x240 resolution
    image(myMovie, 20, 80, 320, 240);
    
    drawThumbnails();
    drawButtons();
  }
}
