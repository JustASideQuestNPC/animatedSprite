AnimatedSprite sprite;

PGraphics upscale;

void setup() {
  size(300, 300);
  noSmooth();
  upscale = createGraphics(60, 60);
  upscale.noSmooth();
  sprite = new AnimatedSprite("sprite")
              .setPosition(30, 30)
              .setImageMode(CENTER)
              .setScale(2)
              .restart();
}

void draw() {
  sprite.update();

  background(255);
  upscale.beginDraw();
  upscale.background(255);
  sprite.render(upscale);
  upscale.endDraw();
  image(upscale, 0, 0, width, height);
}