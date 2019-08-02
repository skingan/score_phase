shell.prefix( "source env.sh ; set -eo pipefail ; " )

configfile: "config.json"
SAMPLES = config['samples'].keys()
print(SAMPLES)
CPU     = config['cpu']
MOM	= config['mom_db']
DAD	= config['dad_db']
print(MOM)
print(DAD)

def _get_input_fn(wildcards):
    print(wildcards.name)
    return config['samples'][wildcards.name]

def _get_tag(wildcards):
    return config['tags'][wildcards.name]


rule dummy:
     input: expand("summary/{name}.pdf", name=SAMPLES), expand("summary/{name}.txt", name=SAMPLES) 

rule plot:
     input: KMERS="merge/{name}.hapmers.counts"
     output: "summary/{name}.pdf", "summary/{name}.txt"
     shell: """
	 blobPlot.R --infile {input.KMERS} --prefix summary/{wildcards.name}
     """

rule merge:
     input: MOM = "count/{name}.mom.counts", DAD = "count/{name}.dad.counts"
     output: KMERS = "merge/{name}.hapmers.counts", TMP = temp("{name}.tmp.counts")
     shell: """
	paste {input.MOM} {input.DAD} > {output.TMP}
        echo -e "Contig\tMom\tDad\tTotal" > {output.KMERS}
        cat {output.TMP} | awk '{{print $1 "\t" $4 "\t" $8 "\t" $2}}' >> {output.KMERS}
     """

rule count_dad:
     input: FASTA = "{name}.clean.fasta", HAP=DAD
     output: "count/{name}.dad.counts"
     shell: """
	meryl-lookup -existence -sequence {input.FASTA} -mers {input.HAP} > {output}
     """

rule count_mom:
     input: FASTA = "{name}.clean.fasta", HAP=MOM
     output: "count/{name}.mom.counts"
     shell: """
	 meryl-lookup -existence -sequence {input.FASTA} -mers {input.HAP} > {output}
     """

rule clean_headers:
     input: FASTA = _get_input_fn
     output: "{name}.clean.fasta"
     shell: """
	cat {input.FASTA} | perl -lane '$_ =~ s/\s+.*// if $_ =~ />/; print' > {output}
     """
