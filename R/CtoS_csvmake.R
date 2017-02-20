library(rjson)

sic_sis.list <-fromJSON(file='./data/AsinS_genes.json')
sinC_Genes <- read.csv('./data/sinC_genes_dedup.csv')


sic_sis.list.clear <- lapply(sic_sis.list, function(gpair){
  if(length(gpair) == 0){
    return(NA)
  } else{
    return(gpair[gpair!=''])
  }
})

sic_sis.list.clear <- sic_sis.list.clear[unlist(lapply(sic_sis.list.clear, function(x){!is.na(x[1])}))]

sic_sis.unlist <- data.frame(do.call('rbind',unlist(lapply(sic_sis.list.clear, function(gpair){
  as.list(gpair)
}), recursive = FALSE)))

true_row_names <- unlist(lapply(row.names(sic_sis.unlist), function(sinCgeneID){
  grep(substr(sinCgeneID, 1, 10), sinC_Genes$gene_id)
}))

sic_sis.unlist[,2] <- sinC_Genes$gene_id[true_row_names]

names(sic_sis.unlist) <- c('AsinS2_geneID', 'AsinC2_geneID')
row.names(sic_sis.unlist) <- 1:nrow(sic_sis.unlist)
write.csv2(sic_sis.unlist, './data/S2_to_C2_bridge.csv')

sinC_Genes.withSins <- sinC_Genes[true_row_names,] <- as.character(sic_sis.unlist$AsinS2_geneID)
sinC_Genes.withSins[,6] <- as.character(sic_sis.unlist$AsinS2_geneID)
sinC_Genes.withSins[,1] <- NULL
