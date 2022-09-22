#!/usr/bin/env nextflow

nextflow.enable.dsl=2


   if (params.file) { 
        file_input_ch = Channel
        .fromPath( params.file, checkIfExists: true )
        .map { file -> tuple(file.simpleName, file) }
        .view()
    }
    else if (params.folder ) { 
        folder_input_ch = Channel
        .fromPath( params.folder, checkIfExists: true, type: 'dir')
        .map { file -> tuple(file.simpleName, file) }
        .view()
    }

workflow{

        if {params.file} ( backup_cloud_upload_wf(file_input_ch) )
        if {params.folder} ( backup_cloud_upload_wf(folder_input_ch) )
}

process backup_cloud_upload_wf {
        publishDir "${params.save_path}"
        input:
        tuple val(name), file(data)

        if {params.file}
        """
        """

        if {params.folder}
        """
        """
}


/*************  
* --help
*************/
def helpMSG() {
    c_green = "\033[0;32m";
    c_reset = "\033[0m";
    c_yellow = "\033[0;33m";
    c_blue = "\033[0;34m";
    c_dim = "\033[2m";
    log.info """
    .
    ${c_yellow}Usage examples:${c_reset}
    nextflow run crawler.nf --fastq \
                            --cores 20 \
                            --max_cores 40 \
                            --output results \
                            -profile local,docker \
                            --databases /
                            --each_file

    working each-command
    nextflow run crawler.nf --fastq test_fastqs/115_stat_deep.fastq.gz --each_file test_fastqs/each_file.csv --cores 20 -profile local,docker -work-dir /media/6tb_1/work/

    """.stripIndent()
}


workflow.onComplete { 
        log.info ( workflow.success ? "\nDone! Results are stored here --> $params.output \n" : "Oops .. something went wrong" )
    
}