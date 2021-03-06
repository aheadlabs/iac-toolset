// Generates mandatory DNS records for the Google Workspace e-mail service

resource "aws_route53_record" "dns_record_mx_google" {
    count = var.google_workspace_email == true ? 1 : 0

    provider = aws.global

    zone_id = var.zone_id
    name = ""
    records = [
        "1 aspmx.l.google.com.",
        "5 alt1.aspmx.l.google.com",
        "5 alt2.aspmx.l.google.com",
        "10 alt3.aspmx.l.google.com",
        "10 alt4.aspmx.l.google.com"
    ]
    ttl = 3600
    type = "MX"
}

resource "aws_route53_record" "dns_record_txt_google" {
    count = var.google_workspace_email == true ? 1 : 0
    
    provider = aws.global

    zone_id = var.zone_id
    name = ""
    records = [
        "google-site-verification=${var.google_workspace_site_verification}",
        "v=spf1 include:_spf.google.com ${var.spf_custom} ~all"
    ]
    ttl = 3600
    type = "TXT"
}
