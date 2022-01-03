declare dso_local i32 @printf(i8*, ...) #1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"%.08f\0A\00", align 1
@.str.3 = private unnamed_addr constant [ 5 x i8] c"ola\0A\00", align 1
@.str.4 = private unnamed_addr constant [ 13 x i8] c"-----------\0A\00", align 1
@.str.5 = private unnamed_addr constant [ 13 x i8] c"-----------\0A\00", align 1
@.str.6 = private unnamed_addr constant [ 13 x i8] c"-----------\0A\00", align 1
@.str.7 = private unnamed_addr constant [ 13 x i8] c"-----------\0A\00", align 1
@.str.8 = private unnamed_addr constant [ 13 x i8] c"-----------\0A\00", align 1
@d = common dso_local global double 0.0, align 4
@e = common dso_local global i32 0, align 4
@f = common dso_local global double 0.0, align 4
define dso_local i32 @main(){
%1 = alloca i32, align 4
%2 = alloca i32, align 4
%3 = alloca double, align 4
%4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double 3.3)
%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 2)
%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
%7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.4, i32 0, i32 0))
store i32 17, i32* %1, align 4
store i32 1, i32* %2, align 4
store double 3.32, double* %3, align 4
store double 2.2, double* @d, align 4
%8 = load double, double* @d, align 4
%9 = load i32, i32* %1, align 4
%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %9)
%11 = load i32, i32* %2, align 4
%12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %11)
%13 = load double, double* %3, align 4
%14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %13)
%15 = load double, double* @d, align 4
%16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %15)
%17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.4, i32 0, i32 0))
%18 = load i32, i32* %2, align 4
store i32 %18, i32* %1, align 4
%19 = load double, double* %3, align 4
store double %19, double* @d, align 4
%20 = load double, double* @d, align 4
%21 = load i32, i32* %1, align 4
%22 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %21)
%23 = load i32, i32* %2, align 4
%24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %23)
%25 = load double, double* %3, align 4
%26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %25)
%27 = load double, double* @d, align 4
%28 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %27)
%29 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.4, i32 0, i32 0))
%30 = load double, double* @d, align 4
store double %30, double* %3, align 4
%31 = load i32, i32* %1, align 4
store i32 %31, i32* %2, align 4
%32 = load double, double* %3, align 4
%33 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %32)
%34 = load i32, i32* %1, align 4
%35 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %34)
%36 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.4, i32 0, i32 0))
store i32 3, i32* @e, align 4
%37 = load i32, i32* @e, align 4
%38 = load i32, i32* @e, align 4
%39 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %38)
%40 = alloca double, align 4
store double 3.2, double* %40, align 4
%41 = load double, double* %40, align 4
%42 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %41)
%43 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.4, i32 0, i32 0))
store double 3.2, double* @f, align 4
%44 = load double, double* @f, align 4
%45 = load double, double* @f, align 4
%46 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %45)
%47 = alloca i32, align 4
store i32 2, i32* %47, align 4
%48 = load i32, i32* %47, align 4
%49 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %48)
ret i32 0}
