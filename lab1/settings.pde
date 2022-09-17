// Currently not used, but you may want to use it to enable/disable 
// draw-calls or debug output as needed
boolean DEBUG = false;

// The radius of the circle representing the boid body
int BOID_SIZE = 20;

// Where does billy start?
PVector BILLY_START = new PVector(50,500);
float BILLY_START_HEADING = 0;

// How fast can billy go and turn?
float BILLY_MAX_SPEED = 80;
float BILLY_MAX_ROTATIONAL_SPEED = 3;

float BILLY_MAX_ACCELERATION = 1;
float BILLY_MAX_ROTATIONAL_ACCELERATION = 1;

// Should boids leave breadcrumbs behind?
boolean LEAVE_CRUMBS = true;

// How many crumbs?
int MAX_CRUMBS = 1000;

// Time between crumbs
int CRUMB_INTERVAL = 200;

// How big are the crumbs?
int CRUMB_SIZE = 2;

// use for debugging, if you want to see where walls start/end (a circle is drawn closer to the end)
boolean SHOW_WALL_DIRECTION = false;

// How many obstacles should be generated *at most*
// Note that maps 2-4 are pretty dense and obstacles
// are only placed if they won't intersect with the map
int MAX_OBSTACLES = 0;
