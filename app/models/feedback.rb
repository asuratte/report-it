class Feedback < ApplicationRecord
  belongs_to :user, optional: true

  def is_active?
      return self.active_status == 'active' ? true : false
  end

  # Searches for feedbacks by attribute
  def self.feedback_search(search_type, search_term)
    feedback = Feedback.all
    if search_type == "Feedback No." && search_term.present?
      if Integer(search_term, exception: false)
        feedback = Feedback.all.where("feedbacks.id =" + search_term)
      else
        feedback = feedback.none
      end
    elsif search_type == "Username" && search_term.present?
      feedback = feedback.joins(:user).where("lower(users.username) LIKE :search_term", search_term: "%#{search_term.downcase}%")
    elsif search_type == "Status" && search_term.present?
      feedback = feedback.where("lower(feedbacks.status) LIKE ?", "%#{search_term.downcase}%")
    elsif search_type == "Category" && search_term.present?
      feedback = feedback.where("lower(feedbacks.category) LIKE :search_term", search_term: "%#{search_term.downcase}%")
    elsif search_type == "Comment" && search_term.present?
      feedback = feedback.where("lower(feedbacks.comment) LIKE ?", "%#{search_term.downcase}%")
    end
    return feedback
  end

  # Searches for feedbacks by dates
  def self.feedback_search_dates(start_date, end_date)
    feedback = Feedback.all
    if start_date.present? && end_date.present?
      feedback = feedback.where("DATE(feedbacks.created_at) >= ? AND DATE(feedbacks.created_at) <= ?", "%#{start_date}%", "%#{end_date}%")
    end
    return feedback
  end
end
