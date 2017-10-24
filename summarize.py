#!/usr/bin/python
"""
Parses a vcf file and formats the results into a tabular format
does NOT validate the vcf:
an invalid vcf file may result in invalid parsing rather than an error message
"""
import sys
import csv


def parse_info(info):
    """ Parse vcf info section """
    items = info.split("|")
    return {
        "gene": items[5],
        "aa change": items[3],
        "type": items[1]
    }


def parse_unknown(uk):
    """ Parse the vcf 'unknown' field """
    items = uk.split(":")
    return {
     "genotype": items[0],
     "ref reads": items[2],
     "alt reads": items[4]
    }


def extra_fields(fmt, unknown):
    """ Parse the FORMAT and 'unknown' fields into key value pairs """
    fmt_fields = fmt.split(":")
    fmt_values = unknown.split(":")
    return dict(zip(fmt_fields, fmt_values))


def main(vcf):
    to_print = []
    default_FORMAT = None

    vcf_fields = ["CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO", "FORMAT", "unknown"]
    with open(vcf, "r") as f:
        reader = csv.DictReader((row for row in f if not row.startswith('#')),
                                fieldnames=vcf_fields, delimiter="\t")
        # Get the VCF fields
        for row in reader:
            if default_FORMAT:
                if not row["FORMAT"] == default_FORMAT:
                    print("ERROR! FORMAT field changed from expected!")
                    print("Got: {} Expected: {}".format(row["FORMAT"], default_FORMAT))
                    exit()
            else:
                default_FORMAT = row["FORMAT"]

            row_details = parse_info(row["INFO"])

            row_details.update(parse_unknown(row["unknown"]))
            row_details["quality"] = row["QUAL"]
            row_details["chr"] = row["CHROM"]
            row_details["pos"] = row["POS"]
            row_details["ref"] = row["REF"]
            row_details["alt"] = row["ALT"]
            row_details["quality"] = row["QUAL"]
            row_details.update(extra_fields(row["FORMAT"], row["unknown"]))

            to_print.append(row_details)

    field_order = \
        "gene,aa change,type,genotype,ref reads,alt reads,quality,chr,pos,ref,alt".split(",")
    field_order += default_FORMAT.split(":")

    print("\t".join(field_order))
    for item in to_print:
        print("\t".join(map(lambda x: item[x], field_order)))


if len(sys.argv) < 2:
    print("Usage: ./parse_vcf.py path-to-vcf-file")
    exit()

infile = sys.argv[1]
main(infile)
