// Useful to sort lists by a custom key
import java.util.Comparator;
import java.util.HashMap;
import java.util.Random;
import java.util.*;
/// In this file you will implement your navmesh and pathfinding. 


/// This node representation is just a suggestion
class Node
{
   int id;    //each polygon is given a unique ID    This is not required for this implementation but helped with troubleshooting
   ArrayList<Wall> polygon;    //each polygon will have convex walls
   PVector center;    //each polygon will have a centerpoint
   ArrayList<Node> neighbors;    //a list of all adjacent nodes
   HashMap<Node, Wall> neighborToWall;    //the map to quickly find a wall based on which neighbor is being analyzed
   ArrayList<Wall> connections;    //a seperate list of walls to make the design easier
   
   Node(int id, ArrayList<Wall> walls){
    this.id = id;  
    polygon = walls;
    center = findCenter(walls);
    neighbors = new ArrayList<Node>();
    neighborToWall = new HashMap<Node, Wall>();
    connections = new ArrayList<Wall>();   
  }
  
  //finds the center given the walls, simply an average of all the coordinates
  PVector findCenter (ArrayList<Wall> polygon){
    float xCoord = 0;
    float yCoord = 0;
    
    for(int i = 0; i < polygon.size(); i++){
      xCoord += polygon.get(i).start.x;
      yCoord += polygon.get(i).start.y;
    }
    xCoord /= polygon.size();
    yCoord /= polygon.size();
    
    return new PVector(xCoord, yCoord);
  }
  
  void addNeighbor(Node newNeighbor){
    neighbors.add(newNeighbor);
  }
  
  void addNeighborWall(Node newNeighbor, Wall wall){
    neighborToWall.put(newNeighbor, wall);
  }
  
  void addConnection(Wall newWall){
    connections.add(newWall);
  }
}



class NavMesh
{   
   public ArrayList<PVector> ReflexPoints;  //Reflex points that need to be adjusted
   public ArrayList<Wall> NewWalls;      //Walls that have been added to split polygon to be convex useful as a counter, and as a stepping stone, but could be edited out
   public ArrayList<Node> convexPolygons;    //The list of all convex polygons
   //public ArrayList<PVector> holyGrail;  //path to be followed
   HashMap<Integer, Node> NewWallsMap = new HashMap<Integer, Node>();   //Useful for providing neighbors into each node using the index number
   
   //possible improvement, get rid of the hashmap by using a dynamic data structure that has 2 rows
   
   void bake(Map map)
   {
       ArrayList<Wall> Walls = map.walls;
       NewWalls = new ArrayList<Wall>();
       ReflexPoints = new ArrayList<PVector>();
       
       //Checking for reflex points, likely not required when code is finished
       /*
       if(Walls != null){
         for(int i = 0; i<Walls.size(); ++i){
           int next = (i+1)%Walls.size();
           if(Walls.get(i).normal.dot(Walls.get(next).direction) >= 0)
           {
             ReflexPoints.add(Walls.get(i).end);
           }
         }
       } 
      */
            
       convexPolygons = new ArrayList<Node>();
       NewWallsMap = new HashMap<Integer, Node>(); 
       //if (ReflexPoints.size() > 0){
       Split(Walls);  //recursively splits the walls and will add everything to public memory
         
         //each wall should have a list of connections, and a varying number of walls. the map should contain a listing for each of these corresponding walls
       for(int i = 0; i < convexPolygons.size(); i++){
         if(convexPolygons.get(i).connections.size() != convexPolygons.get(i).neighbors.size()){  //if they have the same number then every connecting wall should have its 
             
           for(int j = 0; j < convexPolygons.get(i).connections.size(); j++){  
               
             if(NewWallsMap.containsKey(convexPolygons.get(i).connections.get(j).getID())){
                 
               convexPolygons.get(i).addNeighbor(NewWallsMap.get(convexPolygons.get(i).connections.get(j).getID()));
               convexPolygons.get(i).addNeighborWall(NewWallsMap.get(convexPolygons.get(i).connections.get(j).getID()), convexPolygons.get(i).connections.get(j));              }
             }                     
           }
         }   
       //}
       print("\n The Walls map is: " + NewWallsMap);
        
             
       //if(convexPolygons != null){
      for(int l = 0; l < convexPolygons.size(); l++){
        print("\nPrinting information for the node with ID: " + convexPolygons.get(l).id);
          //stroke(150);
          //circle(convexPolygons.get(l).center.x, convexPolygons.get(l).center.y, 20);
        print("\n\t The connecting walls: ");
        for(int f = 0; f < convexPolygons.get(l).connections.size(); f++){
          print("\n\t\t wall is: " + convexPolygons.get(l).connections.get(f) + " with an ID of " + convexPolygons.get(l).connections.get(f).ID);
            //stroke(150);
            //line(convexPolygons.get(l).connections.get(f).start.x, convexPolygons.get(l).connections.get(f).start.y, convexPolygons.get(l).connections.get(f).end.x, convexPolygons.get(l).connections.get(f).end.y);
            
        }
        print("\n\t The surrounding walls: ");
        for(int f = 0; f < convexPolygons.get(l).polygon.size(); f++){
          stroke(020);
            //line(convexPolygons.get(l).polygon.get(f).start.x, convexPolygons.get(l).polygon.get(f).start.y, convexPolygons.get(l).polygon.get(f).end.x, convexPolygons.get(l).polygon.get(f).end.y);
          
        }
        print("\n\t The neighbor nodes: ");
        for(int f = 0; f < convexPolygons.get(l).neighbors.size(); f++){
          print(convexPolygons.get(l).neighbors.size());
          print("\n\t\t neighbor is: " + convexPolygons.get(l).neighbors.get(f).id + ", at point " + convexPolygons.get(l).neighbors.get(f).center);
          stroke(150);
          //line(convexPolygons.get(l).center.x, convexPolygons.get(l).center.y, convexPolygons.get(l).neighbors.get(f).center.x, convexPolygons.get(l).neighbors.get(f).center.y);
          
        }
          
      }
      //}
 
     //finding path between the start and a designated point here, issue with calling it from boid seek
     //holyGrail = new ArrayList<PVector>();
     //holyGrail = findPath(billy.kinematic.position, new PVector(760, 310));
     
     //prints out the path generated by A*
     
     /*
     print("\n Path in order\n");
     if(holyGrail != null){
     for(int i = 0; i < holyGrail.size(); i++){
        print((i + 1)+ " Point: is at " + holyGrail.get(i));
        print("\n");
      }
     }
     */
   }
   
   void Split(ArrayList<Wall> PolygonWalls)
   {
     
     //print("Printing a wall list");
     //PrintWallCoords(PolygonWalls);
     
     //find first reflexive point to split off from
     int ReflexPointNumber = -1;
     boolean Convex = true;
     
     
     for(int i = 0; i<PolygonWalls.size(); ++i){
           int next = (i+1)%PolygonWalls.size();
           if(PolygonWalls.get(i).normal.dot(PolygonWalls.get(next).direction) >= 0)
           {
             print("\nReflex found");
             ReflexPointNumber = next;
             Convex = false;
             break;
           }
         }
     print("\nReflex Point Number: " + ReflexPointNumber);    
     
     
     if(Convex){
       print("\nFound Convex Polygon");
       //Create new polygon, no reflex points found
       //creates them with IDs of the order they were created in
       Node convex = new Node(convexPolygons.size(), PolygonWalls);
       
       
       for(int e = 0; e < PolygonWalls.size(); e++){  
         if(PolygonWalls.get(e).getID() != 0){
           //found a wall that is a connection, so it will be guaranteed to be included in this convex node
           convex.addConnection(PolygonWalls.get(e));
           
           //Checking if the hashmap already contains the corresponding neighbor
           if(NewWallsMap.containsKey(PolygonWalls.get(e).getID())){
             //if it does it can add the neighboring node
             convex.addNeighbor(NewWallsMap.get(PolygonWalls.get(e).getID()));
             //convex.addNeighbor(NewWallsMap.get(PolygonWalls.get(e).getID()), PolygonWalls.get(e));
             convex.addNeighborWall(NewWallsMap.get(PolygonWalls.get(e).getID()), PolygonWalls.get(e));
             
             NewWallsMap.put(-1 * PolygonWalls.get(e).getID(), convex);
           }else{  //if not the neighboring node has not been created yet so this node will create it
             NewWallsMap.put(-1 * PolygonWalls.get(e).getID(), convex);
             //the number is negative so it will correspond to the reverse wall
           }
           //theoretically this means that half the nodes will creat a listing, and the other half will need to ad
           
         }
       }
       
       
       convexPolygons.add(convex);
       
     }  else { //Going to need to split it again
     
       PVector ReflexPoint = PolygonWalls.get(ReflexPointNumber).start;
       
       //Need to find a point to fix at
       int FixPointNumber = 0;    //just need to initialize these variables, a valid fix point should always be found in our loop
       PVector FixPoint = ReflexPoint;
       
       int PointGap = 2;      //Points between start and fix, starts by skipping the point we know is reflex already
       boolean Reachable = false;
       boolean Reflexive = true;
       
       while(Reachable == false || Reflexive == false){
         FixPointNumber = (ReflexPointNumber+PointGap)%PolygonWalls.size();  //Uses the next available point so it is a very simple iteration through all the points, and there will always be at least one point that fulfills both requirements
         FixPoint = PolygonWalls.get(FixPointNumber).start;
         Wall TestWall = new Wall(ReflexPoint, FixPoint);
         
         //Checks if the new edge would actually interfere with any existing walls
         Reachable = IsPlaceable(PolygonWalls, TestWall);
         
         //using the % wasn't working before so I added this to get the previous wall even if it was the first wall in the list
         int Previous = (ReflexPointNumber-1);
         if(Previous <0){
           Previous = PolygonWalls.size() -1;
         }
         if(PolygonWalls.get(Previous).normal.dot(TestWall.direction) >= 0){    //Checks if the new wall will fix the initial reflexive point
           Reflexive = false;
         }else{
           Reflexive = true;
          //print("\nA non reflexive wall could be formed between points " + ReflexPointNumber + " and " + FixPointNumber);
         }
         
         PointGap += 1;  //if the first point doesnt work, then it will go to the next point
       }

       print("\nSplitting the polygon between points " + ReflexPoint + ", " + FixPoint);
       
       //makes sure that in the order list of walls, the reflex point comes before so both new polygons are properly directioned and ordered
       if(FixPointNumber < ReflexPointNumber){
         int temp = FixPointNumber;
         FixPointNumber = ReflexPointNumber;
         ReflexPointNumber = temp;
         ReflexPoint = PolygonWalls.get(ReflexPointNumber).start;
         FixPoint = PolygonWalls.get(FixPointNumber).start;
       }
       
       //Two walls needed so each polygon has ordered walls going counter clockwise
       Wall Normal = new Wall(ReflexPoint, FixPoint);
       Normal.setID((NewWalls.size() + 1));
       Wall Reverse = new Wall(FixPoint, ReflexPoint);
       Reverse.setID(-1 * (NewWalls.size() + 1));
       
       //Adding the new wall to a list or later use/recursion
       NewWalls.add(Normal);   
                
       //Walls split between 2 polygons
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
       
       
       
       //Splits both new polygons
       print("\nPrinting the front wall list");
       PrintWallCoords(FrontWalls);
       //print("\nSplitting the front Wall");
       Split(FrontWalls);
       
       
       //print("\nPrinting the back wall list");
       //PrintWallCoords(BackWalls);
       //print("\nSplitting the back Wall");
       Split(BackWalls);
       
       //Add proper connections/neighbors
     }
   }  
   
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
   
   class frontierNode{
     float heuristic;
     float pathLength;
     float aValue;
     Node currentNode;
     frontierNode parentNode;
     
     frontierNode(Node currentNode, frontierNode parentNode, float pathLength, PVector target){
       this.currentNode = currentNode;
       this.parentNode = parentNode;
       this.pathLength = pathLength;
       this.heuristic = getPVectorDistance(currentNode.center, target);
       this.aValue = pathLength + heuristic;
     }
   }
   
   ArrayList<PVector> findPath(PVector boidPosition, PVector destinationPosition)
   {
     ArrayList<PVector> path = new ArrayList<PVector>();
    
     //find which nodes boid and destination are in
     Node startNode = null;
     Node endNode = null;

     for(Node testNode: convexPolygons){     
       if(pointContained(boidPosition, testNode.polygon)){
         startNode = testNode;
         break;
       }
     }
     
     for(Node testNode: convexPolygons){
       if(pointContained(destinationPosition, testNode.polygon)){
         endNode = testNode;
         break;
       }
     }
     
     //call find node path
     if (startNode != endNode){
       ArrayList<Node> nodePath = new ArrayList<Node>();
       print("\nFinding path between nodes");
       nodePath = findNodePath(startNode, endNode);
       
       print("\n Number of nodes " + nodePath.size());
       
       for(int i = 0; i < nodePath.size() - 1; i++){
         //path.add(nodePath.get(i).center);
         path.add(nodePath.get(i).neighborToWall.get(nodePath.get(i + 1)).center());
         
         /*
         for(int j = 0; j < nodePath.get(i).connections.size(); j++){
           if(nodePath.get(i).connections.get(j).crosses(nodePath.get(i).center, nodePath.get(i+1).center)){
             path.add(nodePath.get(i).connections.get(j).center());
             break;
           }
         
         }
         */
         
       }
       //path.add(nodePath.get(nodePath.size() - 1).center);
     }
     
     path.add(destinationPosition);
     //path.add(0, boidPosition);
     //might combine them all into one, tbd
     
     print("\n Number of points to travel through: " + path.size());
     
     return path;  
   }
   
   boolean pointContained (PVector point, ArrayList<Wall> polygon){
     //Wall infinity = new Wall(point, new PVector(point.x + 2*width, point.y));
     int crosses = 0;
     for(Wall wall: polygon){
            if (wall.crosses(point, new PVector(point.x + 2*width, point.y))){
              crosses ++;
            }
            
          }
     if((crosses % 2) == 0){
       return false;
     }
     return true;
   }
   
   
   ArrayList<Node> findNodePath(Node start, Node destination)
   {
     print("\n Looking for path");
     ArrayList<frontierNode> frontierList = new ArrayList<frontierNode>();
     ArrayList<Node> previouslyExpandedList = new ArrayList<Node>();
     
     frontierList.add(new frontierNode(start, null, 0, destination.center));
     //frontierNode lastNode;
     while(frontierList.get(0).currentNode != destination){
        print("\n The current lowest node is at: " + frontierList.get(0).currentNode.center);
        for(int i = 0; i < frontierList.get(0).currentNode.neighbors.size(); i++){
          print("\n Adding Neighbors");
          float newPath = frontierList.get(0).pathLength + getPVectorDistance(frontierList.get(0).currentNode.center, frontierList.get(0).currentNode.neighbors.get(i).center);
          frontierList.add(new frontierNode(frontierList.get(0).currentNode.neighbors.get(i), frontierList.get(0), newPath, destination.center));
        }
        previouslyExpandedList.add(frontierList.get(0).currentNode);
        frontierList.remove(0);
        frontierList.sort(new FrontierCompare());
        while(previouslyExpandedList.contains(frontierList.get(0).currentNode)){
          frontierList.remove(0);
        }
        print("\n Done Sorting");
     }
     
      ArrayList<Node> result = new ArrayList<Node>();
      result.add(frontierList.get(0).currentNode);
      
      frontierNode parentNode = frontierList.get(0).parentNode;
      
      while(result.get(0) != start){
        result.add(0, parentNode.currentNode);
        parentNode = parentNode.parentNode;
      }
      //result.add(destination);
      
      return result;
   }
   
   class FrontierCompare implements Comparator<frontierNode>{
     int compare(frontierNode a, frontierNode b){
       print("\n Doing comparing things");
       if(a.aValue > b.aValue){
         return 1;
       } else if(a.aValue < b.aValue){
         return -1;
       } else
         return 0;
     }
   }
   
   
   
   TreeMap<Float, Node> expandFrontier(TreeMap<Float, Node>frontier, Node target){
     float shortestPath = frontier.firstKey();
     for(int i = 0; i<frontier.get(shortestPath).neighbors.size(); i++){
       float heuristic = shortestPath + getPVectorDistance(target.center, frontier.get(shortestPath).neighbors.get(i).center);
       frontier.put(heuristic, frontier.get(shortestPath).neighbors.get(i));
     }
     return frontier;
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
      
      int blueColor = 255;
      int redColor = 0;
      if(NewWalls!=null){
      for(int j = 0; j < NewWalls.size(); j++){
        stroke(redColor,0,blueColor);
        blueColor -= 10;
        redColor += 10;
        //line(NewWalls.get(j).start.x, NewWalls.get(j).start.y, NewWalls.get(j).end.x, NewWalls.get(j).end.y);
          //line(current.x, current.y, current.x + 50, current.y);
      }
      }
      
      /*
      //print(RandData);
      if(RandData!=null){
      for(int k = 0; k < RandData.size(); k++){
        stroke(0,0,255);
        circle(RandData.get(k).center.x, RandData.get(k).center.y, 20);
        for(int l = 0; l<RandData.get(k).connections.size(); l++){
          stroke (0,0,100);
          line(RandData.get(k).connections.get(l).start.x, RandData.get(k).connections.get(l).start.y, RandData.get(k).connections.get(l).end.x, RandData.get(k).connections.get(l).end.y);
          
          for(Wall wall: RandData.get(k).polygon){
            stroke (0,0,200);
            line(wall.start.x, wall.start.y, wall.end.x, wall.end.y);
            
          }
        }
        
      }
      }
      */
      
      if(convexPolygons != null){
        for(int l = 0; l < convexPolygons.size(); l++){
          stroke(150);
          circle(convexPolygons.get(l).center.x, convexPolygons.get(l).center.y, 20);
          for(int f = 0; f < convexPolygons.get(l).connections.size(); f++){
            stroke(150);
            line(convexPolygons.get(l).connections.get(f).start.x, convexPolygons.get(l).connections.get(f).start.y, convexPolygons.get(l).connections.get(f).end.x, convexPolygons.get(l).connections.get(f).end.y);
          
          }
          for(int f = 0; f < convexPolygons.get(l).polygon.size(); f++){
            stroke(020);
            //line(convexPolygons.get(l).polygon.get(f).start.x, convexPolygons.get(l).polygon.get(f).start.y, convexPolygons.get(l).polygon.get(f).end.x, convexPolygons.get(l).polygon.get(f).end.y);
          
          }
          for(int f = 0; f < convexPolygons.get(l).neighbors.size(); f++){
            stroke(150);
            //line(convexPolygons.get(l).center.x, convexPolygons.get(l).center.y, convexPolygons.get(l).neighbors.get(f).center.x, convexPolygons.get(l).neighbors.get(f).center.y);
          
          }
          
        }
      }
      
      
   }
}
