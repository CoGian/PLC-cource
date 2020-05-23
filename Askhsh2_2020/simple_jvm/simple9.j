.class public simple9 
.super java/lang/Object

.method public static main([Ljava/lang/String;)V
 .limit locals 20 
 .limit stack 20
sipush -1
istore 1
iload 1
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
sipush 12
sipush 5
invokestatic java/lang/Math/max(II)I
istore 1
iload 1
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
return 
.end method

