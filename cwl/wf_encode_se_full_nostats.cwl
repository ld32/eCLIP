#!/usr/bin/env cwltool

### Identical to wf_encode_se_full except without umi_tools dedup stats (saves lots of memory) ###

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement      # TODO needed?
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement

#hints:
#  - class: ex:ScriptRequirement
#    scriptlines:
#      - "#!/bin/bash"


inputs:
  dataset:
    type: string

  speciesGenomeDir:
    type: Directory

  repeatElementGenomeDir:
    type: Directory

  species:
    type: string

  chrom_sizes:
    type: File

  sample:
    type:
      # array of 2, one IP one Input
      type: array
      items:
        # record of SE reads and name
        type: record
        fields:
          read1:
            type: File
          name:
            type: string
          adapters:
            type: File
            
  blacklist_file:
    type: File
    
  ### repeat mapping options ###

  bowtie2_db:
    type: Directory
  bowtie2_prefix:
    type: string
  fileListFile1:
    type: File

  gencodeGTF:
    type: File
  gencodeTableBrowser:
    type: File
  repMaskBEDFile:
    type: File
  
  prefixes:
    type: string[]
    default: [
      "AA","AC","AG","AT","AN",
      "CA","CC","CG","CT","CN",
      "GA","GC","GG","GT","GN",
      "TA","TC","TG","TT","TN",
      "NA","NC","NG","NT","NN"
    ]
    
  ### region-level options ###

  trna_bed_file:
    type: File
  lncrna_table_file:
    type: File
  lncrna_full_file:
    type: File
  
outputs:


  ### Demultiplexed outputs ###


  output_ip_b1_demuxed_fastq_r1:
    type: File
    outputSource: step_ip_alignment/b1_demuxed_fastq_r1

  output_input_b1_demuxed_fastq_r1:
    type: File
    outputSource: step_input_alignment/b1_demuxed_fastq_r1


  ### Trimmed outputs ###


  output_ip_b1_trimx1_fastq:
    type: File[]
    outputSource: step_ip_alignment/b1_trimx1_fastq
  output_ip_b1_trimx1_metrics:
    type: File
    outputSource: step_ip_alignment/b1_trimx1_metrics
  output_ip_b1_trimx2_fastq:
    type: File[]
    outputSource: step_ip_alignment/b1_trimx2_fastq
  output_ip_b1_trimx2_metrics:
    type: File
    outputSource: step_ip_alignment/b1_trimx2_metrics

  output_input_b1_trimx1_fastq:
    type: File[]
    outputSource: step_input_alignment/b1_trimx1_fastq
  output_input_b1_trimx1_metrics:
    type: File
    outputSource: step_input_alignment/b1_trimx1_metrics
  output_input_b1_trimx2_fastq:
    type: File[]
    outputSource: step_input_alignment/b1_trimx2_fastq
  output_input_b1_trimx2_metrics:
    type: File
    outputSource: step_input_alignment/b1_trimx2_metrics


  ### Repeat mapping outputs ###


  output_ip_b1_maprepeats_mapped_to_genome:
    type: File
    outputSource: step_ip_alignment/b1_maprepeats_mapped_to_genome
  output_ip_b1_maprepeats_stats:
    type: File
    outputSource: step_ip_alignment/b1_maprepeats_stats
  output_ip_b1_maprepeats_star_settings:
    type: File
    outputSource: step_ip_alignment/b1_maprepeats_star_settings
  output_ip_b1_sorted_unmapped_fastq:
    type: File
    outputSource: step_ip_alignment/b1_sorted_unmapped_fastq

  output_input_b1_maprepeats_mapped_to_genome:
    type: File
    outputSource: step_input_alignment/b1_maprepeats_mapped_to_genome
  output_input_b1_maprepeats_stats:
    type: File
    outputSource: step_input_alignment/b1_maprepeats_stats
  output_input_b1_maprepeats_star_settings:
    type: File
    outputSource: step_input_alignment/b1_maprepeats_star_settings
  output_input_b1_sorted_unmapped_fastq:
    type: File
    outputSource: step_input_alignment/b1_sorted_unmapped_fastq


  ### Genomic mapping outputs ###


  output_ip_b1_mapgenome_mapped_to_genome:
    type: File
    outputSource: step_ip_alignment/b1_mapgenome_mapped_to_genome
  output_ip_b1_mapgenome_stats:
    type: File
    outputSource: step_ip_alignment/b1_mapgenome_stats
  output_ip_b1_mapgenome_star_settings:
    type: File
    outputSource: step_ip_alignment/b1_mapgenome_star_settings
  # output_ip_b1_output_sorted_bam:
  #   type: File
  #   outputSource: step_ip_alignment/b1_output_sorted_bam

  output_input_b1_mapgenome_mapped_to_genome:
    type: File
    outputSource: step_input_alignment/b1_mapgenome_mapped_to_genome
  output_input_b1_mapgenome_stats:
    type: File
    outputSource: step_input_alignment/b1_mapgenome_stats
  output_input_b1_mapgenome_star_settings:
    type: File
    outputSource: step_input_alignment/b1_mapgenome_star_settings
  # output_input_b1_output_sorted_bam:
  #   type: File
  #   outputSource: step_input_alignment/b1_output_sorted_bam


  ### Duplicate removal outputs ###


  output_ip_b1_pre_rmdup_sorted_bam:
    type: File
    outputSource: step_ip_alignment/b1_output_pre_rmdup_sorted_bam
  # output_ip_b1_barcodecollapsese_metrics:
  #   type: File
  #   outputSource: step_ip_alignment/b1_output_barcodecollapsese_metrics
  output_ip_b1_rmdup_sorted_bam:
    type: File
    outputSource: step_ip_alignment/b1_output_rmdup_sorted_bam

  output_input_b1_pre_rmdup_sorted_bam:
    type: File
    outputSource: step_input_alignment/b1_output_pre_rmdup_sorted_bam
  # output_input_b1_barcodecollapsese_metrics:
  #   type: File
  #   outputSource: step_input_alignment/b1_output_barcodecollapsese_metrics
  output_input_b1_rmdup_sorted_bam:
    type: File
    outputSource: step_input_alignment/b1_output_rmdup_sorted_bam


  ### Bigwig files ###


  output_ip_pos_bw:
    type: File
    outputSource: step_ip_alignment/output_pos_bw
  output_ip_neg_bw:
    type: File
    outputSource: step_ip_alignment/output_neg_bw

  output_input_pos_bw:
    type: File
    outputSource: step_input_alignment/output_pos_bw
  output_input_neg_bw:
    type: File
    outputSource: step_input_alignment/output_neg_bw


  ### Peak outputs ###


  output_clipper_bed:
    type: File
    outputSource: step_clipper/output_bed
  output_inputnormed_peaks:
    type: File
    outputSource: step_input_normalize_peaks/inputnormedBed
  output_compressed_peaks:
    type: File
    outputSource: step_compress_peaks/output_bed

  
  ### Downstream ###
  
  
  output_blacklist_removed_bed:
    type: File
    outputSource: step_blacklist_remove/output_blacklist_removed_bed
  output_narrowpeak:
    type: File
    outputSource: step_bed_to_narrowpeak/output_narrowpeak
  output_fixed_bed:
    type: File
    outputSource: step_fix_bed_for_bigbed_conversion/output_fixed_bed
  output_bigbed:
    type: File
    outputSource: step_bed_to_bigbed/output_bigbed
  output_entropynum:
    type: File
    outputSource: step_calculate_entropy/output_entropynum
    
  ### Repeat element outputs ###

  output_ip_concatenated_pre_rmDup_sam_file:
    type: File
    outputSource: step_rep_element_mapping/output_ip_concatenated_pre_rmDup_sam_file
  output_input_concatenated_pre_rmDup_sam_file:
    type: File
    outputSource: step_rep_element_mapping/output_input_concatenated_pre_rmDup_sam_file


  ### RMDUPED SAM FILE FINAL OUTPUTS ###

  output_barcode1_concatenated_rmDup_sam_file:
    type: File
    outputSource: step_rep_element_mapping/output_barcode1_concatenated_rmDup_sam_file
  output_input_concatenated_rmDup_sam_file:
    type: File
    outputSource: step_rep_element_mapping/output_input_concatenated_rmDup_sam_file


  ### FINAL PARSED STATISTICS FILES ###

  output_ip_parsed:
    type: File
    outputSource: step_rep_element_mapping/output_ip_parsed
  output_input_parsed:
    type: File
    outputSource: step_rep_element_mapping/output_input_parsed
  output_nopipes:
    type: File
    outputSource: step_rep_element_mapping/output_nopipes
  output_withpipes:
    type: File
    outputSource: step_rep_element_mapping/output_withpipes


  ### Region normalization outputs ###


  clipBroadFeatureCountsFile:
    type: File
    outputSource: step_region_normalization/clipBroadFeatureCountsFile

  inputBroadFeatureCountsFile:
    type: File
    outputSource: step_region_normalization/inputBroadFeatureCountsFile

  combinedOutputFile:
    type: File
    outputSource: step_region_normalization/combinedOutputFile

  l2fcWithPvalEnrFile:
    type: File
    outputSource: step_region_normalization/l2fcWithPvalEnrFile
  l2fcFile:
    type: File
    outputSource: step_region_normalization/l2fcFile


steps:

###########################################################################
# Upstream
###########################################################################

  step_ip_alignment:
    run: wf_clipseqcore_nostats_se_1barcode.cwl
    in:
      read:
        source: sample
        valueFrom: |
          ${
            return self[0];
          }
      dataset: dataset
      speciesGenomeDir: speciesGenomeDir
      repeatElementGenomeDir: repeatElementGenomeDir
      species: species
      chrom_sizes: chrom_sizes
    out: [
      b1_demuxed_fastq_r1,
      # b1_demuxed_fastq_r2,
      b1_trimx1_fastq,
      b1_trimx1_metrics,
      b1_trimx2_fastq,
      b1_trimx2_metrics,
      b1_maprepeats_mapped_to_genome,
      b1_maprepeats_stats,
      b1_maprepeats_star_settings,
      b1_sorted_unmapped_fastq,
      b1_mapgenome_mapped_to_genome,
      b1_mapgenome_stats,
      b1_mapgenome_star_settings,
      b1_output_pre_rmdup_sorted_bam,
      # b1_output_barcodecollapsese_metrics,
      b1_output_rmdup_sorted_bam,
      output_pos_bw,
      output_neg_bw
    ]

  step_input_alignment:
    run: wf_clipseqcore_nostats_se_1barcode.cwl
    in:
      read:
        source: sample
        valueFrom: |
          ${
            return self[1];
          }
      dataset: dataset
      speciesGenomeDir: speciesGenomeDir
      repeatElementGenomeDir: repeatElementGenomeDir
      species: species
      chrom_sizes: chrom_sizes
    out: [
      b1_demuxed_fastq_r1,
      # b1_demuxed_fastq_r2,
      b1_trimx1_fastq,
      b1_trimx1_metrics,
      b1_trimx2_fastq,
      b1_trimx2_metrics,
      b1_maprepeats_mapped_to_genome,
      b1_maprepeats_stats,
      b1_maprepeats_star_settings,
      b1_sorted_unmapped_fastq,
      b1_mapgenome_mapped_to_genome,
      b1_mapgenome_stats,
      b1_mapgenome_star_settings,
      b1_output_pre_rmdup_sorted_bam,
      # b1_output_barcodecollapsese_metrics,
      b1_output_rmdup_sorted_bam,
      output_pos_bw,
      output_neg_bw
    ]

  step_index_ip:
    run: samtools-index.cwl
    in:
      alignments: step_ip_alignment/b1_output_rmdup_sorted_bam
    out: [alignments_with_index]

  step_index_input:
    run: samtools-index.cwl
    in:
      alignments: step_input_alignment/b1_output_rmdup_sorted_bam
    out: [alignments_with_index]

  step_clipper:
    run: clipper.cwl
    in:
      species: species
      bam: step_ip_alignment/b1_output_rmdup_sorted_bam
      outfile:
        default: ""
    out:
      [output_bed]


###########################################################################
# Downstream - input normalization
###########################################################################

  step_ip_mapped_readnum:
    run: samtools-mappedreadnum.cwl
    in:
      input: step_ip_alignment/b1_output_rmdup_sorted_bam
      readswithoutbits:
        default: 4
      count:
        default: true
      output_name:
        default: ip_mapped_readnum.txt
    out: [output]

  step_input_mapped_readnum:
    run: samtools-mappedreadnum.cwl
    in:
      input: step_input_alignment/b1_output_rmdup_sorted_bam
      readswithoutbits:
        default: 4
      count:
        default: true
      output_name:
        default: input_mapped_readnum.txt
    out: [output]

  step_input_normalize_peaks:
    run: overlap_peakfi_with_bam_PE.cwl
    in:
      clipBamFile: step_index_ip/alignments_with_index
      inputBamFile: step_index_input/alignments_with_index
      peakFile: step_clipper/output_bed
      clipReadnum: step_ip_mapped_readnum/output
      inputReadnum: step_input_mapped_readnum/output
    out: [
      inputnormedBed,
      inputnormedBedfull
    ]

  step_compress_peaks:
    run: peakscompress.cwl
    in:
      input_bed: step_input_normalize_peaks/inputnormedBed
    out: [output_bed]
  
  step_sort_bed:
    run: sort-bed.cwl
    in:
      unsorted_bed: step_compress_peaks/output_bed
    out: [sorted_bed]
    
  step_blacklist_remove:
    run: blacklist-remove.cwl
    in:
      input_bed: step_sort_bed/sorted_bed
      blacklist_file: blacklist_file
    out: [output_blacklist_removed_bed]
    
  step_bed_to_narrowpeak:
    run: bed_to_narrowpeak.cwl
    in:
      input_bed: step_blacklist_remove/output_blacklist_removed_bed
      species: species
    out: [output_narrowpeak]
    
  step_fix_bed_for_bigbed_conversion:
    run: fix_bed_for_bigbed_conversion.cwl
    in:
      input_bed: step_blacklist_remove/output_blacklist_removed_bed
    out: [output_fixed_bed]
    
  step_bed_to_bigbed:
    run: bed_to_bigbed.cwl
    in:
      input_bed: step_fix_bed_for_bigbed_conversion/output_fixed_bed
      chrom_sizes: chrom_sizes
    out: [output_bigbed]
    
  step_calculate_entropy:
    run: calculate_entropy.cwl
    in:
      full: step_input_normalize_peaks/inputnormedBedfull
      ip_mapped: step_ip_mapped_readnum/output
      input_mapped: step_input_mapped_readnum/output
    out: [output_entropynum]
    
###########################################################################
# Downstream - repeat mapping
###########################################################################

  step_rep_element_mapping:
    run:
      repmap/wf_ecliprepmap_se.cwl
    in:
      dataset: dataset
      barcode1r1FastqGz:
        source:
          step_ip_alignment/b1_trimx2_fastq
        valueFrom: |
          ${
            return self[0];
          }
      barcode1rmRepBam: step_ip_alignment/b1_mapgenome_mapped_to_genome
      barcode1Inputr1FastqGz:
        source:
          step_input_alignment/b1_trimx2_fastq
        valueFrom: |
          ${
            return self[0];
          }
      barcode1InputrmRepBam: step_input_alignment/b1_mapgenome_mapped_to_genome
      bowtie2_db: bowtie2_db
      bowtie2_prefix: bowtie2_prefix
      fileListFile1: fileListFile1
      gencodeGTF: gencodeGTF
      gencodeTableBrowser: gencodeTableBrowser
      repMaskBEDFile: repMaskBEDFile
      prefixes: prefixes
      se_or_pe: 
        default: SE
    out:
      - output_ip_concatenated_pre_rmDup_sam_file
      - output_input_concatenated_pre_rmDup_sam_file
      - output_barcode1_concatenated_rmDup_sam_file
      - output_input_concatenated_rmDup_sam_file
      - output_ip_parsed
      - output_input_parsed
      - output_nopipes
      - output_withpipes

###########################################################################
# Downstream - region-level normalization
###########################################################################

  step_region_normalization:
    run:
      regionnormalize/wf_region_based_enrichment_SE.cwl
    in:
      clipBamFile: step_ip_alignment/b1_output_rmdup_sorted_bam
      inputBamFile: step_input_alignment/b1_output_rmdup_sorted_bam
      gencodeGTFFile: gencodeGTF
      gencodeTableBrowserFile: gencodeTableBrowser
      trna_bed_file: trna_bed_file
      lncrna_table_file: lncrna_table_file
      lncrna_full_file: lncrna_full_file
    out:
      - clipBroadFeatureCountsFile
      - inputBroadFeatureCountsFile
      - combinedOutputFile
      - l2fcWithPvalEnrFile
      - l2fcFile
