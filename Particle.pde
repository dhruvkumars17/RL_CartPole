class Particle extends VerletParticle2D {
  
  float radius = 4;  // Adding a radius for each particle
  
  Particle(PVector pos) {
    super(pos.x,pos.y);
  }
}