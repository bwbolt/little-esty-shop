# class GithubFacade
#   def self.create_repo
#     json = GithubService.repo_name
#     Repository.new(json)
#   end
#
#   def self.create_contributors
#     json = GithubService.contributor_info
#     people = json.map do |info|
#       Contributor.new(info) unless %w[BrianZanti timomitchel scottalexandra
#                                       jamisonordway].include?(info[:login])
#     end
#     people.delete(nil)
#     people
#   end
# end
