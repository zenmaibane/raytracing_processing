class Plane implements Intersectable {
  Vec n;             
  float d;            // ( ax + by + cz + d = 0)
  Material material; 

  
  Plane(Vec p, Vec n, Material material) {
    this.n = n.normalize();
    this.d = -p.dot(this.n);
    this.material = material;
  }

  Intersection intersect(Ray ray) {
    Intersection isect = new Intersection();
    float v = this.n.dot(ray.dir);
    float t = -(this.n.dot(ray.origin) + this.d) / v;
    if (0 < t) {
      isect.t = t;
      isect.p = ray.origin.add(ray.dir.scale(t));
      isect.n = this.n;
      isect.material = this.material;
    }
    return isect;
  }
}
