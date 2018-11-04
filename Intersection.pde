final float NO_HIT = Float.POSITIVE_INFINITY;

class Intersection {
  float t = NO_HIT;
  Vec p;           
  Vec n;           
  Material material;

  Intersection() {}

  boolean hit() { return this.t != NO_HIT; }
}
