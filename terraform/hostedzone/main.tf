## Create Hosted Zone and DNS records 
resource "aws_route53_zone" "primary_domain" {
  name = var.domain-name
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "hostedzone-${var.project_name}"
    enviroment = var.tag_enviroment
  }
}

# resource "null_resource" "update_name_server" {
#   provisioner "local-exec" {
#     command =  "curl -u 'dzbeda:01568a6b96d83ba121e9f63be0f729a22d58788a' 'https://api.name.com/v4/domains/zbeda.site:setNameservers' -X POST -H 'Content-Type: application/json' --data '{'nameservers':["${aws_route53_zone.primary_domain.name_servers[0]}","${aws_route53_zone.primary_domain.name_servers[1]}","${aws_route53_zone.primary_domain.name_servers[2]}","${aws_route53_zone.primary_domain.name_servers[3]}"]}'"
#   }
# }

# resource "aws_route53_record" "jenkins_record" {
#   zone_id = aws_route53_zone.primary_domain.zone_id
#   name    = "${var.jenkins-domain-name}.${var.domain-name}"
#   type    = "CNAME"
#   ttl     = "300"
#   records = [aws_alb.alb1.dns_name]
# }
# resource "aws_route53_record" "consul_record" {
#   zone_id = aws_route53_zone.primary_domain.zone_id
#   name    = "${var.consul-domain-name}.${var.domain-name}"
#   type    = "CNAME"
#   ttl     = "300"
#   records = [aws_alb.alb1.dns_name]
# }

# ## Create Certificate 
# resource "aws_acm_certificate" "zbeda_site" {
#   domain_name       = var.domain-name
#   subject_alternative_names = ["*.${var.domain-name}"]
#   validation_method = "DNS"

#   tags = {
#     Name = "certificate-${var.project_name}"
#     enviroment = var.tag_enviroment
#   }
# }

# # data "aws_route53_zone" "zbeda_site" {
# #   name         = var.domain-name
# #   private_zone = false
# # }

# resource "aws_route53_record" "zbeda_site" {
#   for_each = {
#     for dvo in aws_acm_certificate.zbeda_site.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.primary_domain.zone_id
# }

# resource "aws_acm_certificate_validation" "zbeda_site" {
#   certificate_arn         = aws_acm_certificate.zbeda_site.arn
#   validation_record_fqdns = [for record in aws_route53_record.zbeda_site : record.fqdn]
# }
# resource "time_sleep" "wait_for_certificate_verification" {
#   depends_on = [aws_acm_certificate_validation.zbeda_site]
#   create_duration = "60s"
# }