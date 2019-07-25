# Purpose

This code uses newer version of meryl that are packaged with Canu v1.8.

It does not use "qr" files but, rather, "meryl databases" which are organized as directories. See meryl repo https://github.com/marbl/meryl for more details.


# Dependencies
`snakemake v4.8.0`

`canu v1.8`

`R v3.4.1`

# Usage

## Login to compute node with 8 cores
`qrsh -q default -pe smp 8`


## Load Dependencies
`module load snakemake`


## Edit config.json

Specify your file paths and tags.


## Run It
`snakemake -s Snakefile --verbose -p`


# Input

1. contigs in fasta format
2. meryl databases with parent-specific k-mers



# Output

`summary` directory contains final outputs.
1. `PDF` of phasing blob plot for each fasta input
2. `txt` file with overall phasing accuracy for each input
