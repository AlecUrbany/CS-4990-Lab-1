// These are custom maps (for part b), defined as lists of coordinates for the outline
// You can add additional maps as you see fit
PVector[] customMap(int nr)
{
    if (nr == 1)
    {
        return new PVector[] {new PVector(0, 1), new PVector(0.8, 1), new PVector(0.55, 0.7), new PVector(0.75, 0.1), 
                              new PVector(1, 0.9), new PVector(1, 0), new PVector(0.25, 0), new PVector(0.25, 0.15), new PVector(0, 0.15)};
    }
    else if (nr == 2)
    {
        return new PVector[] {new PVector(0, 1), new PVector(0.25, 1),  new PVector(0.4, 0.75), new PVector(0.45, 0.5), 
                              new PVector(0.1, 0.5), new PVector(0.12, 0.35), new PVector(0.25, 0.35), new PVector(0.5, 0.4),
                              new PVector(0.5, 0.65), new PVector(0.6, 0.65), new PVector(0.6, 0.8), new PVector(0.5, 0.82),
                              new PVector(0.3, 1), new PVector(1,1), new PVector(1,0), new PVector(0.57, 0), new PVector(0.6, 0.35),
                              new PVector(0.7, 0.35), new PVector(0.67, 0.1), new PVector(0.85, 0.1), new PVector(0.82,0.15),
                              new PVector(0.75, 0.2), new PVector(0.75, 0.75), new PVector(0.85, 0.92), new PVector(0.62, 0.9),
                              new PVector(0.7, 0.8), new PVector(0.7, 0.5), new PVector(0.58, 0.45), new PVector(0.45,0), 
                              new PVector(0.25, 0), new PVector(0.25, 0.15), new PVector(0, 0.15)};
    }
    else if (nr == 3)
    {
        return new PVector[] {new PVector(0, 1), new PVector(0.45, 1), new PVector(0.45, 0.6), new PVector(0.1, 0.6),
                              new PVector(0.2, 0.23), new PVector(0.35, 0.25), new PVector(0.35, 0.35), new PVector(0.25, 0.35),
                              new PVector(0.25, 0.3), new PVector(0.2, 0.3), new PVector(0.2, 0.55), new PVector(0.3, 0.55),
                              new PVector(0.3, 0.46), new PVector(0.4, 0.45), new PVector(0.4, 0.55), new PVector(0.6, 0.62),
                              new PVector(0.6, 0.85), new PVector(0.5, 0.85), new PVector(0.5, 1), new PVector(1,1),
                              new PVector(1,0.9), new PVector(0.7, 0.9), new PVector(0.7, 0.62),
                              new PVector(0.8, 0.75), new PVector(0.8, 0.85), new PVector(1, 0.85),
                              new PVector(1,0), new PVector(0.9, 0), new PVector(0.93, 0.13), new PVector(0.87, 0.1),
                              new PVector(0.85, 0.05), new PVector(0.75, 0.05), new PVector(0.75, 0.15), new PVector(0.8, 0.15),
                              new PVector(0.8, 0.25), new PVector(0.95,0.25), new PVector(0.92, 0.55), new PVector(0.75, 0.55),
                              new PVector(0.75, 0.45), new PVector(0.85, 0.40), new PVector(0.8, 0.5), new PVector(0.9, 0.5),
                              new PVector(0.9, 0.35), new PVector(0.67, 0.35), new PVector(0.67, 0.2), new PVector(0.5, 0.2),
                              new PVector(0.5, 0.35), new PVector(0.65, 0.45), new PVector(0.45, 0.47),
                              new PVector(0.45, 0.1), new PVector(0.7, 0.15), new PVector(0.7, 0), new PVector(0.25, 0), 
                              new PVector(0.25, 0.15), new PVector(0, 0.15)
                              };
    }
    else if (nr == 4)
    {
        return new PVector[] {new PVector(0, 1), new PVector(0.85, 1), new PVector(0.87, 0.15), new PVector(0.45, 0.15), new PVector(0.35, 0.3),
                              new PVector(0.15, 0.3), new PVector(0.15, 0.55), new PVector(0.5, 0.55), new PVector(0.57, 0.42), new PVector(0.45, 0.75), new PVector(0.6, 0.8),
                              new PVector(0.6, 0.6), new PVector(0.65, 0.35), new PVector(0.55, 0.35), new PVector(0.47, 0.45), new PVector(0.3, 0.45),
                              new PVector(0.32, 0.37), new PVector(0.45, 0.4), new PVector(0.5, 0.27), new PVector(0.7, 0.3), new PVector(0.7, 0.85),
                              new PVector(0.4, 0.8), new PVector(0.4, 0.65), new PVector(0.13, 0.65), new PVector(0.1, 0.27), new PVector(0.35, 0.2),
                              new PVector(0.45, 0.12), new PVector(0.9, 0.1), new PVector(0.9, 1), new PVector(1,1), new PVector(1,0), new PVector(0.25, 0), 
                              new PVector(0.25, 0.15), new PVector(0, 0.15)
                            };
          
    }
    else if (nr == 5)
    {
        return new PVector[] {new PVector(0, 1), new PVector(1, 1), new PVector(1, 0), 
                              new PVector(.6, 0), new PVector(.5, .2), new PVector(.4, 0),new PVector(0, 0)
                            };
          
    }
    else if (nr == 6)
    {
        return new PVector[] {new PVector(0, 1), new PVector(.4, 1), new PVector(.5, .8), new PVector(.6, 1), new PVector(1, 1), new PVector(1, 0), 
                              new PVector(0, 0)
                            };
          
    }
    else /// you can use nr==5, nr==6, ... nr==9 to add your own custom maps
    {
        return new PVector[] {new PVector(0, 1), new PVector(0.8, 1), new PVector(0.55, 0.7), new PVector(0.75, 0.1), 
                              new PVector(1, 0.9), new PVector(1, 0), new PVector(0.25, 0), new PVector(0.25, 0.15), new PVector(0, 0.15)};
    }

}
