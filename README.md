# PLANiTS ITS reference set for the RDP Classifier

A plant ITS reference set has been refgormatted to work with the RDP classifier.  I convert the QIIME-formatted PLANiTS files for use with the stand-alone version of the RDP classifier.  It has only been tested on the QIIME formatted PLANiTS release 29_03_2020 available from https://github.com/apallavicini/PLANiTS .  It is currently trained to the species rank.  I have also added some fungal ITS outgroup sequences from the UNITE v8.2 reference set available from https://unite.ut.ee/repository.php as well as some microsporidian outgroup sequencs from the 2014 UNITE reference set available from https://sourceforge.net/projects/rdp-classifier/.  Leave one sequence out testing is currently in progress.

The PLANiTS v1.1 training files and trained files ready for use with the RDP classifier are available at https://github.com/terrimporter/PLANiTS_ITSClassifier/releases .

## Overview

[How to classify your sequences](#How-to-classify-your-sequences)   
[Get PLANiTS data and prepare it](#Get-PLANiTS-data-and-prepare-it)  
[Get outgroup data and add it to PLANiTS](#Get-outgroup-data-and-add-it-to-PLANiTS)
[Train and test the RDP Classifier](#Train-and-test-the-RDP-Classifier)   
[Releases](#Releases)   

## How to classify your sequences

1. Download the latest version of the RDP-formatted PLANiTS reference set and decompress it.

```linux
wget https://github.com/terrimporter/PLANiTS_ITSClassifier/releases/download/v1.1/PLANiTSv032920_v1.1.tar.gz
tar -xvzf PLANiTSv032920_v1.1.tar.gz
```

2. Run the RDP Classifier.

```linux
java -Xmx25g -jar /path/to/rdp_classifier_2.13/dist/classifier.jar classify -t PLANiTSv032920_v1.1/rRNAClassifier.properties -o outfile.txt query.fasta 
```

## Get PLANiTS data and prepare it

The following steps are only needed if you are interested in the steps I took to reform QIIME formatted files for use with the  RDP classifier.

1. Obtain PLANiTS data from https://github.com/apallavicini/PLANiTS , decompress it, and enter the directory.

```linux
wget https://github.com/apallavicini/PLANiTS/blob/master/PLANiTS_29-03-2020.zip
unzip PLANiTS_29-03-2020.zip
cd PLANiTS-master
```
2. Dereplicate the sequences to avoid overestimating RDP classifier accuracy.  Currently working with the full-length ITS sequence file.

```linux
# vsearch v2.14.1
vsearch --derep_fulllength ITS.fasta --output ITS.fasta.derep
```

3. Check if there are any non-plant sequences in set (optional).  There are only Chlorophyta and Streptophyta plant sequences in this reference set.

```linux
awk 'BEGIN {FS =" "}{print $2}' ITS_taxonomy | awk 'BEGIN{FS=";"}{print $1}' | sort -u
```

4. Convert the vsearch file into a strictly formatted FASTA file.
 
```linux
perl messedup_fasta_to_strict_fasta.plx < ITS.fasta.derep > ITS.fasta.derep.strict 
```

5. Create a copy of the full length ITS taxonomy file before making any changes.

```linux
cp ITS_taxonomy ITS_taxonomy2
```

6. Edit the PLANiTS taxonomy file to handle non-unique taxa to ensure a strictly hierarchical taxonomuy.  Ex. This often happens when an order taxon is found in more than one class, usually when the class is labelled 'NA'.  NCBI taxonomy was used as a guide to ensure taxonomic consistency.

```linux
vi -c '1,$s/NA;Asterales;/Magnoliopsida;Asterales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Rosales;/Magnoliopsida;Rosales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Lamiales;/Magnoliopsida;Lamiales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Myrtales;/Magnoliopsida;Myrtales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Boraginales;/Magnoliopsida;Boraginales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Apiales;/Magnoliopsida;Apiales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Liliopsida;Asparagales;/Magnoliopsida;Asparagales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Liliopsida;Liliales;/Magnoliopsida;Liliales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Piperales;/Magnoliopsida;Piperales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Solanales;/Magnoliopsida;Solanales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Liliopsida;Alismatales;/Magnoliopsida;Alismatales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Saxifragales;/Magnoliopsida;Saxifragales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Fabales;/Magnoliopsida;Fabales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Cupressales;/Pinopsida;Cupressales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Caryophyllales;/Magnoliopsida;Caryophyllales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Dipsacales;/Magnoliopsida;Dipsacales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Liliopsida;Poales;/Magnoliopsida;Poales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Santalales;/Magnoliopsida;Santalales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Liliopsida;Pandanales;/Magnoliopsida;Pandanales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Laurales;/Magnoliopsida;Laurales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Ranunculales;/Magnoliopsida;Ranunculales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Sapindales;/Magnoliopsida;Sapindales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Malpighiales;/Magnoliopsida;Malpighiales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Fagales;/Magnoliopsida;Fagales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Gentianales;/Magnoliopsida;Gentianales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Nymphaeales;/Magnoliopsida;Nymphaeales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Liliopsida;Zingiberales;/Magnoliopsida;Zingiberales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;NA;Dicloster;/Chlorellales;Chlorellaceae;Dicloster;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Liliopsida;Commelinales;/Magnoliopsida;Commelinales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Malvales;/Magnoliopsida;Malvales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Parachlorella;/Chlorellaceae;Parachlorella;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Ericales;/Magnoliopsida;Ericales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Liliopsida;Arecales;/Magnoliopsida;Arecales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Magnoliales;/Magnoliopsida;Magnoliales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Lithotrichon;/Kornmanniaceae;Lithotrichon;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Zygophyllales;/Magnoliopsida;Zygophyllales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Cycadales;/Cycadopsida;Cycadales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Cucurbitales;/Magnoliopsida;Cucurbitales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Aquifoliales;/Magnoliopsida;Aquifoliales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Chloranthales;/Magnoliopsida;Chloranthales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Hypnaceae;Gollania;/Pylaisiaceae;Gollania;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;NA;Neocystis;/Sphaeropleales;Radiococcaceae;Neocystis;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Trebouxiophyceae;Sphaeropleales;/Chlorophyceae;Sphaeropleales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Microthamniales;NA;Stichococcus;/Prasiolales;Prasiolaceae;Stichococcus;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Cornales;/Magnoliopsida;Cornales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Vitales;/Magnoliopsida;Vitales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Austrobaileyales;/Magnoliopsida;Austrobaileyales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Celastrales;/Magnoliopsida;Celastrales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Geraniales;/Magnoliopsida;Geraniales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Proteales;/Magnoliopsida;Proteales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Crossosomatales;/Magnoliopsida;Crossosomatales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Brassicales;/Magnoliopsida;Brassicales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Buxales;/Magnoliopsida;Buxales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Oxalidales;/Magnoliopsida;Oxalidales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Liliopsida;Dioscoreales;/Magnoliopsida;Dioscoreales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Hypnaceae;Callicladium;/Callicladiaceae;Callicladium;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Hypnaceae;Andoa;/Myuriaceae;Andoa;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Hypnaceae;Chryso-hypnum;/Pylaisiaceae;Chryso-hypnum;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Entodontaceae;Jochenia;/Jocheniaceae;Jochenia;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Omphalodes;Mimophytum mexicanum/Mimophytum;Mimophytum mexicanum/' -c "wq" ITS_taxonomy2
vi -c '1,$s/Hypnaceae;Taxiphyllum;/Taxiphyllaceae;Taxiphyllum;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Icacinales;/Magnoliopsida;Icacinales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Canellales;/Magnoliopsida;Canellales;/' -c "wq" ITS_taxonomy2
vi -c '1,$s/NA;Araucariales;/Pinopsida;Araucariales;/' -c "wq" ITS_taxonomy2
```

## Get outgroup data and add it to PLANiTS

1. Get QIIME-formatted fungal sequences from UNITE v8.2 https://unite.ut.ee/repository.php , decompress it, enter directory.  I worked with the 'dynamic' files that includes singletons and sequences clustered at a variety of similarities from 0.3 - 3%.

2. Dereplicate the sequences.  Convert to a strictly formatted FASTA file (no multi-line sequences allowed). 
```linux
# vsearch v2.14.1 dereplication
vsearch --derep_fulllength sh_refs_qiime_ver8_dynamic_04.02.2020.fasta --output unite_dynamic.fasta

# convert to a strictly formatted FASTA file
perl messedup_fasta_to_strict_fasta.plx < unite_dynamic.fasta > unite_dynamic.fasta.strict 
```

3. Get microsporidian sequences from UNITE (2014) reference set https://sourceforge.net/projects/rdp-classifier/ , decompress it, enter directory.  Grab just the protozoa and tweak the formatting.

```linux
# grab the protozoa
grep -A1 Protozoa UNITE.RDP_04.07.14.rmdup.fasta > nonfungi.fasta  

# tweak formatting
vi -c '1,$s/^--$//g' -c 'wq' nonfungi.fasta
vi -c 'g/^$/d' -c 'wq' nonfungi.fasta

# create QIIME-formatted sequence file
perl strip_lineage_from_fasta.plx < nonfungi.fasta > nonfungi.fasta2

# create QIIME-formatted taxonomy file
perl create_qiime_taxonomy.plx < nonfungi.fasta > nonfungi.tax
```

4. Combine the fungi and microsporidian files.
```linux
# combine the QIIME-formatted FASTA files
cat unite_dynamic.fasta.strict fungalits_UNITE_trainingdata_07042014/nonfungi.fasta2 > unite_outgroup.fasta

# combine the QIIME-formatted taxonomy files
cat sh_taxonomy_qiime_ver8_dynamic_04.02.2020.txt fungalits_UNITE_trainingdata_07042014/nonfungi.tax > unite_outgroup.txt
```

5. Fix taxon names to ensure a strictly hierarchical taxonomy. ex. a genus can not belong to more than one family.  The NCBI taxonomy database was used to ensure taxonomic consistency.

```linux
vi -c '1,$s/f__Tremellaceae;g__Cryptococcus;/f__Cryptococcaceae;g__Cryptococcus;/' -c 'wq' unite_outgroup.txt
vi -c '1,$s/f__Helotiaceae;g__Cenangiopsis;/f__Cenangiaceae;g__Cenangiopsis;/' -c 'wq' unite_outgroup.txt
vi -c '1,$s/f__Pezizaceae;g__Aleurina;/f__Pyronemataceae;g__Aleurina;/' -c 'wq' unite_outgroup.txt
vi -c '1,$s/f__Trematosphaeriaceae;g__Brevicollum;/f__Neohendersoniaceae;g__Brevicollum;/' -c 'wq' unite_outgroup.txt
vi -c '1,$s/f__unidentified;g__Brevicollum;/f__Neohendersoniaceae;g__Brevicollum;/' -c 'wq' unite_outgroup.txt
vi -c '1,$s/f__Nectriaceae;g__Cylindrium;/f__Hypocreales_fam_Incertae_sedis;g__Cylindrium;/' -c 'wq' unite_outgroup.txt
```

6. Filter out unidentified species.  The outfile is called unite_outgroup2.txt .

```linux
perl filter_out_unident_species.plx unite_outgroup.fasta unite_outgroup.txt
```

7. Dereplicate and cluster the sequences, aiming for about 50 outgroup sequences.  Convert to a strictly formatted FASTA file.

```linux
# vsearch 2.14.1
vsearch --derep_fulllength unite_outgroup2.fasta --output unite_outgroup2.fasta.derep
vsearch --cluster_fast unite_outgroup2.fasta.derep --centroids unite_outgroup2.fasta.derep.centroids --id 0.5
perl messedup_fasta_to_strict_fasta.plx < unite_outgroup2.fasta.derep.centroids > unite_outgroup2.fasta.derep.centroids.fasta
```

8. For each sequence in the FASTA file, grab corresponding taxonomy.  The outfile is unite_outgroup3.txt

```linux
perl grab_tax_for_each_acc2.plx unite_outgroup2.fasta.derep.centroids.fasta unite_outgroup2.txt
```

9. Combine the plant and fungal+microsporidian outgroup files.  

```linux
cat ITS.fasta.derep.strict unite_outgroup2.fasta.derep.centroids.fasta > PLANiTS_unite_outgroups.fasta
cat ITS_taxonomy2 unite_outgroup3.txt > PLANiTS_unite_outgroups.txt
```

10.  Edit the plant taxonomy file to include kingdom 'Viridiplantae'.

```linux
vi -c '1,$s/\tChlorophyta;/\tViridiplantae;Chlorophyta;/g' -c 'wq' PLANiTS_unite_outgroups.txt
vi -c '1,$s/\tStreptophyta;/\tViridiplantae;Chlorophyta;/g' -c 'wq' PLANiTS_unite_outgroups.txt
```

11.  Convert the QIIME-formatted files into files that can be used to train the RDP Classifier.

```linux
perl qiime_planits_to_rdp2.plx PLANiTS_unite_outgroups.fasta PLANiTS_unite_outgroups.txt
```

## Train and test the RDP Classifier

1. Train the RDP Classifier.

```linux
# rdp_classifier_2.13
java -Xmx30g -jar /home/terri/rdp_classifier_2.13/dist/classifier.jar train -o mytrained -s mytrainseq.fasta -t mytaxon.txt
```

2. Add the rRNAClassifier.properties file to the newly created mytrained directory (not optional).  I also like to edit the RDP Classifier version and date in rRNAClassifier.properties (optional).

```linux
cd mytrained
cp ~/rdp_classifier_2.13/src/data/classifier/16srrna/rRNAClassifier.properties . 
cd ..
```

3. Create a small fasta file for testing.
```linux
head -20 ITS.fasta.derep.strict > test.fasta
```

4. Test the RDP classifier.

```linux
java -Xmx25g -jar /path/to/rdp_classifier_2.13/dist/classifier.jar classify -t mytrained/rRNAClassifier.properties -o test_classified.txt test.fasta 
```

5. Conduct leave one sequence out testing to assess classifier accuracy.

```linux
java -Xmx25g -jar  /path/to/rdp_classifier_2.13/dist/classifier.jar loot -q mytrainseq.fasta -s mytrainseq.fasta -t mytaxon.txt -l 200 -o test_200_loso_test.txt
```

## Releases



### v1.0

This version is based on the PLANiTS reference set (29_03_2020) available from https://github.com/apallavicini/PLANiTS .  Sequences were dereplicated to avoid inflating accuracy during leave one out testing.  Some taxa were edited to manage unknown (NA) and non-unique taxa to ensure a strictly hierarchical taxonomy using NCBI taxonomy as a guide.  

The v1 release can be downloaded from https://github.com/terrimporter/PLANiTS_ITSClassifier/releases/tag/v1.0 .  These files are ready to be used with the RDP classifier and were tested using v2.13.  The original files used to train the classifier v1-ref can be downloaded from https://github.com/terrimporter/PLANiTS_ITSClassifier/releases/tag/v1.0-ref and include a FASTA sequence file and taxonomy file.  

Assuming that your query sequences are present in the reference set, assignments to the genus to kingdom rank were found to be  correct at least 95% of the time (no bootstrap cutoff needed).  Assignments to the species rank, however, were found to be correct at least 70% of the time when a bootstrap support cutoff of 0.90 is used to filter query sequences that are ~ 200 bp in length.

Rank | 200 bp** to be updated  
:--- | :---:  
Kingdom | 0  
Phylum | 0  
Class | 0 
Order | 0
Family | 0
Genus | 0  
Species | 0.9  

# References

Banchi, E.; Ametrano, C.G.; Greco, S.; Stanković, D.; Muggia, L.; Pallavicini, A. PLANiTS: a curated sequence reference dataset for plant ITS DNA metabarcoding. Database 2020, 2020.

Wang, Q., Garrity, G. M., Tiedje, J. M., & Cole, J. R. (2007). Naive Bayesian Classifier for Rapid Assignment of rRNA Sequences into the New Bacterial Taxonomy. Applied and Environmental Microbiology, 73(16), 5261–5267. Available from https://sourceforge.net/projects/rdp-classifier/

Last updated: February 9, 2021
