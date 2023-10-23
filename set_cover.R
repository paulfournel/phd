### Implementing a greedy algorithm for set cover

library("gurobi")##


numberOfElements = 8
numberOfSets = 35

createModel = function(numberOfElements, numberOfSets){
  model <- list()
  model$A = matrix(rbinom(n=numberOfSets*numberOfElements,size=1,prob=0.1), nrow = numberOfElements, ncol = numberOfSets, byrow=T)
  model$obj = rep(1,numberOfSets)
  model$modelsense = "min"
  model$vtype = 'B'
  model$rhs = rep(1,numberOfElements)
  model$sense  = rep('>=', numberOfElements)
  return(model)
}

gurobiAlgo = function(model){
  params <- list(OutputFlag=0)
  result <- gurobi(model, params)
  return(result$objval)
}

greedy = function(inputA){
  A = inputA
  i = 0
  covered = rep(0, dim(inputA)[1])
  choosen = rep(0, dim(inputA)[2])
  while(sum(covered>0)<length(covered)){
    SelectedIndex = which.max(colSums(A))
    choosen[SelectedIndex] = 1
    covered = covered + inputA[,SelectedIndex]
    A = matrix(A[A[,SelectedIndex] != 1,], ncol = dim(inputA)[2])
    if(i>dim(inputA)[2]){
      return(NULL)
    }
    i = i+1
  }
  return(sum(choosen))
}


model = createModel(numberOfElements, numberOfSets)


gurobiAlgo(model)
greedy(model$A)
