// Useful to sort lists by a custom key
import java.util.Comparator;


/// In this file you will implement your navmesh and pathfinding. 



/// This node representation is just a suggestion
class Node
{
   int id;
   ArrayList<Wall> polygon;
   PVector center;
   ArrayList<Node> neighbors;
   ArrayList<Wall> connections;
}



class NavMesh
{   
   public ArrayList<PVector> ReflexPoints;
  
   void bake(Map map)
   {

       /// generate the graph you need for pathfinding
       ///Add an array list of pvectors to navmesh class, store which vertices are reflex (reflex is found hrough dot product)
      
       ArrayList<Wall> Walls = map.walls;
       ReflexPoints = new ArrayList<PVector>();
       NoPoints = new ArrayList<PVector>();

         //loop through and check if reflex
           //if yes add
       stroke(0,255,0);
       if(Walls != null)
       {
         for(int i = 0; i<Walls.size(); ++i)
         {
           int next = (i+1)%Walls.size();
           if(Walls.get(i).normal.dot(Walls.get(next).direction) >= 0)
           {
             ReflexPoints.add(Walls.get(i).end);
             //circle (ReflexPoints.get(ReflexPoints.size()-1).x, ReflexPoints.get(ReflexPoints.size()-1).y, 20);
           }
         }
       } 
       if(Walls != null)
       {
         for(int i = 0; i<Walls.size(); ++i)
         {
           int next = (i+1)%Walls.size();
           if(Walls.get(i).normal.dot(Walls.get(next).direction) <= 0)
           {
             NoPoints.add(Walls.get(i).end);
             //circle (ReflexPoints.get(ReflexPoints.size()-1).x, ReflexPoints.get(ReflexPoints.size()-1).y, 20);
           }
         }
       } 
       stroke(255,0,0);

       //second step down here
       //Once you have all the reflex vertices, you have a polygon which is ordered.
       //Find a reflex vertex, we need to add an edge. Select another vertex to connect to - just pick one arbitrarily. Closest, furthest, doesnt matter.
       for(int i = 0; i < ReflexPoints.size(); i++)
       { 
         //Ok, so in this for loop, I want to cycle through each array. For reflexPoints, we get the first convex edge. Then we cycle through NoPoints to find the first non convex edge
         //We also need to check noPoints, if NoPoints i and ReflexPoints i cannot connect without a line hitting a wall, cycle through NoPoints i, and run the check again
         //After these checks are in place, we create our metaphorical Wall.
         ReflexPoints.get(i);
         NoPoints.get(i);
         Walls.add(ReflexPoints.get(i));
       }
       //When the vertex is chosen, add an edge to the another array list.
       //For each polygon, the edges should be in counter clockwise order.
       //Next, recursively call another polygon, find a reflex vertex, connect it to another vertex. Split again (We should have a list of polygons)
       // make a method split(polygon) which splits it and calles another split on the children - which will yeld a return value. The return value is the graphs of what's split to find a shared edge
       //To find the center of a polygon, add all sides (their coordinates), divide by the sides.
       
       //The hardest thing is figuring out how to connect the graphs. We need to store which edge connects the split.
       //It might make my life easier to give each wall a number
       //Make sure the wall doesnt intersect with anything. If you find a reflex vertex, make sure the split doesnt cross outside the map. So we can check the intersect method to see if the new line would intersect outside the wall. If the wall goes outside the map. take the middle of the line(the mean) and ask the map if it's outside the map - reachable is the method)
 
   }
   
   void Split(ArrayList<Wall> PolygonWalls)
   {
     //find reflexive point
     //use alg to find a new point   I think we should just start with the following point beyond what makes it reflex 
       //two checks:
       //one is that it is reachable
       //two is that the angle will not be reflexive anymore
     //creates a wall and reverse wall with the same numbers but one is negative
     //creates two new sets of walls
       //finds by matching removing all the walls between the reflexive and fix point on the original wall, and adds the reverse wall to that list
         //the non inverted wall is inserted to the position that the previous walls were just removed from
       //calls split() on both polygons
     //somehow add the connections, or save the splitting edge to a global list that they can be compared against later
     
     //if no reflexive points are found a convex polygon has been created
       //create an ID and initialize the polygon as a node class
     
   }
   
   ArrayList<PVector> findPath(PVector start, PVector destination)
   {
      /// implement A* to find a path
      ArrayList<PVector> result = null;
      return result;
   }
   
   
   void update(float dt)
   {
      draw();
        strokeWeight(3);
       line(start.x, start.y, end.x, end.y);
       if (SHOW_WALL_DIRECTION)
       {
          PVector marker = PVector.add(PVector.mult(start, 0.2), PVector.mult(end, 0.8));
          circle(marker.x, marker.y, 5);
       }
      
       //print("\n List all points: " + AllPoints);
       //print("\n List all reflex points: " + RPoints);
      
   }
   
   void draw()
   {
      /// use this to draw the nav mesh graph
      for(int i = 0; i < ReflexPoints.size(); i++){
        stroke(0,255,0);
        circle(ReflexPoints.get(i).x, ReflexPoints.get(i).y, 20);
      }
   }
}
