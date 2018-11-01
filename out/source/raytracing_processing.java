import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class raytracing_processing extends PApplet {

public void setup() {
  
}

int y = 0;

public void draw() {
  for (int x = 0; x < width; x ++) {
    int c = calcPixelColor(x, y);
    set(x, y, c);
  }

  y ++;
  if (height <= y) {
    noLoop();
  }
}

// シーンの構成
float ox = 0, oy = 0, oz = 5; // 視点の座標
float cx = 0, cy = 0, cz = 0; // 球の中心座標
float r = 1;                  // 球の半径

public int calcPixelColor(int x, int y) {
  // 投影面までの距離
  float imagePlane = height;

  // ピクセルに対する一次レイの方向を計算する
  float dx =   x + 0.5f - width / 2;
  float dy = -(y + 0.5f - height / 2);
  float dz = -imagePlane;

  // レイが球と交差するかによって色を選択する
  if (intersectRaySphere(ox, oy, oz, dx, dy, dz, cx, cy, cz, r)) {
    return color(255, 255, 255);  // 白
  } else {
    return color(0, 0, 0);        // 黒
  }
}

// レイと球の交差判定
public boolean intersectRaySphere(float ox, float oy, float oz, // 視点の座標
                           float dx, float dy, float dz, // レイの向き
                           float cx, float cy, float cz, // 球の中心座標
                           float r // 球の半径
                          ) {
  // 交差判定の方程式の判別式に必要な値を求める
  float a = sq(dx) + sq(dy) + sq(dz);
  float b = 2 * (dx*(ox-cx) + dy*(oy-cy) + dz*(oz-cz));
  float c = sq(ox-cx) + sq(oy-cy) + sq(oz-cz) - sq(r);

  // 判別式を計算し、その解が0以上だったらtrueを返す
  float d = b * b - 4 * a * c;
  return 0 <= d;
}
class Vec {
  float x, y, z;

  Vec(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public Vec add(Vec v) {
    return new Vec(this.x + v.x, this.y + v.y, this.z + v.z);
  }

  public Vec sub(Vec v) {
    return new Vec(this.x - v.x, this.y - v.y, this.z - v.z);
  }

  public Vec scale(float s) {
    return new Vec(this.x * s, this.y * s, this.z * s);
  }

  public Vec neg() {
    return new Vec(-this.x, -this.y, -this.z);
  }

  public float len() {
    return sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
  }

  public Vec normalize() {
    return scale(1.0f / len());
  }

  public float dot(Vec v) {
    return this.x * v.x + this.y * v.y + this.z * v.z;
  }

  public Vec cross(Vec v) {
    return new Vec(this.y * v.z - v.y * this.z,
                   this.z * v.x - v.z * this.x,
                   this.x * v.y - v.x * this.y);
  }
  public String toString() {
    return "Vec(" + this.x + ", " + this.y + ", " + this.z + ")";
  }
}
  public void settings() {  size(256, 256); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "raytracing_processing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
