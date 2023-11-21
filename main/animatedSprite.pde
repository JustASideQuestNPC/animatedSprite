import java.io.File;

/* does basic animations by swapping out pngs */
class AnimatedSprite {
  PImage[] frames;
  PImage currentFrame;
  long currentTime, nsPerFrame, frameTimer; // longs are just bigger ints, these need to be them for technical reasons
  int frameIndex, numFrames, imgMode;
  float framesPerSecond, playSpeed = 1;
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

  /* setters - most of these are technically unnecessary because everything is public, but they let me
   * implement the builder pattern and have a "modular" constructor */
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
      // setting ImageMode to CORNERS won't crash anything but it'll still cause things to break,
      // so we check it and throw an exception if we need to so that it doesn't cause problems down the
      // line (it also lets us give a nice description that went wrong)
      throw new IllegalArgumentException(
        String.format("Invalid image mode for AnimatedSprite.setImageMode()! (Expected 0 (CORNER) or " +
                      "3 (CENTER), recieved %1$d)", imgMode)
        );
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

  /* sets the current frame index; throws an exception if the index is out of range */
  AnimatedSprite setFrame(int frameIndex) throws IllegalArgumentException {
    if (frameIndex < 0 || frameIndex >= numFrames) {
      throw new IllegalArgumentException(
        String.format("Frame index out of range for AnimatedSprite! (expected > 0 and < %1$d, " +
                      "recieved %2$d)", numFrames, frameIndex)
      );
    }
    this.frameIndex = frameIndex;
    return this;
  }
  AnimatedSprite setPlaySpeed(float playSpeed) throws IllegalArgumentException {
    if (playSpeed == 0) {
      throw new IllegalArgumentException("AnimatedSprites cannot have a play speed of 0!");
    }
    this.playSpeed = playSpeed;
    return this;
  }

  /* advances forward by a number of frames (or backward if offset is negative); respects loop mode */
  AnimatedSprite advanceFrame(int offset) {
    frameIndex += offset;
    if (frameIndex < 0) {
      if (looping) frameIndex += numFrames;
      else {
        frameIndex = 0;
        paused = true;
      }
    }
    else if (frameIndex >= numFrames) {
      if (looping) frameIndex -= numFrames;
      else {
        frameIndex = numFrames - 1;
        paused = true;
      }
    }
    currentFrame = frames[frameIndex];
    frameTimer = nsPerFrame;
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
      // advanceFrame already handles looping behavior, so we can just call it to update the frame
      advanceFrame(playSpeed < 0 ? -1 : 1);
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