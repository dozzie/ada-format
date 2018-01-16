with format;
use format;

procedure main is
begin
  print("fprint(): arg[1] = {}\n", f(10));
  println("fprintln(): arg[1] = {1} arg[2] = {2}", (f(10), f(20)));
  println("fprintln(): arg[1] = {1} arg[2] = {2}\n",
          (f(10), f(20)));
end;
