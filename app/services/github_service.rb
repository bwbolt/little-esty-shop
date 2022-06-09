# class GithubService
#   def self.repo_name
#     get_url('https://api.github.com/repos/bwbolt/little-esty-shop')
#   end
#
#   def self.contributor_info
#     get_url('https://api.github.com/repos/bwbolt/little-esty-shop/contributors')
#   end
#
#   def self.total_pr
#     pull_requests = get_url('https://api.github.com/repos/bwbolt/little-esty-shop/pulls?state=all&per_page=100')
#     pull_requests.count
#   end
#
#   def self.get_url(url)
#     response = HTTParty.get(url)
#     JSON.parse(response.body, symbolize_names: true)
#   end
# end
