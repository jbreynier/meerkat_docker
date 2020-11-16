# Docker Image for Meerkat

## Meerkat tool:

Website: http://compbio.med.harvard.edu/Meerkat/  
Github: https://github.com/guru-yang/Meerkat  

## Paths of tools within container:

 * Samtools (0.1.19): /usr/local/samtools-0.1.19/samtools  
 * BWA (0.6.2): /usr/local/bwa-0.6.2/bwa  
 * BLAST (2.2.24): /usr/local/blast-2.2.24/bin/  
 * BLAT (v. 36x2): /usr/local/blat/blat  
 * Primer3 (2.2.0 alpha): /usr/local/primer3-2.2.0-alpha/src/  
 * Meerkat (0.189): /usr/local/Meerkat/scripts/  

## Example usage:

Input data:
 * The Meerkat test dataset: http://compbio.med.harvard.edu/Meerkat/Meerkat.example.v2.tar.gz  
 * hg18 genome along with all required reference genome files:  
        Meerkat.example

```bash
├── Readme.txt
├── bam
│   ├── example.sorted.bam
│   └── example.sorted.bam.bai
├── headerfile
└── outputs
    ├── example.bp.info
    ├── example.bp_reads
    ├── example.clusters
    ├── example.discord
    ├── example.dre.log
    ├── example.inter.refined.typ.sorted
    ├── example.intra.refined.typ.sorted
    ├── example.isinfo
    ├── example.mp.inter.out
    ├── example.mp.intra.out
    ├── example.pdf
    ├── example.pre.log
    ├── example.sr.inter.filtered
    ├── example.sr.inter.out
    ├── example.sr.intra.filtered
    ├── example.sr.intra.out
    └── example.variants
```

`docker run --rm -v /path/to/Meerkat.example:/Meerkat.example -v /path/to/hg18:/hg18 jbreynier/meerkat:latest perl /usr/local/Meerkat/scripts/pre_process.pl -b /Meerkat.example/bam/example.sorted.bam -I /hg18/hg18_bwa_idx/hg18.fa -A /hg18/hg18.fa.fai -W /usr/local/bwa-0.6.2/ -S /usr/local/samtools-0.1.19/`  

`docker run --rm -v /path/to/Meerkat.example:/Meerkat.example -v /path/to/hg18:/hg18 jbreynier/meerkat:latest perl /usr/local/Meerkat/scripts/meerkat.pl -b /Meerkat.example/bam/example.sorted.bam -F /hg18/hg18_fasta/ -W /usr/local/bwa-0.6.2/ -B /usr/local/blast-2.2.24/bin/ -S /usr/local/samtools-0.1.19/`  

`docker run --rm -v /path/to/Meerkat.example:/Meerkat.example -v /path/to/hg18:/hg18 jbreynier/meerkat:latest perl /usr/local/Meerkat/scripts/mechanism.pl -b /Meerkat.example/bam/example.sorted.bam -R /hg18/rmsk-hg18.txt`  