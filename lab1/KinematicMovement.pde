/// Do not change this file!
/// The only methods you can call are increaseSpeed, getPosition, getHeading, getSpeed and getRotationalVelocity

class KinematicMovement
{
   // position
   private PVector position;
   private float heading;
   
   private float speed;
   private float rotational_velocity;
   
   float max_speed;
   float max_rotational_speed;
   KinematicMovement(PVector position, float heading, float max_speed, float max_rotational_speed)
   {
     this.position = position;
     this.heading = heading;
     this.speed = 0;
     this.rotational_velocity = 0;
     this.max_speed = max_speed;
     this.max_rotational_speed = max_rotational_speed;
   }
   void update(float dt)
   {
     PVector velocity = new PVector(cos(this.heading), sin(this.heading)).mult(speed);
     
     PVector destination = PVector.add(this.position, PVector.mult(velocity, dt));
     // check for map collisions; only move if no collisions
     if (!map.collides(this.position, destination))
         this.position = destination;
     this.heading += this.rotational_velocity*dt;
     this.heading = normalize_angle(this.heading);
   }
   private void setSpeed(float s, float rs)
   {
     this.speed = constrain(s, -max_speed, max_speed);
     this.rotational_velocity = constrain(rs, -this.max_rotational_speed, this.max_rotational_speed);
   }
   
   // These are the public methods
   void increaseSpeed(float ds, float drs)
   {
     setSpeed(this.speed + ds, this.rotational_velocity + drs);
   }
   
   PVector getPosition()
   {
      return position;
   }
   
   float getHeading()
   {
      return heading;
   }
   
   float getSpeed()
   {
      return speed;
   }
   
   float getRotationalVelocity()
   {
      return rotational_velocity;
   }
   // End public methods
}
