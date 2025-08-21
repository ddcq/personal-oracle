// --- CONSTANTES DE LA GRILLE ---
import 'package:oracle_d_asgard/utils/int_vector2.dart';

const int kGridSize = 102;

const int kGridFree = 0;
const int kGridPath = 1;
const int kGridFilled = 2;
const int kGridEdge = 3;
// NOUVELLES CONSTANTES pour la lisibilité du code de remplissage
const int kTempFillArea1 = 3;
const int kTempFillArea2 = 4;
const int kSeedScanArea = 5;

const double kBaseWinPercentage = 0.8;
const double kWinPercentageIncrementPerLevel = 0.02;
const double kMaxWinPercentage = 0.96;

const double kBasePlayerSpeedCellsPerSecond = 10.0;
const double kBaseMonsterSpeedCellsPerSecond = 5.0;
const double kPlayerSpeedChangePerLevelCellsPerSecond = 0.5;
const double kMonsterSpeedChangePerLevelCellsPerSecond = 3.0;

const double gameWidth = 150.0;
const double gameHeight = 200.0;



const IntVector2 kDirectionUp = IntVector2(0, -1);
const IntVector2 kDirectionDown = IntVector2(0, 1);
const IntVector2 kDirectionLeft = IntVector2(-1, 0);
const IntVector2 kDirectionRight = IntVector2(1, 0);

const IntVector2 kDirectionUpLeft = IntVector2(-1, -1);
const IntVector2 kDirectionUpRight = IntVector2(1, -1);
const IntVector2 kDirectionDownLeft = IntVector2(-1, 1);
const IntVector2 kDirectionDownRight = IntVector2(1, 1);