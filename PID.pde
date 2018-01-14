float ball_x, ball_y, vel_y; // ball constant
float kp = 0.1;              // pproportional constant Kp
float ki = 0.001;            // Intrigal constant Ki
float kd = 0.08;             //  Deravative constant Kd
float pid_p, pid_i, pid_d, PID;  // variables for pid
float error, prev_error;        // error valiables
float zoomFactorX = 1;          // x axis scale factor
float zoomFactorY = 1;          // y axis scale factor
float translateX, translateY;   // x and y offset variable

ArrayList<mCoodinate> points;  //arraylist to store all point traced


void setup() {
  size(800, 500);    //size of the window
  translateX = 0;    //set x offset to 0
  translateY = height / 2;  //set y offset to height /2
  frameRate(60);          // set refresh rate to 60 Hz
  ball_x = 0;             //set ball starting position  at x=0;
  ball_y = -200;          //set ball starting position -200 from center
  pid_p = 0;              //set pid_p variable 0;
  pid_i = 0;              //set pid_i variable 0;
  pid_d = 0;              //set pid_d variable 0;
  PID = 0;                //set PID to 0
  vel_y = 0;              //set initial y velocity to 0
  error = prev_error = 0; //set error and previous error 0
  points = new ArrayList(); // initialize the arraylist
}

void draw() {
  update();        //call the update function to update all variavles
  background(255); //set background white(#FFFFFF)
  stroke(0, 0, 0); //set stroke olor black(#000000)
  strokeWeight(1);  //stroke weight for line
  line(0, translateY, width, translateY); //draw  a black line as the center of the system
  strokeWeight(4);        //set stroke weight for trace points 
  stroke(#9d26ff);      //change the strokecolor for the ball
  fill(#9d26ff);        //change fill color for the ball;
  //draw the tace points
  for(mCoodinate mc : points) {  
    //ellipse(mc.getX()*zoomFactorX-translateX, translateY+mc.getY()*zoomFactorY, 2, 2);
    point(mc.getX()*zoomFactorX-translateX, translateY+mc.getY()*zoomFactorY);
  }
  strokeWeight(1); //stroke weight for ball
  ellipse(ball_x*zoomFactorX-translateX, translateY+ball_y*zoomFactorY, 10, 10); //draw the ball;
}

void update() {
  ball_x++;        //increment ball x position by 1 in every time
  error = ball_y;  // set the error of system to the position of the ball;
  pid_p = kp*error;    //calculate the proportional value
  if(-5 < error  && error < 5 && error != 0) {  //calculate intregration for very small error
    pid_i += ki*error;              //calculate Intregration value
  } else {
    pid_i = 0;
  }
  pid_d = kd*(error - prev_error);      //calculate the deravative value 
  PID = pid_p + pid_i + pid_d;          // calculate The PID value as the sum of the 3 variables
  prev_error = error;                   //set previous error to current error to use it in next time
  vel_y -= PID;                        //update the ball velocity
  ball_y += vel_y;                     //update the vall y position
  points.add(new mCoodinate(ball_x, ball_y));    //add a new point ti make trace of ball
}

void mouseClicked() {
  //on mouse click reset teh pid value 
  pid_p = 0;
  pid_i = 0;
  pid_d = 0;
  vel_y = 0;
  //set the ball in mouse position
  ball_x = mouseX-translateX;
  ball_y = mouseY-translateY;
  points.clear();
}

//coodinaet class for indivisual points 
class mCoodinate {
  private float x, y;
  public mCoodinate(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
    
}