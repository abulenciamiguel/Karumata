process report{
	cpus 1
	container 'alfredug/rbase:v4.0.4'

	tag "Doing magic on $sample"

	
	publishDir (
	path: "${params.out_dir}/05_reports/",
	mode: 'copy',
	overwrite: 'true'
	)

    
    input:
	tuple val(sample), path(json)
	path(reportHTML)
	path(reportPDF)


    output:
    tuple val(sample), path('hivdr_*.html'), path('hivdr_*.pdf'), emit: report

    script:
    """
    Rscript -e 'rmarkdown::render("${reportHTML}", 
        params=list(
            mutation_comments="${params.sierraMutationDBComments}", 
            dr_report_hivdb="${json}",
            mutational_threshold=${params.hydraMinVariantFrequency},
            minimum_read_depth=${params.hydraMinVariantDepth},
            minimum_percentage_cons=${params.hydraConsensusPercent}), 
            output_file="hivdr_${sample}.html", output_dir = getwd())'

    Rscript -e 'rmarkdown::render("${reportPDF}", 
        params=list(
            mutation_comments="${params.sierraMutationDBComments}",
            dr_report_hivdb="${json}",
            mutational_threshold=${params.hydraMinVariantFrequency},
            minimum_read_depth=${params.hydraMinVariantDepth},
            minimum_percentage_cons=${params.hydraConsensusPercent}), 
            output_file="hivdr_${sample}.pdf", output_dir = getwd())'
    """
}