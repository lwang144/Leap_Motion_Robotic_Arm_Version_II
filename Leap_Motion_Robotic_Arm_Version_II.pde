import de.voidplus.leapmotion.*;
import processing.opengl.*; 
import processing.serial.*;
///////////////////////////////////////////////////////////////////////////////////////////////////
LeapMotion leap;    //declare variable
Serial port;
PFont font;         //declare variable
PImage img1, img2, img3, img4, img5, img6;
int Wait1_Flag = 0, Wait2_Flag = 0;
int a=90,b=140,c=60,d = 90, e=10,f=130;
  
byte out[] = new byte[5];  
  
//Hand//
int hand_num;
PVector hand_position, hand_stabilized, hand_direction, hand_dynamics;
//Finger Direction//
PVector Thumb_direction, Index_direction, Middle_direction, Ring_direction, Pinky_direction;
//Finger Position//
PVector Thumb_position, Index_position, Middle_position, Ring_position, Pinky_position;
float   hand_grab, hand_pinch, sphere_radius,hand_roll;
Boolean Data_Flag = true;
Boolean Start_Flag = true;
//Control Data//
int Rotate_Direction, Big_Arm_Direction, Small_Arm_Direction, Wrist_Direction, Wrist_Rotation, Paw_Open;
int Rotate_Direction_Data, Big_Arm_Direction_Data, Small_Arm_Direction_Data, Wrist_Direction_Data, Wrist_Rotation_Data, Paw_Open_Data;
///////////////////////////////////////////////////////////////////////////////////////////////////
void setup()
{
  size(1024, 650, OPENGL);
  background(255);
  leap = new LeapMotion(this);
  port = new Serial(this,"com11",9600);
  font = loadFont("Serif-48.vlw");
  img1 = loadImage("Rectangle.jpg");
  img2 = loadImage("Rectangle.jpg");
  img3 = loadImage("CIT1.jpg");
  img4 = loadImage("wait1.jpg");
  img5 = loadImage("wait2.jpg");
  img6 = loadImage("wait3.jpg");
  smooth();
}
///////////////////////////////////////////////////////////////////////////////////////////////////
void draw()
{
  background(255); //reset the background to white at the beginning of each frame
  Display_Init();
  int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ())
  {
    textFont(font, 14);
    fill(0);
    //Hand
    hand_num = leap.countHands();
    hand_position     = hand.getPosition();
    hand_stabilized   = hand.getStabilizedPosition();
    hand_direction    = hand.getDirection();
    hand_dynamics     = hand.getDynamics();
    //Finger Direction
    Thumb_direction   = hand.getThumb().getDirection();
    Index_direction   = hand.getIndexFinger().getDirection();
    Middle_direction  = hand.getMiddleFinger().getDirection();
    Ring_direction    = hand.getRingFinger().getDirection();
    Pinky_direction   = hand.getPinkyFinger().getDirection();
    //Finger Position
    Thumb_position    = hand.getThumb().getPosition();
    Index_position    = hand.getIndexFinger().getPosition();
    Middle_position   = hand.getMiddleFinger().getPosition();
    Ring_position     = hand.getRingFinger().getPosition();
    Pinky_position    = hand.getPinkyFinger().getPosition();
    
    hand_grab         = hand.getGrabStrength();  
    hand_pinch        = hand.getPinchStrength();  
    sphere_radius     = hand.getSphereRadius();
    hand_roll         = hand.getRoll();
    
    if(hand_num == 1)
    {
      fill(255,0,0);
      noStroke();
      ellipse(hand_position.x,hand_position.y,35,35);
      
                                      ////Start Mode Choose////
      if((hand_position.x >= 418) && (hand_position.x <= 618) && (hand_position.y >= 300) && (hand_position.y <= 400))
      {
        if(hand_grab >= 0.5)
        {
          fill(0,255,0);
          noStroke();
          ellipse(hand_position.x,hand_position.y,35,35);  
          Wait1_Flag +=1;
          if(Wait1_Flag < 60)
            image(img4,0,0,width,height);
          if((Wait1_Flag >= 60) && (Wait1_Flag < 120))
            image(img5,0,0,width,height);
          if((Wait1_Flag >= 120) && (Wait1_Flag <= 180))
            image(img6,0,0,width,height);
          if(Wait1_Flag > 180)
          {
            Start_Flag = false;
          }
        }
      }
      
                                      ////Data Mode Choose////
      if((hand_position.x >= 418) && (hand_position.x <= 618) && (hand_position.y >= 450) && (hand_position.y <= 550))
      {
        if(hand_grab >= 0.5)
        {
          fill(0,0,255);
          noStroke();
          ellipse(hand_position.x,hand_position.y,35,35); 
          Wait2_Flag +=1;
          if(Wait2_Flag < 60)
            image(img4,0,0,width,height);
          if((Wait2_Flag >= 60) && (Wait2_Flag < 120))
            image(img5,0,0,width,height);
          if((Wait2_Flag >= 120) && (Wait2_Flag <= 180))
            image(img6,0,0,width,height);
          if(Wait2_Flag > 180)
          {
            Data_Flag = false;  
          }
        }
      }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////      
                                      ////Start Mode////
      if(Start_Flag == false)
      {
        if(hand.isRight())
        {
            background(255); 
            textFont(font, 50); 
            fill(0); 
            text("Right Hand",400,40); 
            fill(125); 
            ellipse(200,200,200,200); 
            fill(255); 
            rect(100,200,200,200); 
            fill(255,0,0); 
            ellipse(200,200,16,16); 
            textFont(font,25); 
            text("0",85,195); 
            text("180",300,195); 
            text("Basement Rotation",100,250); 
            fill(125); 
            ellipse(520,200,200,200); 
            fill(255); 
            rect(420,200,200,200); 
            fill(255,0,0); 
            ellipse(520,200,16,16); 
            text("0",405,195); 
            text("180",620,195); 
            text("Big Arm Rotation",430,250); 
            fill(125); 
            ellipse(850,200,200,200); 
            fill(255); 
            rect(750,200,200,200); 
            fill(255,0,0); 
            ellipse(850,200,16,16); 
            text("0",735,195); 
            text("180",950,195); 
            text("Small Arm Rotation",750,250); 
            fill(125); 
            ellipse(200,450,200,200); 
            fill(255); 
            rect(100,450,200,200); 
            fill(255,0,0); 
            ellipse(200,450,16,16);
            text("0",85,445); 
            text("180",300,445);  
            text("Wrist Rotation",120,500);
            fill(125); 
            ellipse(520,450,200,200); 
            fill(255); 
            rect(420,450,200,200); 
            fill(255,0,0); 
            ellipse(520,450,16,16);
            text("0",405,445); 
            text("180",620,445);  
            text("Paw Basement Rotation",400,500);
            fill(125); 
            ellipse(850,450,200,200); 
            fill(255); 
            rect(750,450,200,200); 
            fill(255,0,0); 
            ellipse(850,450,16,16);
            text("0",735,445); 
            text("180",950,445);  
            text("Paw Open",800,500); 
            /////////////////////////// 
            Rotate_Direction = int(map(hand_position.x,50,800,0,180)); 
            if(Rotate_Direction > 180) Rotate_Direction = 180;   
            if(Rotate_Direction < 0)   Rotate_Direction = 0;  
            //println(int(hand_position.x) + "  After Translation:" +Rotate_Direction);   //Show Hand's Direction Data  
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Rotate_Direction <= 90) 
              line(200,200,200-100*cos(radians(Rotate_Direction)),200-100*sin(radians(Rotate_Direction))); 
            if(Rotate_Direction > 90) 
              line(200,200,200+100*cos(radians(180-Rotate_Direction)),200-100*sin(radians(180-Rotate_Direction))); 
            //println(Rotate_Direction);
            Rotate_Direction_Data = int(map(Rotate_Direction,0,180,50,130));
            a = Rotate_Direction_Data;        //a
            //println(Rotate_Direction_Data);
            ///////////////////////////
            Big_Arm_Direction = int(map(hand_position.z,0,70,0,180));
            if(Big_Arm_Direction > 180) Big_Arm_Direction = 180;   
            if(Big_Arm_Direction < 0)   Big_Arm_Direction = 0;  
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Big_Arm_Direction <= 90) 
              line(520,200,520-100*cos(radians(Big_Arm_Direction)),200-100*sin(radians(Big_Arm_Direction))); 
            if(Big_Arm_Direction > 90) 
              line(520,200,520+100*cos(radians(180-Big_Arm_Direction)),200-100*sin(radians(180-Big_Arm_Direction))); 
            //println(Big_Arm_Direction); 
            Big_Arm_Direction_Data = int(map(Big_Arm_Direction,0,180,140,30));
            b = Big_Arm_Direction_Data;        //b
            ///////////////////////////
            Small_Arm_Direction = int(map(hand_position.y,200,500,180,0));
            if(Small_Arm_Direction > 180) Small_Arm_Direction = 180;   
            if(Small_Arm_Direction < 0)   Small_Arm_Direction = 0; 
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Small_Arm_Direction <= 90) 
              line(850,200,850-100*cos(radians(Small_Arm_Direction)),200-100*sin(radians(Small_Arm_Direction))); 
            if(Small_Arm_Direction > 90) 
              line(850,200,850+100*cos(radians(180-Small_Arm_Direction)),200-100*sin(radians(180-Small_Arm_Direction)));  
            //println(Small_Arm_Direction); 
            Small_Arm_Direction_Data = int(map(Small_Arm_Direction,10,170,70,3));
            c = Small_Arm_Direction_Data;        //c
            ///////////////////////////
            Wrist_Direction = int(map(hand_direction.y,-15,70,0,180));
            if(Wrist_Direction > 180) Wrist_Direction = 180;   
            if(Wrist_Direction < 0)   Wrist_Direction = 0;  
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Wrist_Direction <= 90) 
              line(200,450,200-100*cos(radians(Wrist_Direction)),450-100*sin(radians(Wrist_Direction))); 
            if(Wrist_Direction > 90) 
              line(200,450,200+100*cos(radians(180-Wrist_Direction)),450-100*sin(radians(180-Wrist_Direction))); 
            //println(Wrist_Direction); 
            Wrist_Direction_Data = int(map(Wrist_Direction,0,180,0,35));
            d = Wrist_Direction_Data;        //d
            ///////////////////////////
            if(hand_roll < 0)
              hand_roll = -(hand_roll);
            Wrist_Rotation = int(map(hand_roll,0,180,0,180));
            if(Wrist_Rotation > 180) Wrist_Rotation = 180;   
            if(Wrist_Rotation < 0)   Wrist_Rotation = 0;  
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Wrist_Rotation <= 90) 
              line(520,450,520-100*cos(radians(Wrist_Rotation)),450-100*sin(radians(Wrist_Rotation))); 
            if(Wrist_Rotation > 90) 
              line(520,450,520+100*cos(radians(180-Wrist_Rotation)),450-100*sin(radians(180-Wrist_Rotation))); 
            //println(hand_roll); 
            Wrist_Rotation_Data = int(map(Wrist_Rotation,10,180,180,0));
            e = Wrist_Rotation_Data;        //e
            ///////////////////////////
            Paw_Open = int(map(hand_grab * 1000,0,1000,0,180));
            if(Paw_Open > 180) Paw_Open = 180;   
            if(Paw_Open < 0)   Paw_Open = 0;  
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Paw_Open <= 90) 
              line(850,450,850-100*cos(radians(Paw_Open)),450-100*sin(radians(Paw_Open))); 
            if(Paw_Open > 90) 
              line(850,450,850+100*cos(radians(180-Paw_Open)),450-100*sin(radians(180-Paw_Open))); 
            Paw_Open_Data = int(map(Paw_Open,0,180,90,160));
            f = Paw_Open_Data;        //f
            println(Paw_Open_Data);
            send_data();
            //delay(100);
        }  
          
        if(hand.isLeft())
        {
          background(255); 
            textFont(font, 50); 
            fill(0); 
            text("Left Hand",400,40); 
            fill(125); 
            ellipse(200,200,200,200); 
            fill(255); 
            rect(100,200,200,200); 
            fill(255,0,0); 
            ellipse(200,200,16,16); 
            textFont(font,25); 
            text("0",85,195); 
            text("180",300,195); 
            text("Basement Rotation",100,250); 
            fill(125); 
            ellipse(520,200,200,200); 
            fill(255); 
            rect(420,200,200,200); 
            fill(255,0,0); 
            ellipse(520,200,16,16); 
            text("0",405,195); 
            text("180",620,195); 
            text("Big Arm Rotation",430,250); 
            fill(125); 
            ellipse(850,200,200,200); 
            fill(255); 
            rect(750,200,200,200); 
            fill(255,0,0); 
            ellipse(850,200,16,16); 
            text("0",735,195); 
            text("180",950,195); 
            text("Small Arm Rotation",750,250); 
            fill(125); 
            ellipse(200,450,200,200); 
            fill(255); 
            rect(100,450,200,200); 
            fill(255,0,0); 
            ellipse(200,450,16,16);
            text("0",85,445); 
            text("180",300,445);  
            text("Wrist Rotation",120,500);
            fill(125); 
            ellipse(520,450,200,200); 
            fill(255); 
            rect(420,450,200,200); 
            fill(255,0,0); 
            ellipse(520,450,16,16);
            text("0",405,445); 
            text("180",620,445);  
            text("Paw Basement Rotation",400,500);
            fill(125); 
            ellipse(850,450,200,200); 
            fill(255); 
            rect(750,450,200,200); 
            fill(255,0,0); 
            ellipse(850,450,16,16);
            text("0",735,445); 
            text("180",950,445);  
            text("Paw Open",800,500); 
            /////////////////////////// 
            Rotate_Direction = int(map(hand_position.x,50,800,0,180)); 
            if(Rotate_Direction > 180) Rotate_Direction = 180;   
            if(Rotate_Direction < 0)   Rotate_Direction = 0;  
            //println(int(hand_position.x) + "  After Translation:" +Rotate_Direction);   //Show Hand's Direction Data  
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Rotate_Direction <= 90) 
              line(200,200,200-100*cos(radians(Rotate_Direction)),200-100*sin(radians(Rotate_Direction))); 
            if(Rotate_Direction > 90) 
              line(200,200,200+100*cos(radians(180-Rotate_Direction)),200-100*sin(radians(180-Rotate_Direction))); 
            //println(Rotate_Direction);
            Rotate_Direction_Data = int(map(Rotate_Direction,0,180,50,130));
            a = Rotate_Direction_Data;        //a
            //println(Rotate_Direction_Data);
            ///////////////////////////
            Big_Arm_Direction = int(map(hand_position.z,0,70,0,180));
            if(Big_Arm_Direction > 180) Big_Arm_Direction = 180;   
            if(Big_Arm_Direction < 0)   Big_Arm_Direction = 0;  
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Big_Arm_Direction <= 90) 
              line(520,200,520-100*cos(radians(Big_Arm_Direction)),200-100*sin(radians(Big_Arm_Direction))); 
            if(Big_Arm_Direction > 90) 
              line(520,200,520+100*cos(radians(180-Big_Arm_Direction)),200-100*sin(radians(180-Big_Arm_Direction))); 
            //println(Big_Arm_Direction); 
            Big_Arm_Direction_Data = int(map(Big_Arm_Direction,0,180,110,40));
            b = Big_Arm_Direction_Data;        //b
            ///////////////////////////
            Small_Arm_Direction = int(map(hand_position.y,200,500,0,180));
            if(Small_Arm_Direction > 180) Small_Arm_Direction = 180;   
            if(Small_Arm_Direction < 0)   Small_Arm_Direction = 0; 
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Small_Arm_Direction <= 90) 
              line(850,200,850-100*cos(radians(Small_Arm_Direction)),200-100*sin(radians(Small_Arm_Direction))); 
            if(Small_Arm_Direction > 90) 
              line(850,200,850+100*cos(radians(180-Small_Arm_Direction)),200-100*sin(radians(180-Small_Arm_Direction)));  
            //println(Small_Arm_Direction); 
            Small_Arm_Direction_Data = int(map(Small_Arm_Direction,0,180,90,40));
            c = Small_Arm_Direction_Data;        //c
            ///////////////////////////
            Wrist_Direction = int(map(hand_direction.y,-15,70,0,180));
            if(Wrist_Direction > 180) Wrist_Direction = 180;   
            if(Wrist_Direction < 0)   Wrist_Direction = 0;  
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Wrist_Direction <= 90) 
              line(200,450,200-100*cos(radians(Wrist_Direction)),450-100*sin(radians(Wrist_Direction))); 
            if(Wrist_Direction > 90) 
              line(200,450,200+100*cos(radians(180-Wrist_Direction)),450-100*sin(radians(180-Wrist_Direction))); 
            //println(Wrist_Direction); 
            Wrist_Direction_Data = int(map(Wrist_Direction,0,180,90,40));
            d = Wrist_Direction_Data;        //d
            ///////////////////////////
            if(hand_roll < 0)
              hand_roll = -(hand_roll);
            Wrist_Rotation = int(map(hand_roll,0,180,0,180));
            if(Wrist_Rotation > 180) Wrist_Rotation = 180;   
            if(Wrist_Rotation < 0)   Wrist_Rotation = 0;  
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Wrist_Rotation <= 90) 
              line(520,450,520-100*cos(radians(Wrist_Rotation)),450-100*sin(radians(Wrist_Rotation))); 
            if(Wrist_Rotation > 90) 
              line(520,450,520+100*cos(radians(180-Wrist_Rotation)),450-100*sin(radians(180-Wrist_Rotation))); 
            //println(hand_roll); 
            Wrist_Rotation_Data = int(map(Wrist_Rotation,0,180,90,40));
            e = Wrist_Rotation_Data;        //e
            ///////////////////////////
            Paw_Open = int(map(hand_grab * 1000,0,1000,0,180));
            if(Paw_Open > 180) Paw_Open = 180;   
            if(Paw_Open < 0)   Paw_Open = 0;  
            stroke(255,0,0); 
            strokeWeight(16); 
            strokeCap(ROUND); 
            if(Paw_Open <= 90) 
              line(850,450,850-100*cos(radians(Paw_Open)),450-100*sin(radians(Paw_Open))); 
            if(Paw_Open > 90) 
              line(850,450,850+100*cos(radians(180-Paw_Open)),450-100*sin(radians(180-Paw_Open))); 
            //println(Paw_Open);
            Paw_Open_Data = int(map(Paw_Open,0,180,90,160));
            f = Paw_Open_Data;        //f
            
            send_data();
            //delay(100);
        } 
      } 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////     
                                     ////Data Mode////
      if(Data_Flag == false)
      {
        if(hand.isRight())  //Just find the right hand
        {
          background(255);
          textSize(0);
          strokeWeight(10);
          hand.draw();    //Draw The Hand
   
          textFont(font, 50);
          fill(0);
          text("Right Hand",400,40);
          translate(220,80,0);
          
          textFont(font, 14);
          fill(0);
          //Display Hand Position//
          text("Hand Position.X:",0,20);      text(hand_position.x, 120, 20);
          text("Hand Position.Y:",200,20);    text(hand_position.y, 320, 20);
          text("Hand Position.Z:",400,20);    text(hand_position.z, 520, 20);
       
          //Display Hand Stabilized//  
          text("Hand Stabilized.X:",0,50);    text(hand_stabilized.x, 120, 50);
          text("Hand Stabilized.Y:",200,50);  text(hand_stabilized.y, 320, 50);
          text("Hand Stabilized.Z:",400,50);  text(hand_stabilized.z, 520, 50);
       
          //Display Hand Direction//  
          text("Hand Direction.X:",0,80);     text(hand_direction.x, 120, 80);
          text("Hand Direction.Y:",200,80);   text(hand_direction.y, 320, 80);
          text("Hand Direction.Z:",400,80);   text(hand_direction.z, 520, 80);
          
          //Display Hand Dynamics//  
          text("Hand Dynamics.X:",0,110);     text(hand_direction.x, 120, 110);
          text("Hand Dynamics.Y:",200,110);   text(hand_direction.y, 320, 110);
          text("Hand Dynamics.Z:",400,110);   text(hand_direction.z, 520, 110);
          
          //Display Hand Grab Strength//  
          text("Hand Grab Strength:",0,140);     text(hand_grab, 120, 140);
          
          //Display Hand Pinch Strength//  
          text("Hand Pinch Strength:",0,170);     text(hand_pinch, 120, 170);
          
          //Display Hand Sphere Radius//  
          text("Hand Sphere Radius:",0,200);     text(sphere_radius, 120, 200);
          
          //Display Thumb Direction//  
          text("Thumb Direction.X:",0,230);     text(Thumb_direction.x, 120, 230);
          text("Thumb Direction.Y:",200,230);   text(Thumb_direction.y, 320, 230);
          text("Thumb Direction.Z:",400,230);   text(Thumb_direction.z, 520, 230);
          
          //Display Index Direction//  
          text("Index Direction.X:",0,260);     text(Index_direction.x, 120, 260);
          text("Index Direction.Y:",200,260);   text(Index_direction.y, 320, 260);
          text("Index Direction.Z:",400,260);   text(Index_direction.z, 520, 260);
          
          //Display Middle Direction//  
          text("Middle Direction.X:",0,290);     text(Middle_direction.x, 120, 290);
          text("Middle Direction.Y:",200,290);   text(Middle_direction.y, 320, 290);
          text("Middle Direction.Z:",400,290);   text(Middle_direction.z, 520, 290);
          
          //Display Ring Direction//  
          text("Ring Direction.X:",0,320);     text(Ring_direction.x, 120, 320);
          text("Ring Direction.Y:",200,320);   text(Ring_direction.y, 320, 320);
          text("Ring Direction.Z:",400,320);   text(Ring_direction.z, 520, 320);
          
          //Display Pinky Direction//  
          text("Pinky Direction.X:",0,350);     text(Pinky_direction.x, 120, 350);
          text("Pinky Direction.Y:",200,350);   text(Pinky_direction.y, 320, 350);
          text("Pinky Direction.Z:",400,350);   text(Pinky_direction.z, 520, 350);
          
          //Display Thumb Position//  
          text("Thumb Position.X:",0,380);     text(Thumb_position.x, 120, 380);
          text("Thumb Position.Y:",200,380);   text(Thumb_position.y, 320, 380);
          text("Thumb Position.Z:",400,380);   text(Thumb_position.z, 520, 380);
          
          //Display Index Position//  
          text("Index Position.X:",0,410);     text(Index_position.x, 120, 410);
          text("Index Position.Y:",200,410);   text(Index_position.y, 320, 410);
          text("Index Position.Z:",400,410);   text(Index_position.z, 520, 410);
          
          //Display Middle Position//  
          text("Middle Position.X:",0,440);     text(Middle_position.x, 120, 440);
          text("Middle Position.Y:",200,440);   text(Middle_position.y, 320, 440);
          text("Middle Position.Z:",400,440);   text(Middle_position.z, 520, 440);
          
          //Display Ring Position//  
          text("Ring Position.X:",0,470);     text(Ring_position.x, 120, 470);
          text("Ring Position.Y:",200,470);   text(Ring_position.y, 320, 470);
          text("Ring Position.Z:",400,470);   text(Ring_position.z, 520, 470);
          
          //Display Pinky Position//  
          text("Pinky Position.X:",0,500);     text(Pinky_position.x, 120, 500);
          text("Pinky Position.Y:",200,500);   text(Pinky_position.y, 320, 500);
          text("Pinky Position.Z:",400,500);   text(Pinky_position.z, 520, 500);
        }
        
        if(hand.isLeft())  //Just find the left hand
        {
          background(255);
          textSize(0);
          strokeWeight(10);
          hand.draw();    //Draw The Hand
          
          textFont(font, 50);
          fill(0);
          text("Left Hand",400,40);
          translate(220,80,0);
          
          textFont(font, 14);
          fill(0);
      
          //Display Hand Position//
          text("Hand Position.X:",0,20);      text(hand_position.x, 120, 20);
          text("Hand Position.Y:",200,20);    text(hand_position.y, 320, 20);
          text("Hand Position.Z:",400,20);    text(hand_position.z, 520, 20);
       
          //Display Hand Stabilized//  
          text("Hand Stabilized.X:",0,50);    text(hand_stabilized.x, 120, 50);
          text("Hand Stabilized.Y:",200,50);  text(hand_stabilized.y, 320, 50);
          text("Hand Stabilized.Z:",400,50);  text(hand_stabilized.z, 520, 50);
       
          //Display Hand Direction//  
          text("Hand Direction.X:",0,80);     text(hand_direction.x, 120, 80);
          text("Hand Direction.Y:",200,80);   text(hand_direction.y, 320, 80);
          text("Hand Direction.Z:",400,80);   text(hand_direction.z, 520, 80);
          
          //Display Hand Dynamics//  
          text("Hand Dynamics.X:",0,110);     text(hand_direction.x, 120, 110);
          text("Hand Dynamics.Y:",200,110);   text(hand_direction.y, 320, 110);
          text("Hand Dynamics.Z:",400,110);   text(hand_direction.z, 520, 110);
          
          //Display Hand Grab Strength//  
          text("Hand Grab Strength:",0,140);     text(hand_grab, 120, 140);
          
          //Display Hand Pinch Strength//  
          text("Hand Pinch Strength:",0,170);     text(hand_pinch, 120, 170);
          
          //Display Hand Sphere Radius//  
          text("Hand Sphere Radius:",0,200);     text(sphere_radius, 120, 200);
          
          //Display Thumb Direction//  
          text("Thumb Direction.X:",0,230);     text(Thumb_direction.x, 120, 230);
          text("Thumb Direction.Y:",200,230);   text(Thumb_direction.y, 320, 230);
          text("Thumb Direction.Z:",400,230);   text(Thumb_direction.z, 520, 230);
          
          //Display Index Direction//  
          text("Index Direction.X:",0,260);     text(Index_direction.x, 120, 260);
          text("Index Direction.Y:",200,260);   text(Index_direction.y, 320, 260);
          text("Index Direction.Z:",400,260);   text(Index_direction.z, 520, 260);
          
          //Display Middle Direction//  
          text("Middle Direction.X:",0,290);     text(Middle_direction.x, 120, 290);
          text("Middle Direction.Y:",200,290);   text(Middle_direction.y, 320, 290);
          text("Middle Direction.Z:",400,290);   text(Middle_direction.z, 520, 290);
          
          //Display Ring Direction//  
          text("Ring Direction.X:",0,320);     text(Ring_direction.x, 120, 320);
          text("Ring Direction.Y:",200,320);   text(Ring_direction.y, 320, 320);
          text("Ring Direction.Z:",400,320);   text(Ring_direction.z, 520, 320);
          
          //Display Pinky Direction//  
          text("Pinky Direction.X:",0,350);     text(Pinky_direction.x, 120, 350);
          text("Pinky Direction.Y:",200,350);   text(Pinky_direction.y, 320, 350);
          text("Pinky Direction.Z:",400,350);   text(Pinky_direction.z, 520, 350);
          
          //Display Thumb Position//  
          text("Thumb Position.X:",0,380);     text(Thumb_position.x, 120, 380);
          text("Thumb Position.Y:",200,380);   text(Thumb_position.y, 320, 380);
          text("Thumb Position.Z:",400,380);   text(Thumb_position.z, 520, 380);
          
          //Display Index Position//  
          text("Index Position.X:",0,410);     text(Index_position.x, 120, 410);
          text("Index Position.Y:",200,410);   text(Index_position.y, 320, 410);
          text("Index Position.Z:",400,410);   text(Index_position.z, 520, 410);
          
          //Display Middle Position//  
          text("Middle Position.X:",0,440);     text(Middle_position.x, 120, 440);
          text("Middle Position.Y:",200,440);   text(Middle_position.y, 320, 440);
          text("Middle Position.Z:",400,440);   text(Middle_position.z, 520, 440);
          
          //Display Ring Position//  
          text("Ring Position.X:",0,470);     text(Ring_position.x, 120, 470);
          text("Ring Position.Y:",200,470);   text(Ring_position.y, 320, 470);
          text("Ring Position.Z:",400,470);   text(Ring_position.z, 520, 470);
          
          //Display Pinky Position//  
          text("Pinky Position.X:",0,500);     text(Pinky_position.x, 120, 500);
          text("Pinky Position.Y:",200,500);   text(Pinky_position.y, 320, 500);
          text("Pinky Position.Z:",400,500);   text(Pinky_position.z, 520, 500);
      }
        }
    }
  }
}
void Display_Init()    //Initial Display On The Screen
{
  textFont(font, 70);
  fill(0);
  translate(0,10,0);
  text("Gesture-control Robot Arm",125,120);
  text("with Leap Motion",255,190);
  textFont(font, 25);
  fill(0);
  text("by Leo Wang",450,240);
  image(img3,280,220,100,100);
  text("Changshu Institute of Technology",390,280);
  image(img1,418,300,200,100); 
  image(img2,418,450,200,100); 
  text("START",480,357);
  text("Data Mode",466,507);
}

void keyPressed()
{
  if(keyCode == 32)   //Space Key
  {
    Data_Flag = true;
    Start_Flag = true;
    Wait1_Flag = 0;
    Wait2_Flag = 0;
  }
}

void send_data()
{
  out[0] = byte(a);
  out[1] = byte(b);
  out[2] = byte(c);
  out[3] = byte(e);
  out[4] = byte(f);
  port.write(out);
  delay(6);
  /*
  port.write('%');
  port.write(a);
  port.write(b);
  port.write(c);
  //port.write(d);
  //port.write(e);
  port.write(f);
  port.write('&');
  */
}
