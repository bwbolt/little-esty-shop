class ApplicationController < ActionController::Base
  # before_action :repo_info, only: %i[index show edit new]
  #
  # def repo_info
  #   @repo_info = GithubFacade.create_repo
  #   @contributors = GithubFacade.create_contributors
  #   @pull_requests = GithubService.total_pr
  # end
end
