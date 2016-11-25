# ArfPdf

An unofficial script that converts Arf reports to pdf on a smart proxy.

You will need [wkhtmltopdf](http://wkhtmltopdf.org/downloads.html)

Drop `config.yml` into /etc/arf_pdf (see config/config.yaml.example for inspiration), use config to point this gem to your wkhtmltopdf and choose your output dir. Input dir should be the same as your reportsdir in /etc/foreman-proxy/config/settings.d/openscap.yaml

Make sure stuff is in your $:, Use the bin script to run.

Enjoy beautiful compliance reports in pdf format!
