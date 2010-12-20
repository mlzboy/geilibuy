module Admin::VotesHelper
  def show_vote_url(vote)
    unless vote.parent_id.blank?
      ""
    else
      "/admin/votes/#{vote.id}/sub"
    end
  end
  
  def show_vote_item_count(vote)
    if vote.parent_id
      vote.vote_details.count
    else
      ""
    end
  end
end
