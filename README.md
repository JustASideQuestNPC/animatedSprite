# AnimatedSprite
A "header-only" Processing library that creates an animation from a group of PNG files.
### Installation Guide
- Download `AnimatedSprite.pde` from the [latest release](https://github.com/JustASideQuestNPC/animatedSprite/releases/tag/v1.0.0).
- Drop it in your sketch folder with the rest of your code files.
- Follow the Quickstart guide.
- Profit.

### Contents
- [Quickstart](#quickstart)
- [Fields](#fields)
- [Methods](#methods)

## Quickstart
If you want to load a sprite from a file, the first step is to set up the sprite folder. To do this, convert each frame of your animation into a PNG (or equivalent image format) and place them all in a folder. The frames will be loaded in alphabetical order, so make sure they're named accordingly. See the `sprite` folder in `data` for an example.

Next, create a new `AnimatedSprite` in `setup`, and pass it the location of the sprite folder:
```java
AnimatedSprite sprite;

void setup() {
  // load a sprite from the "sprite" folder in the data folder
  sprite = new AnimatedSprite("sprite");
}
```

By default, sprites are paused when they're created. To play it and draw it to the canvas, call its `restart` method after creating it, then call its `render` method in your `draw` loop.
```java
AnimatedSprite sprite;

void setup() {
  // load a sprite from the "sprite" folder in the data folder
  sprite = new AnimatedSprite("sprite");
  sprite.restart(); // play the animation
}

void draw() {
  background(255);  // clear the canvas
  sprite.render();  // draw the sprite
}
```

Now that you've created a sprite, you'll probably want to change things like its position and size. Thankfully, `AnimatedSprite` has a variety of setter methods for this:
- [`setPosition`](#setposition)
- [`setSize`](#setsize)
- [`setScale`](#setscale)
- [`setAngle`](#setangle)
- [`setOffset`](#setoffset)
- [`setImageMode`](#setimagemode)
- [`setLooping`](#setlooping)
- [`setPlaySpeed`](#setplayspeed)
- [`setFrame`](#setframe)
- [`setFrameRate`](#setframerate)

All of these methods partially implement the Builder Pattern by returning a reference to the sprite they are called on. If that's confusing, all you need to know is that you can set anything you need to set in a single command when you create the sprite by formatting it like this:
```java
// create and play an Animated sprite from the folder "sprite", at 2x normal size,
// positioned at the center of the screen, rotated 45 degrees around its center,
// and playing in reverse at 24 FPS
AnimatedSprite sprite = new AnimatedSprite("sprite")
                            .setScale(2)
                            .setPosition(width / 2, height / 2)
                            .setImageMode(CENTER)
                            .setAngle(PI / 4)
                            .setFrameRate(24)
                            .setPlaySpeed(-1)
                            .restart();
```

# Fields
### "Writable" fields - these are safe to set directly and will always work as intended if you do.
- `x` (`float`) - The x coordinate of the sprite. Defaults to `0`.
- `y` (`float`) - The y coordinate of the sprite. Defaults to `0`.
- `width` (`float`) - The width of the sprite. Defaults to the width of the first frame.
- `height` (`float`) - The height of the sprite. Defaults to the height of the first frame.
- `angle` (`float`) - The rotation of the sprite in radians. Defaults to `0`.
- `xOffset` (`float`) - The x offset of the sprite. Defaults to `0`.
- `yOffset` (`float`) - The y offset of the sprite. Defaults to `0`.
- `playSpeed` (`float`) - The playback speed of the animation. Negative values reverse the animation. Defaults to `1`.
- `imageMode` (`int`) - The image mode for displaying the sprite, either `CORNER` or `CENTER`. Defaults to `CORNER`. **Using the setter is strongly recommended for this as it checks for invalid values.**
- `paused` (`boolean`) - Whether the animation is paused. Defaults to `false`.
- `looping` (`boolean`) - Whether the animation will return to the start and continue playing when it reaches the end. If `looping` is `false`, the animation will pause when it reaches the end. Defaults to `true`.

### "Read-only" fields - setting these directly will cause undefined behavior (in other words, don't do it!).
- `frames` (`PImage[]`) - An array containing each frame of the animation.
- `currentFrame` (`PImage`) - The frame currently being displayed.
- `frameIndex` (`int`) - The index in `frames` of the current frame.
- `numFrames` (`int`) - The total number of frames in the animation.
- `frameRate` (`float`) - The playback speed of the animation in frames per second.


# Methods
## Constructor
Creates a new `AnimatedSprite` object by loading a series of images from a folder or an array.
```java
PImage[] frames = new PImage[]{
  // animation frames go here
}

AnimatedSprite loadFromArray = new AnimatedSprite(frames);
AnimatedSprite loadFromFolder = new AnimatedSprite("sprite");
```
#### Formats:
- `AnimatedSprite(PImage[] frames)`
- `AnimatedSprite(String path)`

#### Parameters:
- frames (`PImage[]`) - An array of images to use as frames.
- path (`String`) - A path to a folder containing each frame of the animation as an individual image file. Frames are loaded in alphabetical order.


## setPosition
Sets the sprite's position and returns a reference to the sprite for use in a builder.
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
PVector position = new PVector(width / 2, height / 2);

sprite.setPosition(width / 2, height / 2);
sprite.setPosition(position);
```
#### Formats:
- `setPosition(float x, float y)`
- `setPosition(PVector position)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- x (`float`) - The x coordinate of the new position.
- y (`float`) - The y coordinate of the new position.
- position (`PVector`) - A vector with the x and y coordinates of the new position.


## setSize
Sets the sprite's width and height, and returns a reference to the sprite for use in a builder.
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.setSize(200, 200);
```
#### Format:
- `setSize(float width, float height)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- width (`float`) - The new width of the sprite
- height (`float`) - The new height of the sprite


## setScale
Multiplies the sprite's width and height by a scalar, and returns a reference to the sprite for use in a builder.
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.setScale(2);
```
#### Format:
- `setScale(float scalar)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- scalar (`float`) - The scalar to multiply width and height by.


## setAngle
Sets the sprite's rotation in radians, and returns a reference to the sprite for use in a builder.
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.setAngle(PI / 2);
```
#### Format:
- `setAngle(float angle)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- angle (`float`) - The new angle of the sprite in radians.


## setOffset
Sets the sprite's x and y offset and returns a reference to the sprite for use in a builder. This is useful when matching the position of the sprite to another position (such as a player's sprite in a game).
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
PVector offset = new PVector(20, 20);

sprite.setOffset(20, 20);
sprite.setOffset(offset);
```
#### Formats:
- `setOffset(float x, float y)`
- `setOffset(PVector offset)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- x (`float`) - The x coordinate of the new offset.
- y (`float`) - The y coordinate of the new offset.
- position (`PVector`) - A vector with the x and y coordinates of the new offset.


## setImageMode
Sets the image mode used to render the sprite, and returns a reference to the sprite for use in a builder. The image mode for a sprite *does not* affect the image mode in the rest of your sketch, and vice versa. 

The image mode can be either `CORNER` or `CENTER`, and an exception is thrown if an invalid mode is passed. The default mode is `CORNER`.
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.setImageMode(CENTER);
```
#### Format:
- `setImageMode(int imageMode)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- imageMode (`int`) - The new image mode (`CORNER` or `CENTER`).


## setLooping
Sets whether the sprite should loop when it reaches the end of its animation, and returns a reference to the sprite for use in a builder. If the sprite does not loop, it pauses after reaching the end of its animation. The default loop setting is `true`.
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.setLooping(false);
```
#### Format:
- `setLooping(boolean looping)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- looping (`boolean`) - Whether the sprite should loop when it reaches the end of its animation.


## setPlaySpeed
Sets the sprite's playback speed, and returns a reference to the sprite for use in a builder. Values further from 0 mean a higher playback speed, and negative values play the animation in reverse. The default play speed is `1`. 
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.setPlaySpeed(-1);
```
#### Format:
- `setPlaySpeed(float playSpeed)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- playSpeed (`float`) - The new play speed.


## setFrameRate
Sets the sprite's frame rate in frames per second and returns a reference to the sprite for use in a builder. This can be called multiple times, but `setPlaySpeed` is preferred for changing the playback speed. A frame rate of `0` is invalid and attempting to use it throws an exception. The default frame rate is `15`.

**This method does extra calculations behind the scenes. Attempting to set `frameRate` directly will have no effect.**
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.setFrameRate(30);
```
#### Format:
- `setFrameRate(float frameRate)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- frameRate (`float`) - The new frame rate in frames per second.


## setFrame
Sets the which frame is currently being displayed using the frame index, and returns a reference to the sprite for use in a builder. The frame index must be between `0` (inclusive) and `numFrames` (exclusive). Attempting to set the frame index to an invalid number throws an exception.

**`setFrame` and `advanceFrame` are the only ways to change the current frame. Do not attempt to set `frameIndex` or `currentFrame` directly.**
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.setFrame(5);
```
#### Format:
- `setFrame(int frameIndex)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- frameIndex (`int`) - The index of the new frame; must be >= 0 and < `numFrames`.


## advanceFrame
Moves the animation forward or backward by a number of frames, and returns a reference to the sprite for use in a builder. If the offset moves the animation past the end, it will loop to the beginning or pause at the last frame based on whether `looping` is true.

**`setFrame` and `advanceFrame` are the only ways to change the current frame. Do not attempt to set `frameIndex` or `currentFrame` directly.**
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.advanceFrame(5);
```

#### Format:
- `advanceFrame(int offset)`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.

#### Parameters:
- offset (`int`) - The number of frames to move forward or backward by. Positive values move the animation forward and negative values move it backward.


## reset
Returns to the beginning of the sprite's animation, sets `paused` to `true`, and returns a reference to the sprite for use in a builder.
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.reset();
```
#### Format:
- `reset()`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.


## restart
Returns to the beginning of the sprite's animation, sets `paused` to `false`, and returns a reference to the sprite for use in a builder. 
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.restart();
```
#### Format:
- `restart()`

#### Return Value:
`AnimatedSprite` - A reference to the sprite for use in a builder.


## render
Renders the sprite's current frame to a `PGraphics` object, or the main canvas created with `size` if no canvas is passed to it. **If you draw to a PGraphics object, `beginDraw` must be called on it before the sprite is rendered.**
```java
PGraphics pg = createGraphics(400, 400);
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.restart();

sprite.render();

pg.beginDraw();
sprite.render(pg);
sprite.endDraw();
```

#### Format:
- `render(PGraphics pg)`
- `render()`

#### Parameters
- pg (`PGraphics`) - A `PGraphics` object to render the sprite to. Optional, defaults to the main canvas created with `size`.


## update
Updates the sprite's animation without displaying the current frame.
```java
AnimatedSprite sprite = new AnimatedSprite("sprite");
sprite.restart();

sprite.update();
```

#### Format:
- `update()`