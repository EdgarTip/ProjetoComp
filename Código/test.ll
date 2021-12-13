define dso_local i32 @yo(i32 %a){
%1 = add i32 %a, 1
ret i32 %1
}
define dso_local i32 @main(){
%1 = add i32 1,1
ret i32 0
}
