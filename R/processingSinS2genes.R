library(rjson)

orths <-  fromJSON(file='./data/orths_dedup.json')
SinC_genes <- read.csv('./data/sinC_genes_dedup.csv')[,c(2:5)]

names(orths) <- SinC_genes$gene_id

orths.stat <- unlist(lapply(orths, function(orth){
  if(length(names(orth)) == 5){
    return(TRUE)
  } else {
    return(FALSE)
  }
}))
orths.stat <- unname(orths.stat)
orths.TRUE <- table(orths.stat)[2]/length(orths)*100

orths.mono <- do.call('rbind',lapply(orths[orths.stat], function(orth){
  return(data.frame(orth))
}))

orths.mono[,6] <- row.names(orths.mono)

orths.requestStrings <- paste0(orths.mono[,2], ':', orths.mono[,3], ':', orths.mono[,4], ':', orths.mono[,5])

write.table(orths.requestStrings, file='./data/orthRequestStrings.txt', col.names = '', quote=FALSE, row.names = FALSE)
