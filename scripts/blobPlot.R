
require("ggplot2")
require("argparser")
require("ggsci")
library(ggplot2)
library(ggsci)
library(plyr)
library(scales)

parser <- arg_parser("blob plots for phasing")
parser <- add_argument(parser, "--infile", type="character", help="kmer counts", default="NULL")
parser <- add_argument(parser, "--prefix", type="character", help="prefix", default="NULL")
args   <- parse_args(parser)

# define output files
stats<-paste(args$prefix, "txt", sep=".")
pic<-paste(args$prefix, "pdf", sep=".")

draw_blobplot <- function(dataset, hapA, hapB, total, x_lab, y_lab, out) {
  max_total=max(max(hapA), max(hapB))
  max_total = max_total * 1.01
  
  ggplot(dataset, aes(x=hapA, y=hapB, size=total)) +
    geom_point(shape=16) + theme_bw() + scale_color_brewer(palette = "Set1") +
    scale_x_continuous(labels=comma, limits = c(0, max_total)) +
    scale_y_continuous(labels=comma, limits = c(0, max_total)) +
    scale_size_continuous(labels=comma, range = c(1, 5), name = "Contig Length") +
    theme(legend.text = element_text(size=10),
          legend.position = c(0.83,0.45),  # Modify this if the legend is covering your favorite circle
          legend.background = element_rect(size=0.2, linetype="solid", colour ="black"),
          axis.title=element_text(size=16), axis.text=element_text(size=14)) +
    guides( size = guide_legend(order = 1),
            colour = guide_legend(override.aes = list(size=4), order = 2)) +
    xlab(x_lab) + ylab(y_lab)
  ggsave(pic, width=6, height=6, device="pdf")
}

scoreKmers <- function(dataset) {
  correct<-(apply(dataset[,c(2,3)], 1, max))
  return(sum(correct)/sum(c(dataset[,2],dataset[,3])))
}

# draw plot
kmercounts<-read.table(args$infile, header=TRUE)
draw_blobplot(out=args$prefix, kmercounts, 
              kmercounts$Mom, kmercounts$Dad, 
              kmercounts$Total+20, x_lab = "Mom", y_lab = "Dad")

# write stat
o<-c("phasingAccuracy",scoreKmers(kmercounts))
write.table(o, file=stats, quote=FALSE, sep="\t",col.names=FALSE,row.names=FALSE)
