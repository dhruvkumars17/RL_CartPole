class Cart {
  int sizeX, sizeY;
  PVector pos;
  
  Cart(PVector p, int sX, int sY) {
    sizeX = sX;
    sizeY = sY;
    pos = new PVector(p.x, p.y);
  }
  
  void updateMouse() {
    pos.x = mouseX;
  }
  
  void display() {
    rectMode(CENTER);
    rect(pos.x, pos.y, sizeX, sizeY);
  }
}