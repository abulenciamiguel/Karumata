// enable dsl2
nextflow.enable.dsl=2


// import modules
include {fastP} from '../modules/fastP.nf'


workflow {


	Channel
		.fromFilePairs(params.reads)
		.ifEmpty {error "Cannot find any reads matching: ${params.reads}"}
		.into {ch_sample}

	main:
		fastp(ch_sample)


}



