source('./R/functions/makeURLs.R')

SinC_scafs <- read.csv2('./data/SinC_Scaffolds.csv', header = FALSE)
names(SinC_scafs) <- c('scafs', 'start', 'end', 'chr')
genesURL <- 'https://www.vectorbase.org/Anopheles_sinensisC/Export/Output/Location?db=core;flank3_display=0;flank5_display=0;output=csv;strand=feature;param=gene;_format=Text;r='

SinC_scafs$urls <- makeURLs(genesURL, SinC_scafs$scafs, SinC_scafs$start, SinC_scafs$end)

SinC_genes <- do.call('rbind', lapply(SinC_scafs$urls, function(url){
  print(url)
  read.csv(url)[,c(1, 13, 4, 5)]
}))

write.csv(SinC_genes, './data/sinC_genes.csv')

write.csv(SinC_genes[!duplicated(SinC_genes$gene_id),], './data/sinC_genes_dedup.csv')
