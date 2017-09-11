library(lpSolveAPI)
# Use the Windsor Glass Problem
lprec <- make.lp(0, 3)
#Defaults to Minimize objective function
set.objfn(lprec, c(-385, -330, -275))
add.constraint(lprec, c(1, 1, 1), "<=", 750)
add.constraint(lprec, c(1, 1, 1), "<=", 900)
add.constraint(lprec, c(1, 1, 1), "<=", 450)
add.constraint(lprec, c(20, 15, 12), "<=", 13000)
add.constraint(lprec, c(20, 15, 12), "<=", 12000)
add.constraint(lprec, c(20, 15, 12), "<=", 5000)
#set.bounds(lprec, upper = 100, columns = 5)
RowNames <- c("Plant1", "Plant2", "Plant3", "Plant1", "Plant2", "Plant3")
ColNames <- c("Large", "Medium", "Small")
dimnames(lprec) <- list(RowNames, ColNames)
lprec
# Alternatively, write your model in lp format
write.lp(lprec,'corporation_out.lp',type='lp') 
solve(lprec)
get.objective(lprec) * -1
get.variables(lprec)
get.constraints(lprec)
get.sensitivity.objex(lprec)
get.sensitivity.rhs(lprec)
#rm(lprec)

# Now, let's use the lp format to imput the model
# See http://lpsolve.sourceforge.net/5.5/index.htm for reference

y <- read.lp("ZiYang corporation.lp")
y
solve(y)
get.objective(y)
get.variables(y)
get.constraints(y)
get.sensitivity.objex(y)
get.sensitivity.rhs(y)
