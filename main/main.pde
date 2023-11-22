AnimatedSprite sprite;

// sprite is drawn to a canvas and upscaled to make it large enough to see
PGraphics upscale;

void setup() {
  size(300, 300);
  noSmooth();
  upscale = createGraphics(60, 60);
  upscale.noSmooth();
  sprite = new AnimatedSprite("sprite")
              .setScale(2)
              .setPosition(upscale.width / 2, upscale.height / 2)
              .setImageMode(CENTER)
              .setAngle(PI / 4)
              .setFrameRate(24)
              .setPlaySpeed(-1)
              .restart();
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