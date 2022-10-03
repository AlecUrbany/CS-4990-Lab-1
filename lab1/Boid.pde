/// In this file, you will have to implement seek and waypoint-following
/// The relevant locations are marked with "TODO"

class Crumb
{
  PVector position;
  Crumb(PVector position)
  {
     this.position = position;
  }
  void draw()
  {
     fill(255);
     noStroke(); 
     circle(this.position.x, this.position.y, CRUMB_SIZE);
  }
}

class Boid
{
   Crumb[] crumbs = {};
   int last_crumb;
   float acceleration;
   float rotational_acceleration;
   KinematicMovement kinematic;
   PVector target;
   
   Boid(PVector position, float heading, float max_speed, float max_rotational_speed, float acceleration, float rotational_acceleration)
   {
     this.kinematic = new KinematicMovement(position, heading, max_speed, max_rotational_speed);
     this.last_crumb = millis();
     this.acceleration = acceleration;
     this.rotational_acceleration = rotational_acceleration;
   }

   void update(float dt)
   {
     if (target != null)
     {  
      //seek implementation
       
      //Calculates distance from Boid to target 
      float distance = get_distance(billy.kinematic.position.x, billy.kinematic.position.y, target.x, target.y);
      
      float angletotarget = normalize_angle_left_right(atan2(target.y - billy.kinematic.position.y, target.x - billy.kinematic.position.x));
      float angleofchange = normalize_angle_left_right(angletotarget - billy.kinematic.getHeading());
                                                   
     //Sets the speed relative to the immediate point
     float VelocityChange = 0;
     if (billy.kinematic.getSpeed() > distance){                
      VelocityChange = -1; 
     } else {
       VelocityChange = 1;
     }
     
     //Turns to face the immediate point
     float RotationChange = 0;
     if(angleofchange > billy.kinematic.getRotationalVelocity()){
         RotationChange = 1 * abs(angleofchange);
     }  else{
         RotationChange = -1 * abs(angleofchange);
     }
     
     //Slows down when not pointing at the proper direction
     if(abs(angleofchange) > TAU/16){
       //RotationChange = angleofchange;
       //print("\n hi");
       if (billy.kinematic.getSpeed() > 10)
       {
           VelocityChange = -1;
       }
     }
     
     //Previous lines make going one point to another quick but dont take into account the angle between 2 waypoints
     float nextHeading = 0;
     float nextDistance = 0;
     
     if (waypoints.size() > 1)
       {
         PVector currentPoint = waypoints.get(0);
         PVector nextPoint = waypoints.get(1);
         
         //Currently redundant, could add a check later
         nextDistance = get_distance(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
         //calculates how much needs to change for following point
         nextHeading = atan2(nextPoint.y - currentPoint.y, nextPoint.x - currentPoint.x) + angleofchange;
         //print("\n" + nextHeading);
         
         //creates a turning speed relative to how much the point needs to turn
         float turningSpeed = (BILLY_MAX_SPEED  - BILLY_MAX_SPEED * (1 * abs(nextHeading/(TAU))));    //turns it into a ratio of speed from 0 to 100 percent of max speed
         //float turningSpeed = BILLY_MAX_SPEED  * (1 * abs(nextHeading/(25))); //Experimenting with how much it slows down as it currently slows too much on low angles
         print("\n" + nextHeading);
         print("\n" + turningSpeed);
         
         //if its too fast it will slow down, and it also needs to be within the max speed range, which is currently 80
         if((billy.kinematic.getSpeed() > turningSpeed) && (distance < BILLY_MAX_SPEED)){
            VelocityChange = -1;
         } else if(billy.kinematic.getSpeed() < turningSpeed){
           VelocityChange = 1;
         }
         
       }
     
     
     //Increased from 1 for higher tolerance and faster teting
     if(distance <5)
     {
       print("\n Arrived at a point");
       if (waypoints.size() == 1)
       {
         VelocityChange = -billy.kinematic.getSpeed();
         RotationChange = -billy.kinematic.getRotationalVelocity();
       }
       else if (waypoints.size() > 1)
       {
         waypoints.remove(0);
         billy.follow(waypoints);
         print("\n", (distance));
       }
     }
      
     kinematic.increaseSpeed(VelocityChange, RotationChange);
     //kinematic.increaseSpeed(0, 0);
     //print("\n", (angleofchange));
     
      
     
     }
     
     // place crumbs, do not change     
     if (LEAVE_CRUMBS && (millis() - this.last_crumb > CRUMB_INTERVAL))
     {
        this.last_crumb = millis();
        this.crumbs = (Crumb[])append(this.crumbs, new Crumb(this.kinematic.position));
        if (this.crumbs.length > MAX_CRUMBS)
           this.crumbs = (Crumb[])subset(this.crumbs, 1);
     }
     
     // do not change
     this.kinematic.update(dt);
     
     draw();
   }
   
   void draw()
   {
     for (Crumb c : this.crumbs)
     {
       c.draw();
     }
     
     fill(255);
     noStroke(); 
     float x = kinematic.position.x;
     float y = kinematic.position.y;
     float r = kinematic.heading;
     circle(x, y, BOID_SIZE);
     // front
     float xp = x + BOID_SIZE*cos(r);
     float yp = y + BOID_SIZE*sin(r);
     
     // left
     float x1p = x - (BOID_SIZE/2)*sin(r);
     float y1p = y + (BOID_SIZE/2)*cos(r);
     
     // right
     float x2p = x + (BOID_SIZE/2)*sin(r);
     float y2p = y - (BOID_SIZE/2)*cos(r);
     triangle(xp, yp, x1p, y1p, x2p, y2p);
   } 
   
   void seek(PVector target)
   {
      this.target = target;
      
   }
   
   void follow(ArrayList<PVector> waypoints)
   {
      // TODO: change to follow *all* waypoints
      this.target = waypoints.get(0);
   }
}
