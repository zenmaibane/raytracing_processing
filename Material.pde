class Material {
  Spectrum diffuse;
  float reflective = 0;
  
  Material(Spectrum diffuse) {
    this.diffuse = diffuse;
  }
}
