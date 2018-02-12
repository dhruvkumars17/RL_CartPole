class Bar {
  float totalLength;
  float radius;
  float connect;
  
  Particle tail;
  Particle head;
  
  Bar(PVector pHead, PVector pTail, float r) {
    radius = r;
    head = new Particle(pHead);
    tail = new Particle(pTail);
    
    physics.addParticle(head);
    physics.addParticle(tail);
    
    VerletSpring2D spring = new VerletSpring2D(head, tail, abs(head.y-tail.y), 1);
        
    physics.addSpring(spring);
  }
  
  void update(PVector h) {
    head.set(h.x, h.y);
    PVector headV = new PVector(head.x, head.y);
    PVector tailV = new PVector(tail.x, tail.y);
    PVector c = new PVector(0,0);
    c = PVector.sub(headV, tailV);
    connect = c.heading();
  }

  // Draw the chain
  void display() {
    line(head.x, head.y, tail.x, tail.y);
    ellipse(tail.x, tail.y, radius, radius);
  }
}