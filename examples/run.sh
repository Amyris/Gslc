# all examples assume that a) there's a gslc in the path and b) this is 
# being run in the current directory with the lib directory 2 directories 
# below
gslc --lib ../gslc_lib --defaultRef S288C --flat simple_fusion.txt --noprimers --ape . simple_fusion simple_fusion.gsl
gslc --lib ../gslc_lib --defaultRef S288C --flat simple_megastich.txt --ape . simple_megastitch simple_megastitch.gsl
gslc --lib ../gslc_lib --defaultRef S288C --flat simple_promoter_gene_locus.txt --ape . simple_promoter_gene_locus simple_promoter_gene_locus.gsl
#gslc --lib ../gslc_lib --defaultRef S288C --flat terpene_design.txt --ape . terpene_design terpene_design.gsl
gslc --lib ../gslc_lib --defaultRef S288C --flat allele_swap.txt --ape . allele_swap allele_swap.gsl
