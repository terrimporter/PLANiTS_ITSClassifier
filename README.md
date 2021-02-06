# PLANiTS ITS reference set for the RDP Classifier

Here is the method I used to convert the QIIME-formatted PLANiTS files for use with the stand-alone version of the RDP classifier.  It has only been tested on the QIIME formatted PLANiTS release 29_03_2020 available from https://github.com/apallavicini/PLANiTS .  It is currently trained to the species rank.  Leave one sequence out testing is currently in progress.

The PLANiTS v1 training files and trained files ready for use with the RDP classifier are available at https://github.com/terrimporter/PLANiTS_ITSClassifier/releases .

# Overview

# Get PLANiTS data and prepare it

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

6. Edit the PLANiTS taxonomy file to handle non-unique taxa.  Ex. This often happens when an order taxon is found in more than one class, usually when the class is labelled 'NA'.

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
