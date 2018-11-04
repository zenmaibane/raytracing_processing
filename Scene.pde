class Scene {
  ArrayList<Intersectable> objList = new ArrayList<Intersectable>();
  ArrayList<Light> lightList = new ArrayList<Light>();

  Scene() {}

  void addIntersectable(Intersectable obj) {
    this.objList.add(obj);
  }

  void addLight(Light light) {
    this.lightList.add(light);
  }

  Spectrum trace(Ray ray) {
    Intersection isect = findNearestIntersection(ray);
    if (!isect.hit()) { return BLACK; }

    return lighting(isect.p, isect.n, isect.material);
  }

  Intersection findNearestIntersection(Ray ray) {
    Intersection isect = new Intersection();
    for (int i = 0; i < this.objList.size(); i ++) {
      Intersectable obj = this.objList.get(i);
      Intersection tisect = obj.intersect(ray);
      if ( tisect.t < isect.t ) { isect = tisect; }
    }
    return isect;
  }

  Spectrum lighting(Vec p, Vec n, Material m) {
    Spectrum L = BLACK;
    for (int i = 0; i < this.lightList.size(); i ++) {
      Light light = this.lightList.get(i);
      Spectrum c = diffuseLighting(p, n, m.diffuse, light.pos, light.power);
      L = L.add(c);
    }
    return L;
  }

  Spectrum diffuseLighting(Vec p, Vec n, Spectrum diffuseColor,
                          Vec lightPos, Spectrum lightPower) {
    Vec v = lightPos.sub(p);
    Vec l = v.normalize();
    float dot = n.dot(l);
    if (dot > 0) {
      float r = v.len();
      float factor = dot / (4 * PI * r * r);
      return lightPower.scale(factor).mul(diffuseColor);
    } else {
      return BLACK;
    }
  }
}
