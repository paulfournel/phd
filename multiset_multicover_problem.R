library("gurobi")
library(gdata)
library(magic)

createModel = function(n, m, l, s, d, alpha, beta){
  A1 = cbindX(diag(n)[,rep(1:n, each=m)], matrix(0, ncol = m+l, nrow = n))
  A2 = cbindX(diag(n*m), -diag(m)[rep(1:m, each=n),] * s, matrix(0, ncol = l, nrow = m*n))
  A3 = cbindX(-Reduce(cbindX,replicate(m, diag(n), simplify=F)), matrix(0, ncol = m, nrow = n), matrix(d, ncol = l, nrow = n))
  A4 = cbindX(matrix(0, ncol = n*m + m, nrow = 1), t(matrix(rep(-1, l))))
  
  model <- list()
  model$A = rbind(A1, A2, A3, A4)
  model$obj = c(rep(0, n*m), rep(1, m), rep(0, l))
  model$modelsense = "min"
  model$vtype = c(rep('I', n*m), rep('B', m+l))
  model$rhs = c(rep(alpha, n), rep(0, n*m), rep(0, n), -beta)
  model$sense  = '<='
  return(model)
}

gurobiAlgo = function(model){
  params <- list(OutputFlag=0)
  result <- gurobi(model, params)
  return(result)
}

n = 3
m = 4
l = 2

s = c(1,1,1,1,0,1,1,0,0,1,0,0)
d = c(1,1,1,1,0,0)
alpha = 50
beta = 2

gurobiAlgo(createModel(n, m, l, s, d, alpha, beta))
