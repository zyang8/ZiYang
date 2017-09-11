library(lpSolveAPI)
y <- read.lp("ZiYang corporation.lp")
y
solve(y)
get.objective(y)
get.variables(y)
get.constraints(y)
get.sensitivity.objex(y)
get.sensitivity.rhs(y)
