## Cost function code ####
# L Webb
##
# calculates cost function values for one set of sleep/wake probabilities for all 
# provided model produced sleep probabilities




# get the costs for all given para combos for a given week summary of baby data
cost_func_mtrx <- function(halfhourdata, row_h1 = 7, row_h2 = 54,BabyData){
  # halfhourdata is model produced probability of being asleep per half hour
  # halfhourdata is a matrix, where rows are parameter combinations and sleep probabilities, and columns are each unique model output
  # row_h1 provides which row the sleep probabilities begin
  # row_h2 is where sleep probabilities end
  # sleep probability rows need to be in order
  # BabyData is the single set of half hour sleep probabilities
  
  para_combo = halfhourdata[1:(row_h1-1),]
  
  hh_matrix = matrix(halfhourdata[row_h1:row_h2,], nrow = 48, ncol = dim(halfhourdata)[2])
  BD_data = as.matrix(BabyData)#as.matrix(BabyData[,col])
  BD_matrix = do.call(cbind, replicate(dim(hh_matrix)[2],BD_data, simplify = FALSE))
  
  # cost 1
  sqdif = (hh_matrix - BD_matrix)^2
  sumsqdif = colSums(sqdif)
  # cost 2 (weighted by sleep)
  wsqdif = (hh_matrix - BD_matrix)^2 * BD_matrix
  sumwsqdif = colSums(wsqdif)
  # cost 3 (weighted by closer to complete sleep or complete wake)
  awsqdif = (hh_matrix - BD_matrix)^2 * abs(BD_matrix-0.5)
  sumawsqdif = colSums(awsqdif)
  
  out = rbind(para_combo, t(sumsqdif), t(sumwsqdif), t(sumawsqdif))
  
  
  return(out)
}