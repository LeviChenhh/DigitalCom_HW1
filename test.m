data=[0 1 1 ]
constlen=3;
codegen = [5 7]
trellis = poly2trellis(constlen, codegen)
codedata = convenc(data, trellis)

