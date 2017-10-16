build:
	docker build -t ucsctreehouse/mini-var-call .

debug:
	docker run -it --rm \
		-v ~/scratch/references:/references \
		-v $(shell pwd):/inputs \
		-v ~/scratch/outputs/variants:/outputs \
		ucsctreehouse/mini-var-call \
			/references/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa \
			/inputs/jak2_example.bam \
			/outputs
	cat scratch/outputs/variants/mini.ann.vcf | md5sum -c mini.ann.md5

test:
	docker run -it --rm \
		-v ~/scratch/references:/references \
		-v ~/scratch/outputs/variants:/outputs \
		ucsctreehouse/mini-var-call \
			/references/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa \
			/app/jak2_example.bam \
			/outputs
	cat scratch/outputs/variants/mini.ann.vcf | md5sum -c mini.ann.md5
