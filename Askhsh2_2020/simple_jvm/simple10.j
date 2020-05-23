.class public simple10 
.super java/lang/Object

.method public static main([Ljava/lang/String;)V
 .limit locals 20 
 .limit stack 20
sipush -1
istore 1
ldc -2.0
fstore 2
sipush 12
sipush 12
sipush 5
invokestatic java/lang/Math/max(II)I
iadd 
sipush 10
fload 2
invokestatic java/lang/Math/abs(F)F
f2i
invokestatic java/lang/Math/min(II)I
iadd 
istore 1
iload 1
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
ldc 12.0
fload 2
ldc -1.0
invokestatic java/lang/Math/min(FF)F
fadd 
fstore 2
fload 2
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
return 
.end method

