def leftrotate(x, n):
    return ((x << n) | (x >> (32 - n))) & 0xFFFFFFFF


constant = [
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
    0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
    0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
]


step = (
    [7, 12, 17, 22]*4 +
    [5, 9, 14, 20]*4 +
    [4, 11, 16, 23]*4 +
    [6, 10, 15, 21]*4
)


M = [0x41a801a8, 0xe81df62b, 0x14a661b8, 0x5c97bf45]


A = 0x67452301
B = 0xefcdab89
C = 0x98badcfe
D = 0x10325476
x=list(range(64))
x.append(0);

print(f"{'i':>2} {'A':>8} {'B':>8} {'C':>8} {'D':>8} {'K':>8} {'F':>8} {'rnd':>3} {'word':>10} {'s':>3} {'rot':>8}")
print("-"*90)

for i in x:
 
    if 0 <= i <= 15:
        F = (B & C) | ((~B) & D)
    elif 16 <= i <= 31:
        F = (D & B) | ((~D) & C)
    elif 32 <= i <= 47:
        F = B ^ C ^ D
    else:
        F = C ^ (B | (~D))
    F &= 0xFFFFFFFF


    x = i
    for _ in range(6):
        fb = ((x >> 5) & 1) ^ ((x >> 3) & 1) ^ ((x >> 1) & 1)
        x = ((x << 1) | fb) & 0xFFFFFFFF
    rnd = (((x >> 5) & 1) << 1) | ((x >> 4) & 1)
    rnd &= 0x3

    word = M[rnd]


    F = (F + A + constant[i] + word) & 0xFFFFFFFF

    a_prev, b_prev, c_prev, d_prev = A, B, C, D


    temp = D
    D = C
    C = B
    B = (B + leftrotate(F, step[i])) & 0xFFFFFFFF
    A = temp

    print(f"{i:>2} {a_prev:08x} {b_prev:08x} {c_prev:08x} {d_prev:08x} {constant[i]:08x} {F:08x} {rnd:>3} {word:08x} {step[i]:>3} {leftrotate(F, step[i]):08x}")



