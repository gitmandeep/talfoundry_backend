module Api::V1::Concerns
  module Search
    extend ActiveSupport::Concern

    def create_search_history(search_keyword)
      search_history = @current_user.search_histories.build(keyword: search_keyword)
      search_history.save!
  end
  end
end
