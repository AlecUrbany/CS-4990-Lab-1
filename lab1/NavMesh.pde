// Useful to sort lists by a custom key
import java.util.Comparator;
import java.util.HashMap;


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
   
   public ArrayList<Wall> NewWalls;
   HashMap<Integer, Wall> NewWallsMap = new HashMap<Integer, Wall>();
   //public ArrayList<PVector> OriginalPoints;
   
   void bake(Map map)
   {

             /// generate the graph you need for pathfinding
             ///Add an array list of pvectors to navmesh class, store which vertices are reflex (reflex is found hrough dot product)
      
       ArrayList<Wall> Walls = map.walls;
       NewWalls = new ArrayList<Wall>();
       ReflexPoints = new ArrayList<PVector>();
       
       stroke(0,255,0);
       if(Walls != null){
         for(int i = 0; i<Walls.size(); ++i){
           int next = (i+1)%Walls.size();
           if(Walls.get(i).normal.dot(Walls.get(next).direction) >= 0)
           {
             ReflexPoints.add(Walls.get(i).end);
             //circle (ReflexPoints.get(ReflexPoints.size()-1).x, ReflexPoints.get(ReflexPoints.size()-1).y, 20);
           }
         }
       } 
       stroke(255,0,0);     
             //second step down here
             //Once you have all the reflex vertices, you have a polygon which is ordered.
             //Find a reflex vertex, we need to add an edge. Select another vertex to connect to - just pick one arbitrarily. Closest, furthest, doesnt matter.
       //might add and if reflexive != null
       if (ReflexPoints.size() > 0){
         Split(Walls);  
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
     ///if(RecursionLimit == 0){
       //print("\nRecursion Limit Reached");
       //return;
     //}
     //print("Printing a wall list");
     //PrintWallCoords(PolygonWalls);
     
     //find reflexive point
     int ReflexPointNumber = -1;
     boolean Convex = true;
     
     //Wall FrontWall = PolygonWalls.get(0);
     
     for(int i = 0; i<PolygonWalls.size(); ++i){
           int next = (i+1)%PolygonWalls.size();
           if(PolygonWalls.get(i).normal.dot(PolygonWalls.get(next).direction) >= 0)
           {
             print("\nReflex found");
             ReflexPointNumber = next;
             //FrontWall = PolygonWalls.get(i);
             Convex = false;
             break;
           }
         }
     
     print("\nReflex Point Number: " + ReflexPointNumber);    
     
     if(Convex){
       print("\nFound Convex Polygon");
       //Create new polygon, no reflex points found
     }  else { //Going to need to split it again
       PVector ReflexPoint = PolygonWalls.get(ReflexPointNumber).start;
       
       //Need to find a point to fix at
       int FixPointNumber = 0;    //just need to initialize these variables, a valid fix point should always be found in our loop
       PVector FixPoint = ReflexPoint;
       
       int PointGap = 2;      //Points between start and fix, starts by skipping the point we know is reflex already
       boolean Reachable = false;
       boolean Reflexive = true;
       
       while(Reachable == false || Reflexive == false){
         Reachable = true;
         Reflexive = true;
         
         FixPointNumber = (ReflexPointNumber+PointGap)%PolygonWalls.size();
         FixPoint = PolygonWalls.get(FixPointNumber).start;
         Wall TestWall = new Wall(ReflexPoint, FixPoint);
         
         if(!IsPlaceable(PolygonWalls, TestWall)){
           Reachable = false;
         }
         
         int Previous = (ReflexPointNumber-1);
         if(Previous <0){
           Previous = PolygonWalls.size() -1;
         }
         if(PolygonWalls.get(Previous).normal.dot(TestWall.direction) >= 0){    //Checks if the new wall will fix the initial reflexive point
              Reflexive = false;
         }else{
          //print("\nA non reflexive wall could be formed between points " + ReflexPointNumber + " and " + FixPointNumber);
         }
         
         //print(" infinte looping ");
         PointGap += 1;
       }

       print("\nSplitting the polygon between points " + ReflexPoint + ", " + FixPoint);
       if(FixPointNumber < ReflexPointNumber){
         int temp = FixPointNumber;
         FixPointNumber = ReflexPointNumber;
         ReflexPointNumber = temp;
         ReflexPoint = PolygonWalls.get(ReflexPointNumber).start;
         FixPoint = PolygonWalls.get(FixPointNumber).start;
       }
       
       Wall Normal = new Wall(ReflexPoint, FixPoint);
       Wall Reverse = new Wall(FixPoint, ReflexPoint);
                   
       ArrayList<Wall> FrontWalls = new ArrayList<Wall>();
       ArrayList<Wall> BackWalls = new ArrayList<Wall>(); 
       BackWalls.add(Reverse);
                   
       for(int r = 0; r<PolygonWalls.size(); r++){
           
         
           if(r >= ReflexPointNumber && r < FixPointNumber){
             BackWalls.add(PolygonWalls.get(r));
             //print("\nAdding to backwall wall: " + r);
           } else{
             FrontWalls.add(PolygonWalls.get(r));
             //print("\nAdding to frontwall wall: " + r);
           }
         
       }
       FrontWalls.add(ReflexPointNumber, Normal);
       NewWalls.add(Normal);   
       
       print("\nPrinting the front wall list");
       PrintWallCoords(FrontWalls);
       //print("\nSplitting the front Wall");
       Split(FrontWalls);
       
       
       //print("\nPrinting the back wall list");
       //PrintWallCoords(BackWalls);
       //print("\nSplitting the back Wall");
       Split(BackWalls);
         
     }
   }  
     /*
     //creates a wall and reverse wall with the same numbers but one is negative
     //creates two new sets of walls
       //finds by matching removing all the walls between the reflexive and fix point on the original wall, and adds the reverse wall to that list
         //the non inverted wall is inserted to the position that the previous walls were just removed from
       //calls split() on both polygons
     //somehow add the connections, or save the splitting edge to a global list that they can be compared against later
           }
           else{
             //if no reflexive points are found a convex polygon has been created
             //create an ID and initialize the polygon as a node class
             
           }
         }
     */
   
   
   Boolean IsPlaceable (ArrayList<Wall> PolygonWalls, Wall TestWall){
     PVector From = PVector.add(TestWall.start, PVector.mult(TestWall.direction, 0.01));
     PVector To = PVector.add(TestWall.end, PVector.mult(TestWall.direction, -0.01));
     for(int n = 0; n<PolygonWalls.size(); n++){      //checks all walls to see if there is any crossing
           if(PolygonWalls.get(n).crosses(From, To)){
             return false;
           }
         }
     return true;
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
      if(NewWalls!=null){
      for(int j = 0; j < NewWalls.size(); j++){
        stroke(0,0,255);
        line(NewWalls.get(j).start.x, NewWalls.get(j).start.y, NewWalls.get(j).end.x, NewWalls.get(j).end.y);
          //line(current.x, current.y, current.x + 50, current.y);
      }
      }
   }
}
