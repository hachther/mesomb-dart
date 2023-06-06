
import 'dart:math';

class RandomGenerator {
static String nonce([int length = 40]) {
String result = '';
const String characters =
'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
int charactersLength = characters.length;
for (int i = 0; i < length; i++) {
result += characters[Random().nextInt(charactersLength)];
}
return result;
}
}