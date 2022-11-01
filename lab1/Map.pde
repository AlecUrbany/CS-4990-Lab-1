/// You do not have to change this file, but you can, if you want to add a more sophisticated generator.
class Wall
{
   PVector start;
   PVector end;
   PVector normal;
   PVector direction;
   float len;
   int id;
   
   Wall(PVector start, PVector end)
   {
      this.start = start;
      this.end = end;
      direction = PVector.sub(this.end, this.start);
      len = direction.mag();
      direction.normalize();
      normal = new PVector(-direction.y, direction.x);
   }
   
   
   boolean crosses(PVector from, PVector to)
   {
      // Vector pointing from `this.start` to `from`
      PVector d1 = PVector.sub(from, this.start);
      // Vector pointing from `this.start` to `to`
      PVector d2 = PVector.sub(to, this.start);
      // If both vectors are on the same side of the wall
      // their dot products with the normal will have the same sign
      // If they are both positive, or both negative, their product will
      // be positive.
      float dist1 = normal.dot(d1);
      float dist2 = normal.dot(d2);
      if (dist1 * dist2 > 0) return false;
      
      // if the start and end are on different sides, we need to determine 
      // how far the intersection point is along the wall
      // first we determine how far the projections of from and to are 
      // along the wall
      float ldist1 = direction.dot(d1);
      float ldist2 = direction.dot(d2);
      
      // the distance of the intersection point from the start
      // is proportional to the normal distance of `from` in 
      // along the total movement
      float t = dist1/(dist1 - dist2);

      // calculate the intersection as this proportion
      float intersection = ldist1 + t*(ldist2 - ldist1);
      if (intersection < 0 || intersection > len) return false;
      return true;      
   }
   
   // Return the mid-point of this wall
   PVector center()
   {
      return PVector.mult(PVector.add(start, end), 0.5);
   }
   
   void draw()
   {
       strokeWeight(3);
       line(start.x, start.y, end.x, end.y);
       if (SHOW_WALL_DIRECTION)
       {
          PVector marker = PVector.add(PVector.mult(start, 0.2), PVector.mult(end, 0.8));
          circle(marker.x, marker.y, 5);
       }
   }
}

void AddPolygon(ArrayList<Wall> walls, PVector[] nodes)
{
    for (int i = 0; i < nodes.length; ++ i)
    {
       int next = (i+1)%nodes.length;
       walls.add(new Wall(nodes[i], nodes[next]));
    }
}

void AddPolygonScaled(ArrayList<Wall> walls, PVector[] nodes)
{
    for (int i = 0; i < nodes.length; ++ i)
    {
       int next = (i+1)%nodes.length;
       walls.add(new Wall(new PVector(nodes[i].x*width, nodes[i].y*height), new PVector(nodes[next].x*width, nodes[next].y*height)));
    }
}

class Obstacle
{
   ArrayList<Wall> walls;
   Obstacle()
   {
      walls = new ArrayList<Wall>();
      PVector origin = new PVector(width*0.1 + random(width*0.65), height*0.12 + random(height*0.65));
      if (origin.x < 100 && origin.y > 500) origin.add(new PVector(150,0));
      PVector[] nodes = new PVector[] {};
      float angle = random(100)/100.0;
      for (int i = 0; i < 3 + random(2) && angle < TAU; ++i)
      {
          float distance = height*0.05 + random(height*0.15);
          nodes = (PVector[])append(nodes, PVector.add(origin, new PVector(cos(-angle)*distance, sin(-angle)*distance)));
          angle += 1 + random(25)/50;
      }
      AddPolygon(walls, nodes);
   }
   
   
}

// Given a (closed!) polygon surrounded by walls, tests if the
// given point is inside that polygon.
// Note that this only works for polygons that are inside the
// visible screen (or not too far outside)
boolean isPointInPolygon(PVector point, ArrayList<Wall> walls)
{
   // we create a test point "far away" horizontally
   PVector testpoint = PVector.add(point, new PVector(width*2, 0));
   
   // Then we count how often the line from the given point
   // to our test point intersects the polygon outline
   int count = 0;
   for (Wall w: walls)
   {
      if (w.crosses(point, testpoint))
         count += 1;
   }
   
   // If we cross an odd number of times, we started inside
   // otherwise we started outside the polygon
   // Intersections alternate between enter and exit,
   // so if we "know" that the testpoint is outside
   // and odd number means we exited one more time 
   // than we entered.
   return (count%2) == 1;
}

class Map
{
   ArrayList<Wall> walls;
   ArrayList<Obstacle> obstacles;
   ArrayList<Wall> outline;
   
   ArrayList<PVector> pts;
   
   Map()
   {
       walls = new ArrayList<Wall>();
       outline = new ArrayList<Wall>();
       obstacles = new ArrayList<Obstacle>();
   }
  
   boolean collides(PVector from, PVector to)
   {
      for (Wall w : walls)
      {
         if (w.crosses(from, to)) return true;
      }
      return false;
   }
   
   void doSplit(boolean xdir, float from, float to, float other, float otherend, ArrayList<PVector> points, int level)
   {
       float range = abs(to-from);
       float sign = -1;
       if (to > from) sign = 1;
       if (range < 70) return;
       if (level > 1 && random(0,1) < 0.05*level) return;
       float split = from + sign*random(range*0.35, range*0.45);
       float splitend = split + sign*random(20, range*0.35-10);
       if (xdir)
           points.add(new PVector(split, other));
       else
           points.add(new PVector(other, split));
       float othersign = 1;
       if (otherend < other) othersign = -1;
       float otherrange = abs(other-otherend);
       float spikeend = other + othersign*random(otherrange*0.4, otherrange*(0.9 - 0.1*level));
       doSplit(!xdir, other, spikeend, split, from, points, level+1);
       if (xdir)
       {
           points.add(new PVector(split, spikeend));
           points.add(new PVector(splitend, spikeend));
       }
       else
       {
           points.add(new PVector(spikeend, split));
           points.add(new PVector(spikeend, splitend));
       }
       doSplit(!xdir, spikeend, other, splitend, to, points, level + 1);
       
       if (xdir)
           points.add(new PVector(splitend, other));
       else
           points.add(new PVector(other, splitend));
   }
   
   void randomMap()
   {
      ArrayList<PVector> points = new ArrayList<PVector>();
      
      points.add(new PVector(0, height));
      doSplit(true, 50, width, height, 0, points, 0);
      points.add(new PVector(width, height));
      points.add(new PVector(width, 0));
      points.add(new PVector(200, 0));
      points.add(new PVector(200, 80)); 
      points.add(new PVector(0, 80));
      
      //pts = points;
      AddPolygon(outline, points.toArray(new PVector[]{}));
   }
   
   
   void generate(int which)
   {
      outline.clear();
      obstacles.clear();
      walls.clear();
      if (which < 0)
      {
          randomMap();
      }
      else if (which == 0)
      {
          AddPolygon(outline, new PVector[] {new PVector(-100, height+100), new PVector(width+100, height+100), new PVector(width+100, -100), new PVector(-100,-100)});
      }
      else 
      {
          AddPolygonScaled(outline, customMap(which));
      }
      walls.addAll(outline);
      for (int i = 0; i < random(MAX_OBSTACLES); ++i)
      {
          Obstacle obst = new Obstacle();
          boolean ok = true;
          // only obstacle if it doesn't intersect with any existing one (or the exterior)
          for (Wall w : obst.walls)
          {
             if (collides(w.start, w.end)) ok = false;
             if (!isReachable(w.start)) ok = false;
          }
          if (ok)
          {
             obstacles.add(obst);
             walls.addAll(obst.walls);
          }
      }
   }
   
   void update(float dt)
   {
      draw();
   }
   
   void draw()
   {
      stroke(255);
      strokeWeight(3);
      for (Wall w : walls)
      {
         w.draw();
      }
      if (pts != null)
      {
          PVector current = new PVector(width/2, height/2);
          for (PVector p : pts)
          {
             fill(255,0,0);
             circle(p.x, p.y, 4);
             line(current.x, current.y, p.x, p.y);
             current = p;
          }
      }
   }
   
   boolean isReachable(PVector point)
   {
       if (!isPointInPolygon(point, outline)) return false;
       for (Obstacle o: obstacles)
       {
           if (isPointInPolygon(point, o.walls)) return false;
       }
       return true;
   }
}
