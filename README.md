#REDO ME

# Dependencies

`python v3.6` (need to test 3.7)

`snakemake v4.8.0`

`canu v1.7`

`R v3.4.1`




# Usage

## Load Dependencies
`conda activate py36`
your environment may differ

`module load snakemake`


## Edit config.json

Specify your file paths and tags.


## Run It
`snakemake -s Snakefile --verbose -p`




# Input

1. contigs in fasta format
2. `qr` files generated from canu utilities




# Output

`summary` directory contains final outputs.
1. `PDF` of phasing blob plot for each fasta input
2. `txt` file with overall phasing accuracy for each input
