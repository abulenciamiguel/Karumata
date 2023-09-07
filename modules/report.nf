process renderReport{
    tag "$pair_id"
    publishDir params.outdir, mode: 'copy'
    
    input:
	tuple val(sample), path(json)
    path rmd from params.rmd
    path rmd_static from params.rmd_static 

    output:
    tuple val(sample), path('hivdr_*.html'), path('hivdr_*.pdf'), emit: report

    script:
    """
    Rscript -e 'rmarkdown::render("${rmd}", 
        params=list(
            mutation_comments="${params.mutation_db_comments}", 
            dr_report_hivdb="${params.outdir}/${cns_json}",
            mutational_threshold=${params.min_freq},
            minimum_read_depth=${params.min_dp},
            minimum_percentage_cons=${params.consensus_pct}), 
            output_file="hivdr_${pair_id}.html", output_dir = getwd())'

    Rscript -e 'rmarkdown::render("${rmd_static}", 
        params=list(
            mutation_comments="${params.mutation_db_comments}",
            dr_report_hivdb="${params.outdir}/${cns_json}",
            mutational_threshold=${params.min_freq},
            minimum_read_depth=${params.min_dp},
            minimum_percentage_cons=${params.consensus_pct}), 
            output_file="hivdr_${pair_id}.pdf", output_dir = getwd())'
    """
}