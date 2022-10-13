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
   void bake(Map map)
   {

       /// generate the graph you need for pathfinding
       ///Add an array list of pvectors to navmesh class, store which vertices are reflex (reflex is found hrough dot product)
       //draw circles on the reflex vertices
       //second step down here
       //Once you have all the reflex vertices, you have a polygon which is ordered.
       //Find a reflex vertex, we need to add an edge. Select another vertex to connect to - just pick one arbitrarily. Closest, furthest, doesnt matter.
       //When the vertex is chosen, add an edge to the another array list.
       //For each polygon, the edges should be in counter clockwise order.
       //Next, recursively call another polygon, find a reflex vertex, connect it to another vertex. Split again (We should have a list of polygons)
       // make a method split(polygon) which splits it and calles another split on the children - which will yeld a return value. The return value is the graphs of what's split to find a shared edge
       //To find the center of a polygon, add all sides (their coordinates), divide by the sides.
       
       //The hardest thing is figuring out how to connect the graphs. We need to store which edge connects the split.
       //It might make my life easier to give each wall a number
       //Make sure the wall doesnt intersect with anything. If you find a reflex vertex, make sure the split doesnt cross outside the map. So we can check the intersect method to see if the new line would intersect outside the wall. If the wall goes outside the map. take the middle of the line(the mean) and ask the map if it's outside the map - reachable is the method)
 
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
   }
   
   void draw()
   {
      /// use this to draw the nav mesh graph

   }
}
