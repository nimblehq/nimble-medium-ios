# frozen_string_literal: true

class ReportManager
  def initialize(fastlane:, output_directory:)
    @fastlane = fastlane
    @output_directory = output_directory
  end

  def produce_report(scheme:, workspace:, report_targets:, test_output_directory:)
    xccov_file_direct_path = "#{test_output_directory}/#{scheme}.xcresult"
    @fastlane.xcov(
      scheme: scheme,
      workspace: workspace,
      output_directory: @output_directory,
      xccov_file_direct_path: xccov_file_direct_path,
      include_targets: report_targets,
      markdown_report: true,
      html_report: false
    )
  end
end
