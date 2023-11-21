import java.io.File;

/* does basic animations by swapping out pngs */
class AnimatedSprite {
  PImage[] frames;
  PImage currentFrame;
  long currentTime, nsPerFrame, frameTimer; // longs are just bigger ints, these need to be them for technical reasons
  int frameIndex, numFrames, imgMode, playSpeed;
  float framesPerSecond;
  float x, y, w, h, angle;
  boolean paused = true, looping = true;

  /* ctor that takes an array of PImages directly */
  AnimatedSprite(PImage[] frames) {
    this.frames = frames;
    init();
  }

  /* ctor that auto-loads from a folder */
  AnimatedSprite(String path) {
    // do some fancy java filesystem stuff to get all files in the folder
    File folder = new File(dataPath(path));
    File[] files = folder.listFiles();
    frames = new PImage[files.length];
    for (int i = 0; i < files.length; ++i) {
      frames[i] = loadImage(files[i].getPath());
    }
    init();
  }

  /* builder pattern setters */
  AnimatedSprite setPosition(float x, float y) {
    this.x = x;
    this.y = y;
    return this;
  }
  // overload that takes a PVector
  AnimatedSprite setPosition(PVector pos) {
    return setPosition(pos.x, pos.y);
  }
  AnimatedSprite setSize(float w, float h) {
    this.w = w;
    this.h = h;
    return this;
  }
  // multiplies width and height by a scalar
  AnimatedSprite setScale(float s) {
    return setSize(w * s, h * s);
  }
  // either CORNER or CENTER (which are actually just 0 and 3); default is CORNER
  AnimatedSprite setImageMode(int imgMode) throws IllegalArgumentException {
    if (imgMode != CORNER && imgMode != CENTER) {
      throw new IllegalArgumentException(String.format("Invalid image mode for AnimatedSprite.setImageMode()! " +
                                                       "(Expected 0 (CORNER) or 3 (CENTER), recieved %d)", imgMode));
    }
    this.imgMode = imgMode;
    return this;
  }
  AnimatedSprite setAngle(float angle) {
    this.angle = angle;
    return this;
  }
  AnimatedSprite setFrameRate(float framesPerSecond) {
    this.framesPerSecond = framesPerSecond;
    nsPerFrame = (long)((1 / framesPerSecond) * 1000000000); // time between frames in nanoseconds
    frameTimer = nsPerFrame;
    return this;
  }
  AnimatedSprite setLooping(boolean looping) {
    this.looping = looping;
    return this;
  }
  /* starts playing at the first or last frame based on play direction */
  AnimatedSprite restart() {
    frameIndex = 0;
    currentFrame = frames[frameIndex];
    paused = false;
    return this;
  }

  /* ticks the clock and updates to the next frame if necessary */
  void update() {
    long deltaTime = System.nanoTime() - currentTime;
    currentTime = System.nanoTime();
    if (paused) return;
    frameTimer -= deltaTime * abs(playSpeed);
    if (frameTimer <= 0) {
      frameIndex++;
      if (frameIndex >= numFrames) {
        frameIndex = 0;
      }
      currentFrame = frames[frameIndex];
      frameTimer = nsPerFrame;
    }
  }
  /* renders the current frame to the given PGraphics canvas */
  void render(PGraphics pg) {
    pg.pushStyle();
    pg.imageMode(imgMode);
    pg.pushMatrix();
    pg.translate(x, y);
    pg.rotate(angle);
    pg.image(currentFrame, 0, 0, w, h);
    pg.popMatrix();
    pg.popStyle();
  }

  // overload that defaults to the main canvas
  void render() {
    render(getGraphics());
  }

  /* allows for overloading most of the ctor */
  void init() throws IllegalArgumentException {
    numFrames = frames.length;
    if (numFrames == 0) throw new IllegalArgumentException("AnimatedSprite has no frames!");
    frameIndex = 0;
    currentFrame = frames[frameIndex];
    w = currentFrame.width;
    h = currentFrame.height;
    // default frame rate is 10 fps
    framesPerSecond = 10;
    nsPerFrame = (long)((1 / framesPerSecond) * 1000000000); // time between frames in nanoseconds
    frameTimer = nsPerFrame;
    
    // start the clock used for tracking frames - System.nanoTime() is far more precise than millis()
    currentTime = System.nanoTime();
  }
}