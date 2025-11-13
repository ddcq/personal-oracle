String addAssetPrefix(String imagePath) {
  if (imagePath.startsWith('assets/')) {
    return imagePath;
  } else {
    return 'assets/images/$imagePath'; // Default to general images
  }
}
