.class public simple7 
.super java/lang/Object

.method public static main([Ljava/lang/String;)V
 .limit locals 20 
 .limit stack 20
ldc 1.0
fstore 1
sipush 3
sipush 4
iadd 
i2f
fstore 1
fload 1
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
sipush 1
istore 2
sipush 1
sipush 2
iadd 
istore 2
iload 2
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
return 
.end method

