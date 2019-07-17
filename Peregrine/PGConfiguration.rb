require 'xcodeproj'
require 'yaml'
require 'json'

BUILD_PHASE_NAME_FETCH_ENV = '[Peregrine] Generator Routing Table'
BUILD_PHASE_VERION  = '1'

class PGConfiguration
  attr_accessor :dev_path  #本地开发模式路径

  def self.configure_project(installer)
    pepper = installer.sandbox.development_pods['Peregrine']
    @dev_path = pepper ? pepper.dirname.to_s : nil

    installer.analysis_result.targets.each do |target|
      if target.user_project_path.exist? && target.user_target_uuids.any?
        project = Xcodeproj::Project.open(target.user_project_path)
        project_targets = self.project_targets(project, target)
        self.add_shell_script(project_targets, project, target)
      end

    end

  end

  def self.add_shell_script(project_targets, project, target)
    install_targets = project_targets.select { |target| target.product_type == 'com.apple.product-type.application' }
    install_targets.each do |project_target|

      rubypath = (@dev_path == nil ?  "${PODS_ROOT}/Peregrine" : @dev_path) + "/Peregrine/PGGenerator.rb"

      phase = self.fetch_exist_phase(BUILD_PHASE_NAME_FETCH_ENV, project_target)
      if phase.nil?
        phase = project_target.new_shell_script_build_phase(BUILD_PHASE_NAME_FETCH_ENV)
      end

      phase.comments = BUILD_PHASE_VERION
      # phase.run_only_for_deployment_postprocessing = "1"
      phase.shell_script = 'export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
ruby "'+rubypath+'" "${PROJECT_FILE_PATH}" "${TARGET_NAME}" "${PODS_ROOT}" "${SDKROOT}" "${HEADER_SEARCH_PATHS}" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}${WRAPPER_SUFFIX}/Peregrine.bundle"'
      project.save()
    end

  end

  def self.project_targets(project, target)
    project_targets = Array.new

    target.user_target_uuids.each do |user_target_uuid|
      project.targets.each do |project_target|
        if project_target.uuid.eql? user_target_uuid
          project_targets.push(project_target)
        end
      end
    end

    return project_targets
  end

  #判断是否已存在
  def self.fetch_exist_phase(phase_name, project_target)
    project_target.build_phases.each do |build_phase|
      next if build_phase.display_name != phase_name
      #build_phase.remove_from_project
      return build_phase
    end
    return nil
  end

end
