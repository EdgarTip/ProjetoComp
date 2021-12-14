declare dso_local i32 @printf(i8*, ...) #1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@d = common dso_local global i32 0, align 4
define dso_local i32 @main(){
%1 =  add i32 0, 1
%2 = add i32 0, 1
%3 = add i32 %1, %2
%4 = add i32 %3, 3
store i32 4, i32* @d, align 4
%5 = load i32, i32* @d, align 4
%6 = add i32 %5, %4
store i32 %5, i32* @d, align 4
%7 = load i32, i32* @d, align 4
%8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %1)
ret i32 0
}
