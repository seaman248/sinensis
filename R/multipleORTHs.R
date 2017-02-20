library(rjson)

orths <- fromJSON(file='./data/orths_dedup.json')
SinC_genes <- read.csv('./data/sinC_genes_dedup.csv')[,c(2:5)]
names(orths) <- SinC_genes$gene_id


orths.deviding <- lapply(orths, function(orth){
  orth <- unname(as.vector(rbind(orth)))
  orth <- gsub('supercontig', '', orth)
  if(orth[1]!='NULL'){
    orth <- do.call('rbind',lapply(seq(1, length(orth), 5), function(start){
      orth[seq(start, start+4, 1)]
    }))
    orth <- data.frame(orth)[2:5]
  } else {
    return(NULL)
  }
  
  if(length(levels(orth[,1]))==1){
    return(data.frame(
      V1 = levels(orth[,1]),
      V2 = orth[1,2],
      V3 = orth[nrow(orth),3],
      V4 = orth[1, 4]
    ))
  } else{
    return(NULL)
  }
  
})

nullOrths <- unname(unlist(lapply(orths.deviding, is.null)))

orths.all <- do.call('rbind', orths.deviding[!nullOrths])

names(orths.all) <- c('SinS2_contig', 'SinS2_start', 'SinS2_end', 'SinS2_strand')

write.csv2(orths.all, './data/orthsAll.csv')
