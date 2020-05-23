.class public simple8 
.super java/lang/Object

.method public static main([Ljava/lang/String;)V
 .limit locals 20 
 .limit stack 20
sipush -1
istore 1
ldc -1.0
fstore 2
iload 1
invokestatic java/lang/Math/abs(I)I
istore 1
iload 1
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
fload 2
invokestatic java/lang/Math/abs(F)F
fstore 2
fload 2
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
return 
.end method

