part of image;

const int PIXELATE_UPPERLEFT = 0;
const int PIXELATE_AVERAGE = 1;

Image pixelate(Image src, int blockSize, {int mode: PIXELATE_UPPERLEFT}) {
  if (blockSize <= 1) {
    return src;
  }

  switch (mode) {
    case PIXELATE_UPPERLEFT:
      for (int y = 0; y < src.height; y += blockSize) {
        for (int x = 0; x < src.width; x += blockSize) {
          if (src.boundsSafe(x, y)) {
            int c = src.getPixel(x, y);
            fillRectangle(src, x, y, blockSize, blockSize, c);
          }
        }
      }
      break;
    case PIXELATE_AVERAGE:
      for (int y = 0; y < src.height; y += blockSize) {
        for (int x = 0; x < src.width; x += blockSize) {
          int a = 0;
          int r = 0;
          int g = 0;
          int b = 0;
          int total = 0;

          for (int cy = 0; cy < blockSize; ++cy) {
            for (int cx = 0; cx < blockSize; ++cx) {
              if (!src.boundsSafe(x + cx, y + cy)) {
                continue;
              }
              int c = src.getPixel(x + cx, y + cy);
              a += getAlpha(c);
              r += getRed(c);
              g += getGreen(c);
              b += getBlue(c);
              total++;
            }
          }

          if (total > 0) {
            int c = getColor(r ~/ total, g ~/ total, b ~/ total, a ~/ total);
            fillRectangle(src, x, y, blockSize, blockSize, c);
          }
        }
      }
      break;
  }

  return src;
}