final int DEPTH_MAX = 10;
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

  Spectrum trace(Ray ray, int depth) {
    if (DEPTH_MAX < depth) { return BLACK; }
    Intersection isect = findNearestIntersection(ray);
    if (!isect.hit()) { return BLACK; }
    
    Material m = isect.material;
    Spectrum l = BLACK;
    
    float ks = m.reflective;
    
    if(0 < ks){
      Vec r = ray.dir.reflect(isect.n);
      Spectrum c = trace(new Ray(isect.p, r), depth + 1);
      l = l.add(c.scale(ks).mul(m.diffuse)); 
    }
    
    float kd = 1.0 - ks;
    if (0 < kd) {
      Spectrum c = this.lighting(isect.p, isect.n, isect.material);
      l = l.add(c.scale(kd));
    }

    return l;
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
    if (dot > 0){
      if (visible(p, lightPos)){
        float r = v.len();
        float factor = dot /(4 * PI * r * r);
        return lightPower.scale(factor).mul(diffuseColor);
      }
    }
    
    return BLACK;
  }
  
  boolean visible(Vec org, Vec target){
    Vec v = target.sub(org).normalize();
    Ray shadowRay = new Ray(org, v);
    
    for(int i = 0; i < this.objList.size(); i++){
      Intersectable obj = this.objList.get(i);
      if(obj.intersect(shadowRay).t < v.len()){
        return false;
      }
    }
    return true;
  }
}
