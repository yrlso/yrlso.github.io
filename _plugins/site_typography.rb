# frozen_string_literal: true

require "digest"

# Attach this site's typography without replacing the gem-owned theme layouts.
Jekyll::Hooks.register [:pages, :documents], :post_render do |document|
  next unless document.output.is_a?(String) && document.output.include?("</head>")

  asset = "assets/css/site-typography.css"
  version = Digest::SHA256.file(File.join(document.site.source, asset)).hexdigest[0, 12]
  baseurl = document.site.baseurl.to_s.sub(%r{/$}, "")
  href = "#{baseurl}/#{asset}?v=#{version}"
  link = "    <link rel=\"stylesheet\" href=\"#{href}\">\n  "

  document.output = document.output.sub("</head>", "#{link}</head>")
end
