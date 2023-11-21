import java.io.File;

/* does basic animations by swapping out pngs */
class AnimatedSprite {
  // set to false to only update when update() is called)
  final boolean AUTO_UPDATE_ON_RENDER = true;

  PImage[] frames;
  PImage currentFrame;
  long currentTime, nsPerFrame, frameTimer; // longs are just bigger ints, these need to be them for technical reasons
  int frameIndex, numFrames, imageMode;
  float frameRate, playSpeed = 1;
  float x, y, xOffset, yOffset, width, height, angle;
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
  AnimatedSprite setPosition(PVector position) {
    return setPosition(position.x, position.y);
  }

  AnimatedSprite setSize(float width, float height) {
    this.width = width;
    this.height = height;
    return this;
  }

  // multiplies width and height by a scalar
  AnimatedSprite setScale(float scalar) {
    return setSize(this.width * scalar, this.height * scalar);
  }

  // either CORNER or CENTER (which are actually just 0 and 3); default is CORNER
  AnimatedSprite setImageMode(int imageMode) throws IllegalArgumentException {
    if (imageMode != CORNER && imageMode != CENTER) {
      // setting ImageMode to CORNERS won't crash anything but it'll still cause things to break,
      // so we check it and throw an exception if we need to so that it doesn't cause problems down the
      // line (it also lets us give a nice description that went wrong)
      throw new IllegalArgumentException(
        String.format("Invalid image mode for AnimatedSprite.setImageMode()! (Expected 0 (CORNER) or " +
                      "3 (CENTER), recieved %1$d)", imageMode)
        );
    }
    this.imageMode = imageMode;
    return this;
  }

  AnimatedSprite setAngle(float angle) {
    this.angle = angle;
    return this;
  }

  AnimatedSprite setOffset(float x, float y) {
    this.xOffset = x;
    this.yOffset = y;
    return this;
  }

  AnimatedSprite setOffset(PVector offset) {
    return setOffset(offset.x, offset.y);
  }

  AnimatedSprite setFrameRate(float frameRate) throws IllegalArgumentException {
    if (frameRate === 0) {
      throw new IllegalArgumentException("AnimatedSprites cannot have a frame rate of 0 FPS!");
    }
    this.frameRate = frameRate;
    nsPerFrame = (long)((1 / this.frameRate) * 1000000000); // time between frames in nanoseconds
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

  /* pauses and returns to the first or last frame based on play direction */
  AnimatedSprite reset() {
    if (playSpeed < 0) frameIndex = numFrames - 1;
    else frameIndex = 0;
    currentFrame = frames[frameIndex];
    paused = true;
    return this;
  }

  /* starts playing at the first or last frame based on play direction */
  AnimatedSprite restart() {
    reset();
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

  /* updates the sprite and renders the current frame to the given PGraphics canvas */
  void render(PGraphics pg) {
    if (AUTO_UPDATE_ON_RENDER) update();
    pg.pushStyle();
    pg.imageMode(this.imageMode);
    pg.pushMatrix();
    pg.translate(x, y);
    pg.rotate(angle);
    pg.image(currentFrame, xOffset, yOffset, this.width, this.height);
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
    this.width = currentFrame.width;
    this.height = currentFrame.height;
    // default frame rate is 15 fps
    setFrameRate(15);
    
    // start the clock used for tracking frames - System.nanoTime() is far more precise than millis()
    currentTime = System.nanoTime();
  }
}