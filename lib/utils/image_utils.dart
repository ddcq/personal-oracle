String addAssetPrefix(String imagePath) {
  if (imagePath.startsWith('assets/images/')) {
    return imagePath;
  } else {
    return 'assets/images/$imagePath';
  }
}