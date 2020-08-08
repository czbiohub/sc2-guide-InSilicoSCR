####
# InSilicoSCR for sc2 guides pipeline
# author: Chunyu Zhao chunyu.zhao@czbiohub.org
# time: 2020-08-05
####

import os
import sys
import configparser
from Bio import SeqIO


GUIDES = [record.id for record in SeqIO.parse(config["guide_fasta"], "fasta")]


rule generate_neighbors:
    input:
        config["guide_fasta"]
    output:
        expand(config["project_dir"] + "/1_neighbors/{guide}_hd.4.txt", guide=GUIDES)
    params:
        config["project_dir"] + "/1_neighbors"
    shell:
        "python isscrlib/gen_neighbors.py {input} {params}"


MSSPE_SAMPLES = []
with open(config["msspe"]["samplelist_fp"]) as stream:
    for line in stream:
        MSSPE_SAMPLES.append(line.strip("\n").split("\t")[0])


HMP1_SAMPLES = []
with open(config["hmp1"]["samplelist_fp"]) as stream:
    for line in stream:
        HMP1_SAMPLES.append(line.strip("\n").split("\t")[0])


include: "rules/scr_dbs.rules"
include: "rules/preprocess_msspe.rules"
include: "rules/preprocess_hmp.rules"
include: "rules/scr_reads_hmp.rules"
include: "rules/scr_reads_msspe.rules"
