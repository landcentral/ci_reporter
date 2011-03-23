# Copyright (c) 2006-2010 Nick Sieger <nicksieger@gmail.com>
# See the file LICENSE.txt included with the distribution for
# software license details.

require 'fileutils'

module CI #:nodoc:
  module Reporter #:nodoc:
    class ReportManager
      def initialize(prefix)
        @basedir = ENV['CI_REPORTS'] || File.expand_path("#{Dir.getwd}/#{prefix.downcase}/reports")
        @basename = "#{@basedir}/#{prefix.upcase}"
        FileUtils.mkdir_p(@basedir)
      end
      
      def write_report(suite)
        suite_name = suite.name.gsub(/[^a-zA-Z0-9]+/, '-')
        # If the name is > 180 (depends on OS) it can cause a test failure.
        if(suite_name.length > 180)
          # we want the last 180 becuase its the part that matters.
          # the first part is likely context which is important but less so
          # then the spec itself.
          suite_name = suite_name.slice((suite_name.length - 180)..suite_name.length)          
        end
        File.open("#{@basename}-#{suite_name}.xml", "w") do |f|
          f << suite.to_xml
        end
      end
    end
  end
end
