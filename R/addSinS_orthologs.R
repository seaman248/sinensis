library(XML)
library(htmltools)
library(gsubfn)
library(parallel)
library(rjson)
library(RCurl)
SinC_genes <- read.csv('./data/sinC_genes.csv')

baseStringForFindOrthologs <- 'https://www.vectorbase.org/Anopheles_sinensisC/Component/Gene/Compara_Alignments/alignments?align=9408;db=core;g='
orthoURLs <- paste0(baseStringForFindOrthologs, SinC_genes$gene_id, ';r=', SinC_genes$seqname, ':', SinC_genes$start, '-', SinC_genes$end)

write.csv(orthoURLs[1:10], './data/orthoURLs.csv', row.names = FALSE, quote = FALSE, col.names = '')


lengthOfURL <- length(orthoURLs)
downloadOrthsHTML <- lapply(orthoURLs, function(url){
  print(
    which(orthoURLs==url) / lengthOfURL * 100
  )
  html <- htmlTreeParse(getURL(url), useInternalNodes = TRUE)
  return(html)
})


orths <- lapply(downloadOrthsHTML, function(html){
  # Extract table
  table <- xpathApply(xmlRoot(html), "//table", xmlValue)
  table <- as.character(table)
  substr <- strapply(table, 'sinS2:.*', simplify = TRUE)
  return(read.table(textConnection(paste0(substr, '\n')), sep = ':'))
})

cat(toJSON(orths), file='./data/orths.json')

