module ArfPdf
  class Converter
    CONFIG = '/etc/arf_pdf/config.yaml'
    attr_reader :config

    def initialize
      @config = YAML.load_file(CONFIG)
      OpenSCAP.oscap_init
      configure_pdfkit
    rescue => e
      puts 'Config file could not be loaded'
      puts e.message
      exit(1)
    end

    def convert
      report_paths = Dir.glob(File.join(config[:reports_dir], 'arf', '**', '**', '*')).select { |r| File.file?(r) }
      nonzero_paths = skip_empty_paths report_paths
      reports_html = reports_to_html nonzero_paths
      reports_to_pdf reports_html.compact
    end

    def skip_empty_paths(report_paths)
      report_paths.map do |path|
        if File.zero?(path)
          puts "Skipping file with zero size: #{path}" if config[:verbose]
          next
        end
        path
      end
    end

    def read_arf_file(path)
      file = File.open(path)
      { :size => File.size(file), :xml => file.read }
    end

    def arf_html(path)
      arf = read_arf_file path
      xml = arf[:xml]
      size = arf[:size]
      arf_object = OpenSCAP::DS::Arf.new(:content => xml, :path => 'arf.xml.bz2', :length => size)
      # @TODO: Drop this when support for 1.8.7 ends
      return arf_object.html if RUBY_VERSION.start_with? '1.8'
      arf_object.html.force_encoding('UTF-8')
    end

    def reports_to_html(report_paths)
      report_paths.map do |path|
        out = output_path(path)
        if File.exist?(out)
          puts "Skipping file #{out}, already generated" if config[:verbose]
          next
        end
        { :path_to_save => out, :html => arf_html(path) }
      end
    end

    def reports_to_pdf(reports_html)
      reports_html.each do |report|
        create_dirs report
        kit = PDFKit.new(report[:html])
        kit.to_file(report[:path_to_save])
      end
    end

    def output_path(path)
      res = config[:output_dir] + path.split('arf')[1]
    end

    def create_dirs(report)
      FileUtils.mkdir_p report[:path_to_save].split('/')[0..-2].join('/')
    end

    def configure_pdfkit
      PDFKit.configure do |c|
        c.wkhtmltopdf = config[:wkhtmltopdf]
        c.verbose = config[:verbose]
      end
    end
  end
end
