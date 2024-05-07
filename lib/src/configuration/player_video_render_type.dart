enum GsyVideoPlayerRenderType {
  //默认TextureView
  textureView,
  //SurfaceView，动画切换等时候效果比较差
  surfaceView,
  //GLSurfaceView、支持滤镜
  gLSurfaceView,
}

GsyVideoPlayerRenderType getGsyVideoPlayerRenderType(int index) {
  switch (index) {
    case 0:
      return GsyVideoPlayerRenderType.textureView;
    case 1:
      return GsyVideoPlayerRenderType.surfaceView;
    case 2:
      return GsyVideoPlayerRenderType.gLSurfaceView;
    default:
      return GsyVideoPlayerRenderType.textureView;
  }
}
