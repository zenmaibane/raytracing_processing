final float NO_HIT= Float.POSITIVE_INFINITY;
Vec lightPos = new Vec(10, 10, 10);
float lightPower = 4000;

Vec eye = new Vec(0, 0, 5);           
Vec sphereCenter = new Vec(0, 0, 0);  
float sphereRadius = 1;               

Vec lightPos = new Vec(10, 10, 10);   
float lightPower = 4000;              


void setup() {
  size(256, 256);
}

int y = 0;

void draw() {
  for (int x = 0; x < width; x ++) {
    color c = calcPixelColor(x, y);
    set(x, y, c);
  }

  y ++;
  if (height <= y) {
    noLoop();
  }
}

Vec calcPrimaryRay(int x, int y) {
  float imagePlane = height;

  float dx =   x + 0.5 - width / 2;
  float dy = -(y + 0.5 - height / 2);
  float dz = -imagePlane;

  return new Vec(dx, dy, dz).normalize();
}

color calcPixelColor(int x, int y) {
  Vec rayDir = calcPrimaryRay(x, y);
  float t = intersectRaySphere(eye, rayDir, sphereCenter, sphereRadius);
  
  if(t == NO_HIT){ return color(0, 0, 0); }
  
  Vec p = eye.add(rayDir.scale(t));
  
  Vec n = p.sub(sphereCenter).normalize();
  
  float brightness = diffuseLighting(p, n, lightPos, lightPower);
  
  int i = min(int(brightness * 255), 255);
  return color(i, i, i);
}

float intersectRaySphere(Vec rayOrigin, Vec rayDir, 
                         Vec sphereCenter, float sphereRadius) {
  Vec v = rayOrigin.sub(sphereCenter);
  float b = rayDir.dot(v);
  float c = v.dot(v) - sq(sphereRadius);
  
  float d = b * b - c;
  
  if(0 <= d){
    float s = sqrt(d);
    float t = -b - s;
    if (t <= 0) { t = -b + s; }
    if (0 < t) {
      return t;
    }
  }
  return NO_HIT;
}

float diffuseLighting(Vec p, Vec n, Vec lightPos, float lightPower) {
  Vec v = lightPos.sub(p);
  Vec l = v.normalize();
  
  float dot = n.dot(l);
  
  if(dot > 0){
    float r = v.len();
    return lightPower * dot / (4* PI * r *r);
  }else {
  }
}
