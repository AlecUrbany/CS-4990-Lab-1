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
      float angleofchange = angletotarget - normalize_angle_left_right(billy.kinematic.getHeading());
                                                      
      
     // works to slow down when arriving
     float IdealSpeed = distance;                                                      
     
     float VelocityChange = 0;
     
     if (billy.kinematic.getSpeed() > IdealSpeed){                
      VelocityChange = -1; 
     } else {
       VelocityChange = 1;
     }
     
     float IdealRotationSpeed = angleofchange;
     float RotationChange = 0;
     
     if(IdealRotationSpeed > billy.kinematic.getRotationalVelocity()){
         RotationChange = 1;
     }  else{
         RotationChange = -1;
     }
     
     if(abs(angleofchange) > TAU/8){
       RotationChange = 1;
       if (billy.kinematic.getSpeed() > BILLY_MAX_SPEED/4){
           VelocityChange = -1;
       }
     }
     
     if(distance < 1){
      
       VelocityChange = -billy.kinematic.getSpeed();
       RotationChange = -billy.kinematic.getRotationalVelocity();
       
       waypoints.remove(0);
       billy.follow(waypoints);
     }
     //float RotationChange = angleofchange;
     
      
     kinematic.increaseSpeed(VelocityChange, RotationChange);
     print("\n", (angleofchange));
     
      
     
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
      /*
       int howMany = waypoints.size();
       print("\nThere are this many waypoints:", howMany);
       int n = 0;
       
      if (n == howMany)
      {
       this.target = waypoints.get(n);
       print("\nThe last target is:", target, "at waypoint number:", howMany);
       billy.seek(target);
      }
      else
      {
       this.target = waypoints.get(n);
       print("\nThe current target is:", target, "at waypoint number:", n);
       billy.seekFast(target);
       print("\n", waypoints.get(0));
       waypoints.remove(0);
       print("\n", waypoints.get(0));
      }
      */
   }
}
