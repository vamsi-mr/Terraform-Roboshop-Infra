resource "aws_acm_certificate" "ravada" {
    domain_name = "*.${var.domain_name}"
    validation_method = "DNS"

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}"
        }
    )

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_route53_record" "ravada" {
  for_each = {
    for dvo in aws_acm_certificate.ravada.domain_validation_options : dvo.domain_name => {
        name = dvo.resource_record_name
        record = dvo.resource_record_value
        type = dvo.resource_record_type
    }
  }
    allow_overwrite = true
    name = each.value.name
    records = [each.value.record]
    ttl = 60
    type = each.value.type
    zone_id = var.zone_id
}

resource "aws_acm_certificate_validation" "ravada" {
  certificate_arn = aws_acm_certificate.ravada.arn
  validation_record_fqdns = [for record in aws_route53_record.ravada : record.fqdn]
}