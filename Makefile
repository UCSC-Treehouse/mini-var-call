build:
	docker build -t ucsctreehouse/mini-var-call .

debug:
	docker run -it --rm \
		-v ~/scratch/pipelines/references:/references \
		-v ~/scratch/outputs/variants:/outputs \
		-v `pwd`:/app \
		--entrypoint=/bin/bash \
		ucsctreehouse/mini-var-call

test:
	docker run -it --rm \
		-v ~/scratch/pipelines/references:/references \
		-v ~/scratch/outputs/variants:/outputs \
		ucsctreehouse/mini-var-call \
			/references/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa \
			/app/jak2_example.bam \
			/outputs
	diff ~/scratch/outputs/variants/mini.ann.vcf mini.ann.vcf
