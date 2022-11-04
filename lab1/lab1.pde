/// You do not need to change anything in this file, but you can
/// For example, if you want to add additional options controllable by keys
/// keyPressed would be the place for that.

ArrayList<PVector> waypoints = new ArrayList<PVector>();
Boid billy;
int lastt;

int mapnr = 0;

Map map = new Map();
NavMesh nm = new NavMesh();

boolean entering_path = false;

boolean show_nav_mesh = true;

boolean show_waypoints = true;

boolean show_help = false;

boolean flocking_enabled = false;

void setup() {
  size(800, 600);
  
  billy = new Boid(BILLY_START, BILLY_START_HEADING, BILLY_MAX_SPEED, BILLY_MAX_ROTATIONAL_SPEED, BILLY_MAX_ACCELERATION, BILLY_MAX_ROTATIONAL_ACCELERATION);
  randomSeed(0);
  map.generate(mapnr);
  nm.bake(map);
  
}

void mousePressed() {
  if (show_help) return;
  PVector target = new PVector(mouseX, mouseY);
  if (!map.isReachable(target)) return;
  if (mouseButton == LEFT)
  {
     
     if (waypoints.size() == 0)
     {
        billy.seek(target);
     }
     else
     {
       ArrayList<PVector> pathfinding = nm.findPath(waypoints.get(waypoints.size()-1), target);
       for(int i = 0; i < pathfinding.size(); i++){
         waypoints.add(pathfinding.get(i));
       }
        waypoints.add(target);
        entering_path = false;
        billy.follow(waypoints);
     }
  }
  else if (mouseButton == RIGHT)
  {
     if (!entering_path){
        waypoints = new ArrayList<PVector>();
        ArrayList<PVector> pathfinding = nm.findPath(billy.kinematic.position, target);
        waypoints = pathfinding;
      }
     else{
       print("Adding additional path");
       ArrayList<PVector> pathfinding = nm.findPath(waypoints.get(waypoints.size()-1), target);
       for(int i = 0; i < pathfinding.size(); i++){
         waypoints.add(pathfinding.get(i));
       }
     }
     waypoints.add(target);
     entering_path = true; 
  }
}

void keyPressed()
{
    if (show_help)
    {
        show_help = false;
        return;
    }
    if (key == 'h')
    {
        show_help = true;
    }
    
    if (show_help) return;
    if (key == 'g')
    {
       map.generate(-1);
       mapnr = -1;
       nm.bake(map);
    }
    else if (key == 'n')
    {
       show_nav_mesh = !show_nav_mesh;
    }
    else if (key == 'w')
    {
       show_waypoints = !show_waypoints;
    }
    else if ((key >= '1' && key <= '9'))
    {
       mapnr =  key-'1' + 1;
       map.generate(mapnr);
       
       nm.bake(map);
    }
    else if (key == '0')
    {
       mapnr = 0;
       map.generate(0);
       nm.bake(map);
    }
    else if (key == 'f')
    {
       flocking_enabled = !flocking_enabled;
       if (flocking_enabled)
       {
          flock();
       }
       else
       {
          unflock();
       }
    }
}

void show_status(boolean active, String show, int x)
{
  fill(255,255,255);
  if (active)
     fill(255,0,0);
  text(show, x, 40);
}

void draw() {
  background(0);
  
  //
  if(waypoints!=null){
    for(PVector point: waypoints){
      stroke(255);
      circle(point.x, point.y, 5);
    }
  }
  
  if (entering_path || show_waypoints)
  {
     stroke(255,0,0);
     strokeWeight(1);
     PVector current = billy.kinematic.position;
     if (show_waypoints && billy.target != null)
     {
        line(current.x, current.y, billy.target.x, billy.target.y);
        
        //troubleshooting by creating compass around points
        //draw compass
          //stroke(0,0,255);
          //line(current.x, current.y, current.x + 50, current.y);
          //line(current.x, current.y, current.x - 50, current.y);
          //line(current.x, current.y, current.x, current.y + 50);
          //line(current.x, current.y, current.x, current.y - 50);
          stroke(255,0,0);
        
        current = billy.target;
     }
     for (PVector wp : waypoints)
     {
        line(current.x, current.y, wp.x, wp.y);
        current = wp;
        //draw compass
          //line(wp.x, wp.y, wp.x + 50, wp.y);
          //line(wp.x, wp.y, wp.x - 50, wp.y);
          //line(wp.x, wp.y, wp.x, wp.y + 50);
          //line(wp.x, wp.y, wp.x, wp.y - 50);
        
     }
     if (entering_path)
        line(current.x, current.y, mouseX, mouseY);
  }
  

  float dt = (millis() - lastt)/1000.0;
  lastt = millis();
  billy.update(dt);
  map.update(dt);
  if (show_nav_mesh)
     nm.update(dt);
  textSize(12);
  show_status(show_nav_mesh, "N", 30);
  show_status(show_waypoints, "W", 50);
  show_status(show_help, "H", 70);
  show_status(flocking_enabled, "F", 90);
  if (mapnr < 0)
     show_status(false, "R", 110);
  else
     show_status(false, String.format("%d", mapnr), 110);
  
  if (show_help)
  {
      fill(255);
      stroke(0,0,255);
      rect(width*0.25, height*0.25, width*0.5, height*0.5);
      fill(0);
      textSize(32);
      text("HELP", width*0.5-30, height*0.25 + 40);
      textSize(18);
      text("0,1,2,3,4 - Show custom map 0,1,2,3,4", width*0.25+40, height*0.25 + 70);
      text("G - Generate random map", width*0.25+40, height*0.25 + 90);
      text("N - Show NavMesh", width*0.25+40, height*0.25 + 110);
      text("W - Show waypoints while moving", width*0.25+40, height*0.25 + 130);
      text("F - Enable/disable flocking", width*0.25+40, height*0.25 + 150);
      text("H - This screen", width*0.25+40, height*0.25 + 170);
      
      text("Press any key to close", width*0.5 - 80, height*0.75 - 80);
      textSize(12);
  }
  
  
}
