// --- CONSTANTES DE LA GRILLE ---
const int kGridSize = 102;

const int kGridFree = 0;
const int kGridPath = 1;
const int kGridFilled = 2;
const int kGridEdge = 3;
// NOUVELLES CONSTANTES pour la lisibilité du code de remplissage
const int kTempFillArea1 = 3;
const int kTempFillArea2 = 4;
const int kSeedScanArea = 5;

const double gameWidth = 150.0;
const double gameHeight = 200.0;

enum Direction { up, down, left, right }
