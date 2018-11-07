class Vec {
  float x, y, z;

  Vec(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  Vec add(Vec v) {
    return new Vec(this.x + v.x, this.y + v.y, this.z + v.z);
  }

  Vec sub(Vec v) {
    return new Vec(this.x - v.x, this.y - v.y, this.z - v.z);
  }

  Vec scale(float s) {
    return new Vec(this.x * s, this.y * s, this.z * s);
  }

  Vec neg() {
    return new Vec(-this.x, -this.y, -this.z);
  }

  float len() {
    return sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
  }

  Vec normalize() {
    return scale(1.0 / len());
  }

  float dot(Vec v) {
    return this.x * v.x + this.y * v.y + this.z * v.z;
  }

  Vec cross(Vec v) {
    return new Vec(this.y * v.z - v.y * this.z,
                   this.z * v.x - v.z * this.x,
                   this.x * v.y - v.x * this.y);
  }
  String toString() {
    return "Vec(" + this.x + ", " + this.y + ", " + this.z + ")";
  }
  
  Vec reflect(Vec n) {
    return this.sub(n.scale(2 * this.dot(n)));
  }
  
  Vec refract(Vec n, float eta){
    float dot = this.dot(n);
    float d = 1.0 - sq(eta) * (1.0 - sq(dot));
    if(0 < d){
      Vec a = this.sub(n.scale(dot)).scale(eta);
      Vec b = n.scale(sqrt(d));
      return a.sub(b);
    }
    return this.reflect(n);
  }
}
