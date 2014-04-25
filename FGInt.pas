{License, info, etc
 ------------------
This implementation is made by me, Walied Othman, to contact me
mail to rainwolf@submanifold.be or triade@submanifold.be ,
always mention wether it 's about the FGInt or about the 6xs, 
preferably in the subject line.
This source code is free, but only to other free software, 
it's a two-way street, if you use this code in an application from which 
you won't make any money of (e.g. software for the good of mankind) 
then go right ahead, I won't stop you, I do demand acknowledgement for 
my work.  However, if you're using this code in a commercial application, 
an application from which you'll make money, then yes, I charge a 
license-fee, as described in the license agreement for commercial use, see 
the textfile in this zip-file.
If you 're going to use these implementations, let me know, so I ca, put a link 
on my page if desired, I 'm always curious as to see where the spawn of my 
mind ends up in.  If any algorithm is patented in your country, you should
acquire a license before using this software.  Modified versions of this
software must contain an acknowledgement of the original author (=me).

This implementation is available at 
http://www.submanifold.be

copyright 2000, Walied Othman
This header may not be removed.}

Unit FGInt;

{$H+}{$LongStrings ON}  

Interface

Uses SysUtils, Math;

Type
   TCompare = (Lt, St, Eq, Er);
   TSign = (negative, positive);
   TFGInt = Record
      Sign : TSign;
      Number : Array Of LongWord;
   End;

Procedure FGIntDestroy(Var FGInt : TFGInt);
Procedure FGIntCopy(Const FGInt1 : TFGInt; Var FGInt2 : TFGInt);
Function FGIntCompareAbs(Const FGInt1, FGInt2 : TFGInt) : TCompare;
Procedure FGIntAbs(Var FGInt : TFGInt);
Procedure FGIntShiftLeftBy32(Var FGInt : TFGInt);
Procedure FGIntShiftRight(Var FGInt : TFGInt);
Procedure FGIntShiftRightBy32(Var FGInt : TFGInt);
Procedure FGIntShiftLeftBy32Times(Var FGInt : TFGInt; times : LongWord);
Procedure FGIntShiftRightBy32Times(Var FGInt : TFGInt; times : LongWord);
Procedure FGIntToBase2String(Const FGInt : TFGInt; Var S : String);
Procedure Base2StringToFGInt(S : String; Var FGInt : TFGInt);
Procedure Base10StringToFGInt(Base10 : String; Var FGInt : TFGInt);
Procedure FGIntToBase10String(Const FGInt : TFGInt; Var Base10 : String);

Procedure FGIntDivByIntBis(Var FGInt : TFGInt; by : LongWord; Var modres : LongWord);
Procedure FGIntAdd(Const FGInt1, FGInt2 : TFGInt; Var Sum : TFGInt);
Procedure FGIntChangeSign(Var FGInt : TFGInt);
Procedure FGIntSub(Var FGInt1, FGInt2, dif : TFGInt);
Procedure FGIntAddBis(Var FGInt1 : TFGInt; Const FGInt2 : TFGInt);
Procedure FGIntSubBis(Var FGInt1 : TFGInt; Const FGInt2 : TFGInt);
Procedure FGIntPencilPaperMultiply(Const FGInt1, FGInt2 : TFGInt; Var Prod : TFGInt);
Procedure FGIntKaratsubaMultiply(Const FGInt1, FGInt2 : TFGInt; Var Prod : TFGInt);
// Procedure FGIntKaratsubaMultiply(Const FGInt1, FGInt2 : TFGInt; Var Prod : TFGInt; Const karatsubaThreshold : LongWord);
Procedure FGIntMul(Const FGInt1, FGInt2 : TFGInt; Var Prod : TFGInt);
Procedure FGIntPencilPaperSquare(Const FGInt : TFGInt; Var Square : TFGInt);
// Procedure FGIntKaratsubaSquare(Const FGInt : TFGInt; Var Square : TFGInt; Const karatsubaThreshold : LongWord);
Procedure FGIntKaratsubaSquare(Const FGInt : TFGInt; Var Square : TFGInt);
Procedure FGIntSquare(Const FGInt : TFGInt; Var Square : TFGInt);




Implementation

Var
   primes : Array[1..1228] Of integer =
      (3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127,
      131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251,
      257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389,
      397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541,
      547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677,
      683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839,
      853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997, 1009,
      1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097, 1103, 1109, 1117, 1123,
      1129, 1151, 1153, 1163, 1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223, 1229, 1231, 1237, 1249, 1259, 1277, 1279,
      1283, 1289, 1291, 1297, 1301, 1303, 1307, 1319, 1321, 1327, 1361, 1367, 1373, 1381, 1399, 1409, 1423, 1427, 1429,
      1433, 1439, 1447, 1451, 1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493, 1499, 1511, 1523, 1531, 1543, 1549, 1553,
      1559, 1567, 1571, 1579, 1583, 1597, 1601, 1607, 1609, 1613, 1619, 1621, 1627, 1637, 1657, 1663, 1667, 1669, 1693,
      1697, 1699, 1709, 1721, 1723, 1733, 1741, 1747, 1753, 1759, 1777, 1783, 1787, 1789, 1801, 1811, 1823, 1831, 1847,
      1861, 1867, 1871, 1873, 1877, 1879, 1889, 1901, 1907, 1913, 1931, 1933, 1949, 1951, 1973, 1979, 1987, 1993, 1997,
      1999, 2003, 2011, 2017, 2027, 2029, 2039, 2053, 2063, 2069, 2081, 2083, 2087, 2089, 2099, 2111, 2113, 2129, 2131,
      2137, 2141, 2143, 2153, 2161, 2179, 2203, 2207, 2213, 2221, 2237, 2239, 2243, 2251, 2267, 2269, 2273, 2281, 2287,
      2293, 2297, 2309, 2311, 2333, 2339, 2341, 2347, 2351, 2357, 2371, 2377, 2381, 2383, 2389, 2393, 2399, 2411, 2417,
      2423, 2437, 2441, 2447, 2459, 2467, 2473, 2477, 2503, 2521, 2531, 2539, 2543, 2549, 2551, 2557, 2579, 2591, 2593,
      2609, 2617, 2621, 2633, 2647, 2657, 2659, 2663, 2671, 2677, 2683, 2687, 2689, 2693, 2699, 2707, 2711, 2713, 2719,
      2729, 2731, 2741, 2749, 2753, 2767, 2777, 2789, 2791, 2797, 2801, 2803, 2819, 2833, 2837, 2843, 2851, 2857, 2861,
      2879, 2887, 2897, 2903, 2909, 2917, 2927, 2939, 2953, 2957, 2963, 2969, 2971, 2999, 3001, 3011, 3019, 3023, 3037,
      3041, 3049, 3061, 3067, 3079, 3083, 3089, 3109, 3119, 3121, 3137, 3163, 3167, 3169, 3181, 3187, 3191, 3203, 3209,
      3217, 3221, 3229, 3251, 3253, 3257, 3259, 3271, 3299, 3301, 3307, 3313, 3319, 3323, 3329, 3331, 3343, 3347, 3359,
      3361, 3371, 3373, 3389, 3391, 3407, 3413, 3433, 3449, 3457, 3461, 3463, 3467, 3469, 3491, 3499, 3511, 3517, 3527,
      3529, 3533, 3539, 3541, 3547, 3557, 3559, 3571, 3581, 3583, 3593, 3607, 3613, 3617, 3623, 3631, 3637, 3643, 3659,
      3671, 3673, 3677, 3691, 3697, 3701, 3709, 3719, 3727, 3733, 3739, 3761, 3767, 3769, 3779, 3793, 3797, 3803, 3821,
      3823, 3833, 3847, 3851, 3853, 3863, 3877, 3881, 3889, 3907, 3911, 3917, 3919, 3923, 3929, 3931, 3943, 3947, 3967,
      3989, 4001, 4003, 4007, 4013, 4019, 4021, 4027, 4049, 4051, 4057, 4073, 4079, 4091, 4093, 4099, 4111, 4127, 4129,
      4133, 4139, 4153, 4157, 4159, 4177, 4201, 4211, 4217, 4219, 4229, 4231, 4241, 4243, 4253, 4259, 4261, 4271, 4273,
      4283, 4289, 4297, 4327, 4337, 4339, 4349, 4357, 4363, 4373, 4391, 4397, 4409, 4421, 4423, 4441, 4447, 4451, 4457,
      4463, 4481, 4483, 4493, 4507, 4513, 4517, 4519, 4523, 4547, 4549, 4561, 4567, 4583, 4591, 4597, 4603, 4621, 4637,
      4639, 4643, 4649, 4651, 4657, 4663, 4673, 4679, 4691, 4703, 4721, 4723, 4729, 4733, 4751, 4759, 4783, 4787, 4789,
      4793, 4799, 4801, 4813, 4817, 4831, 4861, 4871, 4877, 4889, 4903, 4909, 4919, 4931, 4933, 4937, 4943, 4951, 4957,
      4967, 4969, 4973, 4987, 4993, 4999, 5003, 5009, 5011, 5021, 5023, 5039, 5051, 5059, 5077, 5081, 5087, 5099, 5101,
      5107, 5113, 5119, 5147, 5153, 5167, 5171, 5179, 5189, 5197, 5209, 5227, 5231, 5233, 5237, 5261, 5273, 5279, 5281,
      5297, 5303, 5309, 5323, 5333, 5347, 5351, 5381, 5387, 5393, 5399, 5407, 5413, 5417, 5419, 5431, 5437, 5441, 5443,
      5449, 5471, 5477, 5479, 5483, 5501, 5503, 5507, 5519, 5521, 5527, 5531, 5557, 5563, 5569, 5573, 5581, 5591, 5623,
      5639, 5641, 5647, 5651, 5653, 5657, 5659, 5669, 5683, 5689, 5693, 5701, 5711, 5717, 5737, 5741, 5743, 5749, 5779,
      5783, 5791, 5801, 5807, 5813, 5821, 5827, 5839, 5843, 5849, 5851, 5857, 5861, 5867, 5869, 5879, 5881, 5897, 5903,
      5923, 5927, 5939, 5953, 5981, 5987, 6007, 6011, 6029, 6037, 6043, 6047, 6053, 6067, 6073, 6079, 6089, 6091, 6101,
      6113, 6121, 6131, 6133, 6143, 6151, 6163, 6173, 6197, 6199, 6203, 6211, 6217, 6221, 6229, 6247, 6257, 6263, 6269,
      6271, 6277, 6287, 6299, 6301, 6311, 6317, 6323, 6329, 6337, 6343, 6353, 6359, 6361, 6367, 6373, 6379, 6389, 6397,
      6421, 6427, 6449, 6451, 6469, 6473, 6481, 6491, 6521, 6529, 6547, 6551, 6553, 6563, 6569, 6571, 6577, 6581, 6599,
      6607, 6619, 6637, 6653, 6659, 6661, 6673, 6679, 6689, 6691, 6701, 6703, 6709, 6719, 6733, 6737, 6761, 6763, 6779,
      6781, 6791, 6793, 6803, 6823, 6827, 6829, 6833, 6841, 6857, 6863, 6869, 6871, 6883, 6899, 6907, 6911, 6917, 6947,
      6949, 6959, 6961, 6967, 6971, 6977, 6983, 6991, 6997, 7001, 7013, 7019, 7027, 7039, 7043, 7057, 7069, 7079, 7103,
      7109, 7121, 7127, 7129, 7151, 7159, 7177, 7187, 7193, 7207, 7211, 7213, 7219, 7229, 7237, 7243, 7247, 7253, 7283,
      7297, 7307, 7309, 7321, 7331, 7333, 7349, 7351, 7369, 7393, 7411, 7417, 7433, 7451, 7457, 7459, 7477, 7481, 7487,
      7489, 7499, 7507, 7517, 7523, 7529, 7537, 7541, 7547, 7549, 7559, 7561, 7573, 7577, 7583, 7589, 7591, 7603, 7607,
      7621, 7639, 7643, 7649, 7669, 7673, 7681, 7687, 7691, 7699, 7703, 7717, 7723, 7727, 7741, 7753, 7757, 7759, 7789,
      7793, 7817, 7823, 7829, 7841, 7853, 7867, 7873, 7877, 7879, 7883, 7901, 7907, 7919, 7927, 7933, 7937, 7949, 7951,
      7963, 7993, 8009, 8011, 8017, 8039, 8053, 8059, 8069, 8081, 8087, 8089, 8093, 8101, 8111, 8117, 8123, 8147, 8161,
      8167, 8171, 8179, 8191, 8209, 8219, 8221, 8231, 8233, 8237, 8243, 8263, 8269, 8273, 8287, 8291, 8293, 8297, 8311,
      8317, 8329, 8353, 8363, 8369, 8377, 8387, 8389, 8419, 8423, 8429, 8431, 8443, 8447, 8461, 8467, 8501, 8513, 8521,
      8527, 8537, 8539, 8543, 8563, 8573, 8581, 8597, 8599, 8609, 8623, 8627, 8629, 8641, 8647, 8663, 8669, 8677, 8681,
      8689, 8693, 8699, 8707, 8713, 8719, 8731, 8737, 8741, 8747, 8753, 8761, 8779, 8783, 8803, 8807, 8819, 8821, 8831,
      8837, 8839, 8849, 8861, 8863, 8867, 8887, 8893, 8923, 8929, 8933, 8941, 8951, 8963, 8969, 8971, 8999, 9001, 9007,
      9011, 9013, 9029, 9041, 9043, 9049, 9059, 9067, 9091, 9103, 9109, 9127, 9133, 9137, 9151, 9157, 9161, 9173, 9181,
      9187, 9199, 9203, 9209, 9221, 9227, 9239, 9241, 9257, 9277, 9281, 9283, 9293, 9311, 9319, 9323, 9337, 9341, 9343,
      9349, 9371, 9377, 9391, 9397, 9403, 9413, 9419, 9421, 9431, 9433, 9437, 9439, 9461, 9463, 9467, 9473, 9479, 9491,
      9497, 9511, 9521, 9533, 9539, 9547, 9551, 9587, 9601, 9613, 9619, 9623, 9629, 9631, 9643, 9649, 9661, 9677, 9679,
      9689, 9697, 9719, 9721, 9733, 9739, 9743, 9749, 9767, 9769, 9781, 9787, 9791, 9803, 9811, 9817, 9829, 9833, 9839,
      9851, 9857, 9859, 9871, 9883, 9887, 9901, 9907, 9923, 9929, 9931, 9941, 9949, 9967, 9973);
   chr64 : Array[1..64] Of char = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
      'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
      'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y',
      'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/');
    karatsubaThreshold : Longword = 90;
    karatsubaSquaringThreshold : Longword = 175;











// Destroy a FGInt to free memory

Procedure FGIntDestroy(Var FGInt : TFGInt);
Begin
   FGInt.Number := Nil;
End;


// Returns the FGInt in absolute value

Procedure FGIntAbs(Var FGInt : TFGInt);
Begin
   FGInt.Sign := positive;
End;


// Copy a FGInt1 into FGInt2

Procedure FGIntCopy(Const FGInt1 : TFGInt; Var FGInt2 : TFGInt);
Begin
   FGInt2.Sign := FGInt1.Sign;
   FGInt2.Number := Nil;
   FGInt2.Number := Copy(FGInt1.Number, 0, FGInt1.Number[0] + 1);
End;


// Compare 2 FGInts in absolute value, returns
// Lt if FGInt1 > FGInt2, St if FGInt1 < FGInt2, Eq if FGInt1 = FGInt2,
// Er otherwise

Function FGIntCompareAbs(Const FGInt1, FGInt2 : TFGInt) : TCompare;
Var
   size1, size2, i : LongWord;
Begin
   FGIntCompareAbs := Er;
   size1 := FGInt1.Number[0];
   size2 := FGInt2.Number[0];
   If size1 > size2 Then FGIntCompareAbs := Lt Else
      If size1 < size2 Then FGIntCompareAbs := St Else
      Begin
         i := size2;
         While (FGInt1.Number[i] = FGInt2.Number[i]) And (i > 1) Do i := i - 1;
         If FGInt1.Number[i] = FGInt2.Number[i] Then FGIntCompareAbs := Eq Else
            If FGInt1.Number[i] < FGInt2.Number[i] Then FGIntCompareAbs := St Else
               If FGInt1.Number[i] > FGInt2.Number[i] Then FGIntCompareAbs := Lt;
      End;
End;


// Shift the FGInt to the left in base 2 notation, ie FGInt = FGInt * 2

Procedure FGIntShiftLeft(Var FGInt : TFGInt);
Var
   l, m, i, size : LongWord;
Begin
   size := FGInt.Number[0];
   l := 0;
   For i := 1 To Size Do
   Begin
      m := FGInt.Number[i] Shr 31;
      FGInt.Number[i] := ((FGInt.Number[i] Shl 1) Or l) And 4294967295;
      l := m;
   End;
   If l <> 0 Then
   Begin
      setlength(FGInt.Number, size + 2);
      FGInt.Number[size + 1] := l;
      FGInt.Number[0] := size + 1;
   End;
End;


// FGInt = FGInt * 4294967296

Procedure FGIntShiftLeftBy32(Var FGInt : TFGInt);
Var
   f1, f2 : LongWord;
   i, size : longint;
Begin
   if ((FGInt.Number[0] = 1) and (FGInt.Number[1] = 0)) then Exit;
   size := FGInt.Number[0];
   SetLength(FGInt.Number, size + 2);
   f1 := 0;
   For i := 1 To (size + 1) Do
   Begin
      f2 := FGInt.Number[i];
      FGInt.Number[i] := f1;
      f1 := f2;
   End;
   FGInt.Number[0] := size + 1;
End;


// Shift the FGInt to the right in base 2 notation, ie FGInt = FGInt div 2

Procedure FGIntShiftRight(Var FGInt : TFGInt);
Var
   l, m, i, size : LongWord;
Begin
   size := FGInt.Number[0];
   l := 0;
   For i := size Downto 1 Do
   Begin
      m := FGInt.Number[i] And 1;
      FGInt.Number[i] := (FGInt.Number[i] Shr 1) Or l;
      l := m Shl 31;
   End;
   If (FGInt.Number[size] = 0) And (size > 1) Then
   Begin
      setlength(FGInt.Number, size);
      FGInt.Number[0] := size - 1;
   End;
End;


// FGInt = FGInt / 4294967296

Procedure FGIntShiftRightBy32(Var FGInt : TFGInt);
Var
   size, i : LongWord;
Begin
   size := FGInt.Number[0];
   If size > 1 Then
   Begin
      For i := 1 To size - 1 Do
      Begin
         FGInt.Number[i] := FGInt.Number[i + 1];
      End;
      SetLength(FGInt.Number, Size);
      FGInt.Number[0] := size - 1;
   End
   Else
      FGInt.Number[1] := 0;
End;


Procedure FGIntShiftLeftBy32Times(Var FGInt : TFGInt; times : LongWord);
Var
   i, size : longint;
Begin
   if times = 0 then Exit;
   if not ((FGInt.Number[0] = 1) and (FGInt.Number[1] = 0)) then
   begin
      size := FGInt.Number[0];
      SetLength(FGInt.Number, size + 1 + times);
      For i := size Downto 1 Do
      Begin
         FGInt.Number[i + times] := FGInt.Number[i];
      End;
      For i := 1 To times Do
      Begin
         FGInt.Number[i] := 0;
      End;
      FGInt.Number[0] := size + times;
   end;
End;

Procedure FGIntShiftRightBy32Times(Var FGInt : TFGInt; times : LongWord);
Var
   i, size : longint;
Begin
   if times = 0 then Exit;
   size := FGInt.Number[0];
   if times >= size then
   begin
      SetLength(FGInt.Number, 2);
      FGInt.Number[0] := 1;
      FGInt.Number[1] := 0;
   end 
   else if not ((FGInt.Number[0] = 1) and (FGInt.Number[1] = 0)) then
   begin
      For i := 1 to (size - times) Do
      Begin
         FGInt.Number[i] := FGInt.Number[i + times];
      End;
      FGInt.Number[0] := size - times;
      SetLength(FGInt.Number, size + 1 - times);
   end;
End;






// Convert a FGInt to a binary string (base 2) & visa versa

Procedure FGIntToBase2String(Const FGInt : TFGInt; Var S : String);
Var
   i : LongWord;
   j : integer;
Begin
   S := '';
   For i := 1 To FGInt.Number[0] Do
   Begin
      For j := 0 To 31 Do
         If (1 And (FGInt.Number[i] Shr j)) = 1 Then
            S := '1' + S
         Else
            S := '0' + S;
   End;
   While (length(S) > 1) And (S[1] = '0') Do
      delete(S, 1, 1);
   If S = '' Then S := '0';
End;


Procedure Base2StringToFGInt(S : String; Var FGInt : TFGInt);
Var
   i, j, size : LongWord;
Begin
   While (S[1] = '0') And (length(S) > 1) Do
      delete(S, 1, 1);
   size := length(S) Div 32;
   If (length(S) Mod 32) <> 0 Then size := size + 1;
   SetLength(FGInt.Number, (size + 1));
   FGInt.Number[0] := size;
   j := 1;
   FGInt.Number[j] := 0;
   i := 0;
   While length(S) > 0 Do
   Begin
      If S[length(S)] = '1' Then
         FGInt.Number[j] := FGInt.Number[j] Or (1 Shl i);
      i := i + 1;
      If i = 32 Then
      Begin
         i := 0;
         j := j + 1;
         If j <= size Then FGInt.Number[j] := 0;
      End;
      delete(S, length(S), 1);
   End;
   FGInt.Sign := positive;
End;



// Convert a base 10 string to a FGInt

Procedure Base10StringToFGInt(Base10 : String; Var FGInt : TFGInt);
Var
   i, size : LongWord;
   j : word;
   S, x : String;
   sign : TSign;

   Procedure FGIntDivByIntBis1(Var GInt : TFGInt; by : LongWord; Var modres : word);
   Var
      i, size, rest, temp : LongWord;
   Begin
      size := GInt.Number[0];
      temp := 0;
      For i := size Downto 1 Do
      Begin
         temp := temp * 10000;
         rest := temp + GInt.Number[i];
         GInt.Number[i] := rest Div by;
         temp := rest Mod by;
      End;
      modres := temp;
      While (GInt.Number[size] = 0) And (size > 1) Do
         size := size - 1;
      If size <> GInt.Number[0] Then
      Begin
         SetLength(GInt.Number, size + 1);
         GInt.Number[0] := size;
      End;
   End;

Begin
   While (Not (Base10[1] In ['-', '0'..'9'])) And (length(Base10) > 1) Do
      delete(Base10, 1, 1);
   If copy(Base10, 1, 1) = '-' Then
   Begin
      Sign := negative;
      delete(Base10, 1, 1);
   End
   Else
      Sign := positive;
   While (length(Base10) > 1) And (copy(Base10, 1, 1) = '0') Do
      delete(Base10, 1, 1);
   size := length(Base10) Div 4;
   If (length(Base10) Mod 4) <> 0 Then size := size + 1;
   SetLength(FGInt.Number, size + 1);
   FGInt.Number[0] := size;
   For i := 1 To (size - 1) Do
   Begin
      x := copy(Base10, length(Base10) - 3, 4);
      FGInt.Number[i] := StrToInt(x);
      delete(Base10, length(Base10) - 3, 4);
   End;
   FGInt.Number[size] := StrToInt(Base10);

   S := '';
   While (FGInt.Number[0] <> 1) Or (FGInt.Number[1] <> 0) Do
   Begin
      FGIntDivByIntBis1(FGInt, 2, j);
      S := inttostr(j) + S;
   End;
   If S = '' Then S := '0';
   FGIntDestroy(FGInt);
   Base2StringToFGInt(S, FGInt);
   FGInt.Sign := sign;
End;


// Convert a FGInt to a base 10 string

Procedure FGIntToBase10String(Const FGInt : TFGInt; Var Base10 : String);
Var
   S : String;
   j : LongWord;
   temp : TFGInt;
Begin
   FGIntCopy(FGInt, temp);
   Base10 := '';
   While not ((temp.Number[0] = 1) and (temp.Number[1] = 0)) Do
   Begin
      FGIntDivByIntBis(temp, 10000, j);
      S := IntToStr(j);
      While Length(S) < 4 Do
      begin
         S := '0' + S;
      end;
      Base10 := S + Base10;
   End;
   Base10 := '0' + Base10;
   While (length(Base10) > 1) And (Base10[1] = '0') Do
      delete(Base10, 1, 1);
   If FGInt.Sign = negative Then Base10 := '-' + Base10;
End;


// divide a FGInt by an integer, FGInt = FGInt * by + modres

Procedure FGIntDivByIntBis(Var FGInt : TFGInt; by : LongWord; Var modres : LongWord);
Var
   i, size : LongWord;
   temp, rest : int64;
Begin
   size := FGInt.Number[0];
   temp := 0;
   For i := size Downto 1 Do
   Begin
      temp := temp Shl 32;
      rest := temp Or FGInt.Number[i];
      FGInt.Number[i] := rest Div by;
      temp := rest Mod by;
   End;
   modres := temp;
   While (FGInt.Number[size] = 0) And (size > 1) Do
      size := size - 1;
   If size <> FGInt.Number[0] Then
   Begin
      SetLength(FGInt.Number, size + 1);
      FGInt.Number[0] := size;
   End;
End;



// Add 2 FGInts, FGInt1 + FGInt2 = Sum

Procedure FGIntAdd(Const FGInt1, FGInt2 : TFGInt; Var Sum : TFGInt);
Var
   i, size1, size2, size, rest : LongWord;
   Trest : int64;
Begin
   size1 := FGInt1.Number[0];
   size2 := FGInt2.Number[0];
   If size1 < size2 Then
      FGIntAdd(FGInt2, FGInt1, Sum)
   Else
   Begin
      If FGInt1.Sign = FGInt2.Sign Then
      Begin
         Sum.Sign := FGInt1.Sign;
         setlength(Sum.Number, (size1 + 2));
         rest := 0;
         For i := 1 To size2 Do
         Begin
            Trest := FGInt1.Number[i];
            Trest := Trest + FGInt2.Number[i];
            Trest := Trest + rest;
            Sum.Number[i] := Trest And 4294967295;
            rest := Trest Shr 32;
         End;
         For i := (size2 + 1) To size1 Do
         Begin
            Trest := FGInt1.Number[i] + rest;
            Sum.Number[i] := Trest And 4294967295;
            rest := Trest Shr 32;
         End;
         size := size1 + 1;
         Sum.Number[0] := size;
         Sum.Number[size] := rest;
         While (Sum.Number[size] = 0) And (size > 1) Do
            size := size - 1;
         If Sum.Number[0] <> size Then SetLength(Sum.Number, size + 1);
         Sum.Number[0] := size;
      End
      Else
      Begin
         If FGIntCompareAbs(FGInt2, FGInt1) = Lt Then
            FGIntAdd(FGInt2, FGInt1, Sum)
         Else
         Begin
            SetLength(Sum.Number, (size1 + 1));
            rest := 0;
            For i := 1 To size2 Do
            Begin
               Trest := 4294967296;
               TRest := Trest + FGInt1.Number[i];
               TRest := Trest - FGInt2.Number[i];
               TRest := Trest - rest;
               Sum.Number[i] := Trest And 4294967295;
               If (Trest > 4294967295) Then
                  rest := 0
               Else
                  rest := 1;
            End;
            For i := (size2 + 1) To size1 Do
            Begin
               Trest := 4294967296;
               TRest := Trest + FGInt1.Number[i];
               TRest := Trest - rest;
               Sum.Number[i] := Trest And 4294967295;
               If (Trest > 4294967295) Then
                  rest := 0
               Else
                  rest := 1;
            End;
            size := size1;
            While (Sum.Number[size] = 0) And (size > 1) Do
               size := size - 1;
            If size <> size1 Then SetLength(Sum.Number, size + 1);
            Sum.Number[0] := size;
            Sum.Sign := FGInt1.Sign;
         End;
      End;
   End;
End;



Procedure FGIntChangeSign(Var FGInt : TFGInt);
Begin
   If FGInt.Sign = negative Then FGInt.Sign := positive Else FGInt.Sign := negative;
End;


// Substract 2 FGInts, FGInt1 - FGInt2 = dif

Procedure FGIntSub(Var FGInt1, FGInt2, dif : TFGInt);
Begin
   FGIntChangeSign(FGInt2);
   FGIntAdd(FGInt1, FGInt2, dif);
   FGIntChangeSign(FGInt2);
End;


Procedure FGIntAddBis(Var FGInt1 : TFGInt; Const FGInt2 : TFGInt);
Var
   i, size1, size2, rest, minLength, maxLength : LongWord;
   Trest : int64;
   tmpFGInt1, tmpFGInt2 : TFGInt;
Begin
   size1 := FGInt1.Number[0];
   size2 := FGInt2.Number[0];
   if size1 < size2 then 
   begin
      minLength := size1;
      maxLength := size2;
      FGIntCopy(FGInt2, tmpFGInt1);
      tmpFGInt2 := FGInt1;
   end else 
   begin
      minLength := size2;
      maxLength := size1;
      tmpFGInt2 := FGInt2;
      tmpFGInt1 := FGInt1;
   end;
   rest := 0;
// if size1 < size2 then writeln('uh-ohhhh add '+IntToStr(size1) + ' ' + inttostr(size2) + ' hahaha fys: ' + inttostr(FGInt1.Number[1]));
   For i := 1 To minLength Do
   Begin
      Trest := tmpFGInt1.Number[i];
      Trest := Trest + tmpFGInt2.Number[i] + rest;
      rest := Trest Shr 32;
      tmpFGInt1.Number[i] := Trest And 4294967295;
   End;
   For i := minLength + 1 To maxLength Do
   Begin
      if rest = 0 then break;
      Trest := tmpFGInt1.Number[i];
      Trest := Trest + rest;
      rest := Trest Shr 32;
      tmpFGInt1.Number[i] := Trest And 4294967295;
   End;
   If rest <> 0 Then
   Begin
      SetLength(tmpFGInt1.Number, maxLength + 2);
      tmpFGInt1.Number[0] := maxLength + 1;
      tmpFGInt1.Number[maxLength + 1] := rest;
   End;
   If size1 < maxLength then
   begin
      FGIntDestroy(FGInt1);
   end; 
   FGInt1 := tmpFGInt1;
End;


// FGInt1 = FGInt1 - FGInt2, use only when 0 < FGInt2 < FGInt1

Procedure FGIntSubBis(Var FGInt1 : TFGInt; Const FGInt2 : TFGInt);
Var
   i, size1, size2, rest : LongWord;
   Trest : int64;
Begin
   size1 := FGInt1.Number[0];
   size2 := FGInt2.Number[0];
// if size1 < size2 then writeln('uh-ohhhh '+IntToStr(size1) + ' ' + inttostr(size2) + ' hahaha fys: ' + inttostr(FGInt1.Number[1]));
   rest := 0;
   For i := 1 To size2 Do
   Begin
      Trest := (4294967296 Or FGInt1.Number[i]) - FGInt2.Number[i] - rest;
      If (Trest > 4294967295) Then
         rest := 0
      Else
         rest := 1;
      FGInt1.Number[i] := Trest And 4294967295;
   End;
   For i := size2 + 1 To size1 Do
   Begin
      Trest := (4294967296 Or FGInt1.Number[i]) - rest;
      If (Trest > 4294967295) Then
         rest := 0
      Else
         rest := 1;
      FGInt1.Number[i] := Trest And 4294967295;
   End;
   i := size1;
   While (FGInt1.Number[i] = 0) And (i > 1) Do
      i := i - 1;
   If i <> size1 Then
   Begin
      SetLength(FGInt1.Number, i + 1);
      FGInt1.Number[0] := i;
   End;
End;



// Multiply 2 FGInts with the pencil-and-paper method

Procedure FGIntPencilPaperMultiply(Const FGInt1, FGInt2 : TFGInt; Var Prod : TFGInt);
Var
   i, j, size, size1, size2, rest : LongWord;
   Trest : uint64;
Begin
   size1 := FGInt1.Number[0];
   size2 := FGInt2.Number[0];
   size := size1 + size2;
   SetLength(Prod.Number, (size + 1));
   For i := 1 To size Do
      Prod.Number[i] := 0;

   For i := 1 To size2 Do
   Begin
      rest := 0;
      For j := 1 To size1 Do
      Begin
         Trest := FGInt1.Number[j];
         Trest := Trest * FGInt2.Number[i];
         Trest := Trest + Prod.Number[j + i - 1];
         Trest := Trest + rest;
         Prod.Number[j + i - 1] := Trest And 4294967295;
         rest := Trest Shr 32;
      End;
      Prod.Number[i + size1] := rest;
   End;

   Prod.Number[0] := size;
   While (Prod.Number[size] = 0) And (size > 1) Do
      size := size - 1;
   If size <> Prod.Number[0] Then
   Begin
      SetLength(Prod.Number, size + 1);
      Prod.Number[0] := size;
   End;
   If FGInt1.Sign = FGInt2.Sign Then
      Prod.Sign := Positive
   Else
      prod.Sign := negative;
End;


// Procedure FGIntKaratsubaMultiply(Const FGInt1, FGInt2 : TFGInt; Var Prod : TFGInt; Const karatsubaThreshold : LongWord);

Procedure FGIntKaratsubaMultiply(Const FGInt1, FGInt2 : TFGInt; Var Prod : TFGInt);
Var
   halfLength, size1, size2, max : LongWord;
   f1a, f1b, f2a, f2b, faa, fbb, fab, f1ab, f2ab, zero : TFGInt;
Begin
   size1 := FGInt1.Number[0];
   size2 := FGInt2.Number[0];
   if (size1 < size2) Then max := size2 Else max := size1;
   if (max < karatsubaThreshold) Then 
   Begin
      FGIntPencilPaperMultiply(FGInt1, FGInt2, Prod);
      Exit;
   End; 

   if (size1 < max) Then
   Begin
      // FGIntKaratsubaMultiply(FGInt2, FGInt1, Prod, karatsubaThreshold);
      FGIntKaratsubaMultiply(FGInt2, FGInt1, Prod);
      Exit;
   End;

   halfLength := (max Div 2) + (max mod 2);
   f1b.Sign := FGInt1.Sign;
   f1a.Sign := FGInt1.Sign;
   f1b.Number := copy(FGInt1.Number, 0, halfLength + 1);
   f1b.Number[0] := halfLength;
   f1a.Number := copy(FGInt1.Number, halfLength, size1 - halfLength + 1);
   f1a.Number[0] := size1 - halfLength;

   Base2StringToFGInt('0', zero);

   if (size2 <= halfLength) then
   Begin
      FGIntCopy(zero, f2a);
      FGIntCopy(FGInt2, f2b);
   End else
   Begin
      f2b.Sign := FGInt2.Sign;
      f2a.Sign := FGInt2.Sign;
      f2b.Number := copy(FGInt2.Number, 0, halfLength + 1);
      f2b.Number[0] := halfLength;
      f2a.Number := copy(FGInt2.Number, halfLength, size2 - halfLength + 1);
      f2a.Number[0] := size2 - halfLength;
   end;

   if ((FGIntCompareAbs(f1a, zero) <> Eq) and (FGIntCompareAbs(f2a, zero) <> Eq)) then
   begin
      FGIntKaratsubaMultiply(f1a, f2a, faa);
      // FGIntKaratsubaMultiply(f1a, f2a, faa, karatsubaThreshold);
   end 
   else
   begin
      FGIntCopy(zero, faa);
   end;

   if ((FGIntCompareAbs(f1b, zero) <> Eq) and (FGIntCompareAbs(f2b, zero) <> Eq)) then
   begin
      // FGIntKaratsubaMultiply(f1b, f2b, fbb, karatsubaThreshold);
      FGIntKaratsubaMultiply(f1b, f2b, fbb);
   end 
   else
   begin
      FGIntCopy(zero, fbb);
   end;


   FGIntAdd(f1a, f1b, f1ab);
   FGIntAdd(f2a, f2b, f2ab);
   FGIntDestroy(f1a);   
   FGIntDestroy(f1b);   
   FGIntDestroy(f2a);   
   FGIntDestroy(f2b);   

   if ((FGIntCompareAbs(f1ab, zero) <> Eq) and (FGIntCompareAbs(f2ab, zero) <> Eq)) then
   begin
      // FGIntKaratsubaMultiply(f1ab, f2ab, fab, karatsubaThreshold);
      FGIntKaratsubaMultiply(f1ab, f2ab, fab);
   end
   else
   begin
      FGIntCopy(zero, fab);
   end;


   FGIntDestroy(zero);
   FGIntDestroy(f1ab);
   FGIntDestroy(f2ab);
   FGIntSubBis(fab, faa);
   FGIntSubBis(fab, fbb);


   Prod := faa;
   FGIntShiftLeftBy32Times(Prod, halfLength * 2);
   FGIntShiftLeftBy32Times(fab, halfLength);
   FGIntAddBis(prod, fab);
   FGIntAddBis(prod, fbb);

   if fGInt1.sign = fGInt2.sign then Prod.sign := positive else Prod.sign := negative;

   FGIntDestroy(fab);
   FGIntDestroy(fbb);
End;



// Multiply 2 FGInts, FGInt1 * FGInt2 = Prod

Procedure FGIntMul(Const FGInt1, FGInt2 : TFGInt; Var Prod : TFGInt);
Var
   size1, size2 : LongWord;
Begin
   size1 := FGInt1.Number[0];
   size2 := FGInt2.Number[0];
   if (size1 > karatsubaThreshold) or (size2 > karatsubaThreshold) then
      FGIntKaratsubaMultiply(FGInt1, FGInt2, Prod)
   else
      FGIntPencilPaperMultiply(FGInt1, FGInt2, Prod);
End;



// Square a FGInt, FGInt² = Square

Procedure FGIntPencilPaperSquare(Const FGInt : TFGInt; Var Square : TFGInt);
Var
   size, size1, i, j, rest : LongWord;
   Trest, overflow : uint64;
Begin
   size1 := FGInt.Number[0];
   size := 2 * size1;
   SetLength(Square.Number, (size + 1));
   Square.Number[0] := size;
   For i := 1 To size Do
      Square.Number[i] := 0;
   For i := 1 To size1 Do
   Begin
      Trest := FGInt.Number[i];
      Trest := Trest * FGInt.Number[i];
      Trest := Trest + Square.Number[2 * i - 1];
      Square.Number[2 * i - 1] := Trest And 4294967295;
      rest := Trest Shr 32;
      For j := i + 1 To size1 Do
      Begin
         overflow := 0;
         Trest := FGInt.Number[i];
         Trest := Trest * FGInt.Number[j];
         if Trest shr 63 = 1 then overflow := 1 shl 32;
         Trest := (Trest Shl 1) + Square.Number[i + j - 1] + overflow + rest;
         Square.Number[i + j - 1] := Trest And 4294967295;
         rest := Trest Shr 32;
      End;
      Square.Number[i + size1] := rest;
   End;
   Square.Sign := positive;
   While (Square.Number[size] = 0) And (size > 1) Do
      size := size - 1;
   If size <> (2 * size1) Then
   Begin
      SetLength(Square.Number, size + 1);
      Square.Number[0] := size;
   End;
End;


Procedure FGIntKaratsubaSquare(Const FGInt : TFGInt; Var Square : TFGInt);
// Procedure FGIntKaratsubaSquare(Const FGInt : TFGInt; Var Square : TFGInt; Const karatsubaThreshold : LongWord);
Var
   fa, fb, faa, fbb, fab, zero : TFGInt;
   halfLength, size, i : LongWord;
Begin
   size := FGInt.Number[0];
   if (size < karatsubaSquaringThreshold) Then 
   Begin
      FGIntPencilPaperSquare(FGInt, Square);
      Exit;
   End; 

   halfLength := (size Div 2) + (size mod 2);
   fa.Sign := positive;
   fb.Sign := positive;
   fb.Number := copy(FGInt.Number, 0, halfLength + 1);
   fb.Number[0] := halfLength;
   fa.Number := copy(FGInt.Number, halfLength, size - halfLength + 1);
   fa.Number[0] := size - halfLength;
   Base2StringToFGInt('0', zero);

   i := halfLength;
   while (fa.Number[i] = 0) and (i > 1) do i := i - 1;
   if i <> halfLength then
   begin
      setlength(fa.Number, i + 1);
      fa.Number[0] := i;
   end;



   if (FGIntCompareAbs(fa, zero) <> Eq) then
   begin
      FGIntKaratsubaSquare(fa, faa);
      // FGIntKaratsubaSquare(fa, faa, karatsubaThreshold);
   end 
   else
   begin
      FGIntCopy(zero, faa);
   end;

   if (FGIntCompareAbs(fb, zero) <> Eq) then
   begin
      FGIntKaratsubaSquare(fb, fbb);
      // FGIntKaratsubaSquare(fb, fbb, karatsubaThreshold);
   end 
   else
   begin
      FGIntCopy(zero, fbb);
   end;


   FGIntAddBis(fa, fb);
   if (FGIntCompareAbs(fa, zero) <> Eq) then
   begin
      FGIntKaratsubaSquare(fa, fab);
      // FGIntKaratsubaSquare(fa, fab, karatsubaThreshold);
   end 
   else
   begin
      FGIntCopy(zero, fab);
   end;


   FGIntSubBis(fab, faa);
   FGIntSubBis(fab, fbb);
   Square := faa;
   FGIntShiftLeftBy32Times(square, halfLength * 2);
   FGIntShiftLeftBy32Times(fab, halfLength);
   FGIntAddBis(square, fab);
   FGIntAddBis(square, fbb);

   FGIntDestroy(fa);   
   FGIntDestroy(fb);   
   FGIntDestroy(faa);   
   FGIntDestroy(fbb);   
   FGIntDestroy(zero);
   FGIntDestroy(fab);
End;



Procedure FGIntSquare(Const FGInt : TFGInt; Var Square : TFGInt);
Var
   size : LongWord;
Begin
   size := FGInt.Number[0];
   if (size > karatsubaSquaringThreshold) then
      FGIntKaratsubaSquare(FGInt, square)
   else
      FGIntPencilPaperSquare(FGInt, square);
End;

End.
