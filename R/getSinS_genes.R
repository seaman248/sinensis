orths.all <- read.csv2('./data/orthsAll.csv')

base.url <- 'https://www.vectorbase.org/Anopheles_sinensis/Export/Output/Location?db=core;flank3_display=0;flank5_display=0;output=csv;param=gene;_format=Text;'

orths.all$logicStrand[grep('-1', orths.all[,5])] <- FALSE
orths.all$logicStrand <- is.na(orths.all$logicStrand)

getSinSgenes <- function(ortab, baseurl){
  r <- rep('', nrow(ortab))
  for (i in 1:nrow(ortab)){
    r[i] <- paste0('r=', ortab[i,2], ':', ortab[i,3], '-', ortab[i,4], ';')
  }
  
  strand <- rep('', nrow(ortab))
  for(j in 1:nrow(ortab)){
    if(ortab[j,6]){
      strand[j] <- 'strand=future;'
    } else{
      strand[j] <- 'strand=reverse;'
    }
  }
  urls <- paste0(baseurl, strand, r)
  genes <- lapply(urls, function(url){
    print(which(urls==url))
    genes <- read.csv(url)
    return(levels(as.factor(genes$gene_id)))
  })
  names(genes) <- ortab[,1]
  return(genes)
}

AsinS_genes <- getSinSgenes(orths.all, base.url)

cat(toJSON(AsinS_genes), file='./data/AsinS_genes.json')