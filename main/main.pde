AnimatedSprite sprite;

// sprite is drawn to a canvas and upscaled to make it large enough to see
PGraphics upscale;

void setup() {
  size(300, 300);
  noSmooth();
  upscale = createGraphics(30, 30);
  upscale.noSmooth();
  sprite = new AnimatedSprite("sprite")
          .setPosition(15, 15)
          .setImageMode(CENTER);
  sprite.restart();
}

void draw() {
  background(255);
  upscale.beginDraw();
  upscale.background(255);
  sprite.render(upscale);
  upscale.endDraw();
  image(upscale, 0, 0, width, height);
}

void mousePressed() {
  sprite.playSpeed *= -1;
}